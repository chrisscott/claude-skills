# CloudKit Reference

## Development vs. Production Environments

CloudKit has two separate environments that do **not** share data or schema:

| | Development | Production |
|---|---|---|
| Used by | Debug builds (Xcode, TestFlight internal) | App Store builds, TestFlight external |
| Schema | Editable at any time | Locked — only additive changes after first deploy |
| Data | Isolated from production | Isolated from development |
| Console URL | icloud.developer.apple.com → Development | icloud.developer.apple.com → Production |

**Key rule**: A debug build always uses the development container. An App Store or external TestFlight build always uses the production container. They never share data.

---

## Testing in Debug Builds

When you run the app from Xcode (or install via `xcrun simctl`), it automatically connects to the **development** CloudKit environment. No extra configuration is needed.

What this means in practice:
- Records created during development are invisible to App Store users, and vice versa.
- Schema changes (new record types, fields, indexes) take effect immediately in development — no deploy step required.
- You can freely delete and recreate record types in development without affecting any users.

To verify which environment an app is using:
```swift
// In your app, log the container identifier at startup
let container = CKContainer(identifier: "iCloud.com.example.AppName")
// Check CloudKit Console → Development for records created by debug builds
```

To inspect records during development:
1. Open [CloudKit Console](https://icloud.developer.apple.com)
2. Select your container
3. Choose **Development** from the environment toggle (top of page)
4. Go to **Data** → select a Record Type → query records

---

## Schema Design

### Record Types and Fields

Design record types before writing code. Changes to the production schema are additive-only — you can never delete a field or record type from production.

```
Record Type: Note
Fields:
  - title (String)
  - body (String)
  - createdAt (Date/Time)
  - ownerRef (Reference → User record)

Record Type: Tag
Fields:
  - name (String)
  - colorHex (String)
```

### Indexes

CloudKit requires explicit indexes for queries. Add them in the CloudKit Console or via schema files:

- **Queryable**: allows filtering (`WHERE field = value`)
- **Sortable**: allows `ORDER BY field`
- **Searchable**: allows full-text search (String fields only)

Without the correct index, queries will fail at runtime with `CKError.serverRejectedRequest`.

### Reference Fields

Use `CKRecord.Reference` with the appropriate delete action:
- `.deleteSelf` — deletes the child record when the parent is deleted (cascade)
- `.none` — leaves the child record orphaned

---

## Deploying Schema to Production

### When to Deploy

You **must** deploy the schema to production **before**:
- Submitting an app update to App Store Review that uses new record types or fields
- Releasing a TestFlight external build that uses new schema
- Any production user will receive the new app version

If the schema is not deployed, production users will get runtime errors when the app tries to use record types or fields that don't exist in production.

### How to Deploy

1. Open [CloudKit Console](https://icloud.developer.apple.com)
2. Select your container
3. Make sure you're viewing the **Development** environment
4. Click **Deploy Schema Changes to Production** (button in the top area of the Schema section)
5. Review the diff — it shows every record type and field being added
6. Confirm the deployment

The deploy is one-way and irreversible: once a field or record type is in production, it cannot be removed.

### What Gets Deployed

The deploy copies the **schema structure** only — no data is transferred. Each environment keeps its own data permanently isolated.

### Deploy Timing for App Store Submissions

```
Timeline for a schema-changing update:

1. Develop feature using new schema in Development environment
2. Test thoroughly with debug builds (development environment)
3. ← DEPLOY SCHEMA TO PRODUCTION ← (before anything else)
4. Archive and upload to App Store Connect
5. Submit for App Store Review
6. Release to users
```

If you reverse steps 3 and 4, App Store Review may approve the build, but production users on the new version will get CloudKit errors until you retroactively deploy — which may not be possible before the release goes live.

---

## Additive-Only Production Schema

Once a record type or field exists in production, you **cannot**:
- Delete a record type
- Delete a field
- Rename a field
- Change a field's type

You **can**:
- Add new record types
- Add new fields to existing record types
- Add new indexes

### Handling Schema Evolution

For breaking changes that feel like they require deletion:
- Add a new field with the new shape, migrate data, stop writing the old field (but leave it in the schema)
- Or create a new record type (e.g., `NoteV2`) and migrate users on first launch

Track your schema version in `AppStoreConnect.md` alongside the app version that introduced each change.

---

## Action Items Checklist (per release)

Before each App Store submission that touches CloudKit:

- [ ] All new record types and fields are tested in Development
- [ ] Indexes are added and verified (queries return expected results)
- [ ] **Schema deployed to Production** via CloudKit Console
- [ ] Verified in CloudKit Console → Production that new record types/fields are present
- [ ] App archive built after schema deploy confirmed
- [ ] App Store Connect submission uploaded

---

## Common Errors

| Error | Cause | Fix |
|---|---|---|
| `CKError.unknownItem` | Record type doesn't exist in the target environment | Deploy schema or check environment |
| `CKError.serverRejectedRequest` | Missing index for a query | Add the required index in CloudKit Console |
| `CKError.notAuthenticated` | User not signed into iCloud | Show iCloud sign-in prompt, handle gracefully |
| `CKError.quotaExceeded` | User's iCloud storage is full | Surface a clear error message to the user |
| `CKError.networkUnavailable` | No network | Queue operations with `CKModifyRecordsOperation` and retry |

---

## CloudKit Console Quick Reference

URL: [https://icloud.developer.apple.com](https://icloud.developer.apple.com)

Key sections:
- **Schema** — view/edit record types, fields, indexes; deploy to production
- **Data** — query and inspect records in either environment
- **Telemetry** — request volume, error rates, latency by operation type
- **Logs** — server-side log entries for your container (useful for debugging errors that don't surface client-side)
