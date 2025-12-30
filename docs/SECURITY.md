# Security Configuration Guide

This document outlines security configurations and best practices for the Repair On Call application.

## Restriction Strategies

### Google Maps API Key Restrictions

The Google Maps API key is embedded in the client-side JavaScript bundle, which is expected for Flutter web apps. However, it must be properly restricted to prevent abuse and unauthorized usage.

#### Step-by-Step: HTTP Referrer Restrictions

**Purpose:** Limit API key usage to specific domains only.

**Configuration Steps:**
1. Navigate to [Google Cloud Console](https://console.cloud.google.com/) > APIs & Services > Credentials
2. Select your API key
3. Under "Application restrictions", select "HTTP referrers (web sites)"
4. Add the following referrers:

   **Production:**
   - `https://roc-app-149db.web.app/*`
   - `https://roc-app-149db.firebaseapp.com/*`
   - `https://roc-app-149db.web.app/` (exact match)
   - `https://roc-app-149db.firebaseapp.com/` (exact match)

   **Development (only for dev keys):**
   - `http://localhost:*`
   - `http://127.0.0.1:*`
   - `http://localhost:*/` (exact match)
   - `http://127.0.0.1:*/` (exact match)

**Important Notes:**
- Use wildcard `*` to allow all paths on a domain
- Use exact paths (without `*`) for more restrictive access
- Never add `*` without a domain (e.g., `*/*` allows all domains)
- Remove localhost restrictions from production keys

#### Step-by-Step: API Restrictions

**Purpose:** Limit which Google APIs can be called with this key.

**Configuration Steps:**
1. In the same API key settings, scroll to "API restrictions"
2. Select "Restrict key"
3. Enable **ONLY** the following APIs:
   - Maps JavaScript API (required for interactive maps)
   - Places API (New) (required for place autocomplete and details)
   - Places API (legacy fallback) (for compatibility)
   - Static Maps API (if used for static map images)

**Critical:** Do NOT enable:
- Geocoding API (unless specifically needed)
- Directions API (unless specifically needed)
- Distance Matrix API (unless specifically needed)
- Any other APIs not required by your application

#### Step-by-Step: Quota Limits

**Purpose:** Prevent excessive usage and unexpected costs.

**Configuration Steps:**
1. Navigate to APIs & Services > Dashboard
2. Select each enabled API (Maps JavaScript API, Places API, etc.)
3. Click "Quotas" tab
4. Set appropriate limits:

   **Maps JavaScript API:**
   - Daily quota: Based on expected usage (e.g., 10,000 requests/day)
   - Requests per minute: 100-500 (adjust based on traffic)

   **Places API:**
   - Daily quota: Based on expected usage (e.g., 5,000 requests/day)
   - Requests per minute: 50-200
   - Requests per 100 seconds: 100-500

   **Static Maps API:**
   - Daily quota: Based on expected usage (e.g., 1,000 requests/day)

**Recommendations:**
- Start with conservative limits and increase as needed
- Monitor usage for 1-2 weeks to understand patterns
- Set limits 20-30% above normal usage to allow for spikes
- Review and adjust quarterly

#### Step-by-Step: Billing Alerts

**Purpose:** Get notified of unusual spending before it becomes a problem.

**Configuration Steps:**
1. Navigate to Billing > Budgets & alerts
2. Click "Create Budget"
3. Set budget amount (e.g., $50/month for Maps API usage)
4. Configure alerts:
   - Alert at 50% of budget
   - Alert at 90% of budget
   - Alert at 100% of budget
5. Add email notifications (add all team members who should be notified)
6. Optionally set up SMS or Slack notifications

**Best Practices:**
- Set budget slightly above expected monthly costs
- Review and adjust budgets quarterly
- Ensure multiple team members receive alerts
- Set up alerts for both individual APIs and total project spending

#### Usage Monitoring Setup

**Configuration:**
1. Navigate to APIs & Services > Dashboard
2. Enable "API usage monitoring"
3. Set up custom alerts:
   - Unusual spike in requests (>200% of average)
   - Requests from unexpected regions (if applicable)
   - Failed requests exceeding threshold
4. Review usage reports weekly:
   - Check for unusual patterns
   - Verify requests match expected user behavior
   - Investigate any anomalies immediately

### Supabase Security Restrictions

#### Row Level Security (RLS) Policies

**Purpose:** Control data access at the database level, regardless of who has the anon key.

**Critical Requirements:**
- RLS must be enabled on ALL tables
- Policies must be tested thoroughly
- Policies should follow principle of least privilege

**Verification:**
```sql
-- Check if RLS is enabled on all tables
SELECT schemaname, tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public' 
AND rowsecurity = false;
```

**Best Practices:**
- Users can only access their own data (where applicable)
- Admin users have appropriate elevated permissions
- Public read access only where explicitly needed
- All write operations require authentication
- Test policies with different user roles

**Policy Examples:**
- Users can only see claims assigned to them
- Users can only update their own profile
- Admins can see all data
- Public can only read public information

#### Monitoring Supabase Access

**Configuration:**
1. Navigate to Supabase Dashboard > Logs
2. Enable query logging
3. Set up alerts for:
   - Unusual query patterns
   - Failed authentication attempts
   - Queries that might indicate abuse
   - Access from unexpected IP addresses

**Regular Reviews:**
- Review access logs weekly
- Check for patterns indicating unauthorized access
- Monitor for SQL injection attempts
- Verify RLS policies are working as expected

### API Key Rotation

- Rotate API keys periodically (recommended: every 6-12 months)
- When rotating:
  1. Create a new API key with the same restrictions
  2. Update `env/prod.json` with the new key
  3. Deploy the updated application
  4. Monitor for any issues
  5. After 24-48 hours of successful operation, delete the old key

## Environment Variables Security

### Production Environment Variables

The following environment variables are required for production:

- `SUPABASE_URL`: Supabase project URL (must be HTTPS)
- `SUPABASE_ANON_KEY`: Supabase anonymous key (JWT token)
- `GOOGLE_MAPS_API_KEY`: Google Maps API key

### Security Best Practices

1. **Never commit secrets to Git**
   - `env/prod.json` and `env/dev.json` are excluded via `.gitignore`
   - Only commit `env/*.example.json` files

2. **Use separate keys for development and production**
   - Development keys can have less restrictive settings
   - Production keys must have strict restrictions

3. **Rotate keys regularly**
   - Rotate API keys and Supabase keys periodically
   - Document rotation procedures

4. **Monitor for exposed keys**
   - Use secret scanning tools (GitHub secret scanning, GitGuardian, etc.)
   - If a key is exposed, rotate it immediately

## Key Management Security Model

### Understanding Client-Side Key Exposure

**Reality Check:**
Flutter web applications compile to JavaScript, and values from `String.fromEnvironment()` **ARE embedded** in the compiled JavaScript bundle. Anyone can view the source code of your deployed application and see these values.

**This is expected and acceptable** for certain key types:
- Public API keys designed for client-side use (Supabase anon key, Google Maps API key)
- Public URLs (Supabase project URL)

**This is dangerous** for secret keys:
- Service role keys (bypasses all security)
- Private API keys (unrestricted access)
- Database credentials
- Any key that grants elevated permissions

**Key Principle:** Security should not rely on key secrecy for client-side keys. Instead, security comes from:
- **Restrictions** (domain whitelisting, API restrictions, quotas)
- **Policies** (Row Level Security, access controls)
- **Monitoring** (usage alerts, anomaly detection)

### Security Model by Key Type

#### SUPABASE_ANON_KEY

✅ **Safe to expose in client-side code**

**Why it's safe:**
- Designed specifically for client-side use
- Security comes from Row Level Security (RLS) policies, not key secrecy
- Has limited permissions and respects RLS policies
- Cannot bypass database security rules

**Security Requirements:**
- Must have proper RLS policies enabled on ALL tables
- Never use service_role key in client code
- Monitor Supabase logs for suspicious activity
- Rotate periodically (every 6-12 months)

**What happens if exposed:**
- An attacker can see the key in your JavaScript bundle
- They can make API calls to your Supabase project
- **However**, RLS policies prevent unauthorized data access
- They cannot bypass RLS or access data they shouldn't see

#### GOOGLE_MAPS_API_KEY

✅ **Safe to expose in client-side code**

**Why it's safe:**
- Designed for client-side use in web applications
- Security comes from Google Cloud Console restrictions, not key secrecy
- Can be restricted by domain, API, and quota

**Security Requirements:**
- HTTP referrer restrictions (whitelist your domains only)
- API restrictions (only enable Maps, Places, Static Maps APIs)
- Quota limits (prevent abuse and unexpected costs)
- Billing alerts (detect unusual usage)

**What happens if exposed:**
- An attacker can see the key in your JavaScript bundle
- They can potentially use it to make API calls
- **However**, referrer restrictions prevent usage from unauthorized domains
- Quota limits prevent excessive usage
- Billing alerts notify you of unusual activity

#### SUPABASE_URL

✅ **Safe to expose - Public information**

**Why it's safe:**
- This is just your Supabase project URL (e.g., `https://your-project.supabase.co`)
- It's public information that anyone can discover
- No security risk from exposure
- Similar to exposing your website URL

### Prevention Strategies

#### Git Protection

**Current Protection:**
- `.gitignore` excludes `env/*.json` files (except example files)
- Only `env/*.example.json` files are committed to git
- Real keys should never be in version control

**How to Verify Keys Aren't Committed:**
```bash
# Check if any env files with real keys are tracked
git ls-files | grep "env/.*\.json" | grep -v "example"

# Search git history for potential key patterns (be careful with this)
git log -p | grep -i "supabase.*key\|google.*maps.*key"
```

**Best Practices:**
- Always use `env/*.example.json` as templates
- Never commit `env/dev.json` or `env/prod.json`
- Use secret scanning tools (GitHub secret scanning, GitGuardian)
- Review commits before pushing to ensure no keys are included

#### Build-Time Validation

**Current Protection:**
- Placeholder detection catches configuration errors
- Validation ensures keys are present and in correct format
- Error messages guide users to correct build commands

**Best Practices:**
- Always use `--dart-define-from-file=env/dev.json` for local development
- Always use `--dart-define-from-file=env/prod.json` for production builds
- Verify build with `scripts/verify_build.ps1` or `scripts/verify_build.sh`
- Test production builds locally before deploying

#### Development vs Production

**Separate Keys:**
- Use different keys for development and production
- Development keys can have less restrictions (localhost allowed)
- Production keys must have strict restrictions

**Key Management:**
- Store dev keys in `env/dev.json` (never commit)
- Store prod keys in `env/prod.json` (never commit)
- Use environment-specific restrictions in Google Cloud Console
- Rotate keys independently for dev and prod

## Supabase Security

### Row Level Security (RLS)

All tables have RLS policies enabled. Policies are defined in:
- `supabase/migrations/202511071200_rls_policies.sql`

**Critical:** RLS is your primary security mechanism. Without proper RLS policies, exposing the anon key is dangerous.

### Service Role Key

- **NEVER** use the service role key in client-side code
- Service role key bypasses RLS and should only be used in:
  - Edge functions
  - Server-side code
  - Database migrations (with caution)

**If service role key is exposed:**
- Immediately rotate it in Supabase dashboard
- Review all access logs for unauthorized usage
- Consider the key compromised and treat as security incident

### Anon Key

- The anon key is safe to use in client-side code
- It respects RLS policies
- It has limited permissions

## Security Headers

Security headers are configured via Firebase hosting. See `firebase.json` for configuration.

Recommended headers:
- `X-Frame-Options: DENY` - Prevents clickjacking
- `X-Content-Type-Options: nosniff` - Prevents MIME type sniffing
- `X-XSS-Protection: 1; mode=block` - XSS protection
- `Content-Security-Policy` - Restricts resource loading
- `Strict-Transport-Security` - Enforces HTTPS

## Input Validation

All user inputs are validated using:
- `lib/core/utils/validators.dart` - Input validation functions
- Supabase parameterized queries (prevents SQL injection)
- Flutter form validation

### XSS Prevention

- All user-generated content is sanitized before display
- Use Flutter's built-in text rendering (prevents script execution)
- Avoid using `HtmlWidget` or similar unless absolutely necessary

## Error Handling

- Never expose stack traces or internal error details to end users
- Use `getUserFriendlyErrorMessage()` from `lib/core/errors/domain_error.dart`
- Log detailed errors server-side only
- Use error tracking service (Sentry) for production monitoring

## Production Deployment Checklist

Before deploying to production:

- [ ] Google Maps API key has HTTP referrer restrictions
- [ ] Google Maps API key has API restrictions
- [ ] Quota limits are configured
- [ ] Billing alerts are set up
- [ ] Environment variables are set correctly
- [ ] No debug mode enabled (`kDebugMode` checks in place)
- [ ] No `print()` statements in production code
- [ ] Error messages are user-friendly (no stack traces)
- [ ] Security headers are configured
- [ ] RLS policies are enabled on all tables
- [ ] Input validation is in place
- [ ] Error tracking is configured (Sentry or similar)

## Monitoring & Incident Response

### Key Exposure Detection

#### Automated Detection Tools

**GitHub Secret Scanning:**
- Automatically scans commits for exposed secrets
- Alerts when keys are detected in code
- Enable in repository settings > Security > Secret scanning

**GitGuardian (Optional):**
- Third-party service for secret detection
- Scans git history and current codebase
- Provides detailed reports and alerts

**Manual Checks:**
```bash
# Check if keys are in tracked files
git ls-files | xargs grep -l "SUPABASE_ANON_KEY\|GOOGLE_MAPS_API_KEY" | grep -v example

# Search git history (be careful - may show keys in output)
git log -p --all -S "eyJ" | head -20
```

#### Monitoring Google Maps API Usage

**What to Monitor:**
- Daily request counts (should match expected user activity)
- Requests per minute (should be consistent)
- Geographic distribution (if unexpected regions appear)
- Failed requests (may indicate abuse attempts)
- Billing charges (unexpected spikes)

**Alerts to Set Up:**
- Daily quota exceeded
- Requests per minute threshold exceeded
- Billing threshold reached (50%, 90%, 100%)
- Unusual geographic patterns
- Failed request rate spike

**Review Frequency:**
- Daily: Check billing alerts and quota usage
- Weekly: Review usage patterns and geographic distribution
- Monthly: Analyze trends and adjust quotas

#### Monitoring Supabase Access

**What to Monitor:**
- Authentication attempts (successful and failed)
- Query patterns (unusual queries may indicate abuse)
- Data access patterns (users accessing data they shouldn't)
- Failed RLS policy checks (may indicate attack attempts)
- Unusual IP addresses or user agents

**Alerts to Set Up:**
- Multiple failed authentication attempts from same IP
- Queries that fail RLS checks repeatedly
- Unusual data access patterns
- Access from unexpected geographic regions

**Review Frequency:**
- Daily: Check authentication logs for suspicious activity
- Weekly: Review query patterns and data access
- Monthly: Analyze trends and verify RLS policies

### Key Rotation Procedures

#### Google Maps API Key Rotation

**When to Rotate:**
- Every 6-12 months (preventive)
- Immediately if key is exposed or compromised
- If unusual usage patterns detected
- As part of security audit

**Step-by-Step Rotation:**

1. **Create New Key:**
   - Navigate to Google Cloud Console > APIs & Services > Credentials
   - Click "Create Credentials" > "API Key"
   - Apply same restrictions as old key:
     - Copy HTTP referrer restrictions
     - Copy API restrictions
     - Set same quota limits

2. **Test New Key Locally:**
   - Update `env/dev.json` with new key
   - Test locally: `flutter run -d chrome --dart-define-from-file=env/dev.json`
   - Verify maps load correctly
   - Test place autocomplete
   - Test reverse geocoding

3. **Update Production:**
   - Update `env/prod.json` with new key
   - Build production: `flutter build web --release --dart-define-from-file=env/prod.json --base-href=/`
   - Test production build locally
   - Deploy to Firebase: `firebase deploy --only hosting`

4. **Monitor:**
   - Monitor for 24-48 hours
   - Check for errors in browser console
   - Verify API usage is normal
   - Check billing alerts

5. **Delete Old Key:**
   - After 48 hours of successful operation
   - Navigate to Google Cloud Console > Credentials
   - Delete the old API key
   - Verify no services are using it

**Rollback Procedure:**
- If issues occur, immediately revert to old key
- Update `env/prod.json` with old key
- Rebuild and redeploy
- Investigate issues before attempting rotation again

#### Supabase Anon Key Rotation

**When to Rotate:**
- Every 6-12 months (preventive)
- Immediately if key is exposed or compromised
- If suspicious database activity detected
- As part of security audit

**Step-by-Step Rotation:**

1. **Create New Anon Key:**
   - Navigate to Supabase Dashboard > Settings > API
   - Click "Reset" next to "anon public" key
   - **Important:** This immediately invalidates the old key
   - Copy the new anon key immediately

2. **Update Environment Files:**
   - Update `env/dev.json` with new anon key
   - Update `env/prod.json` with new anon key
   - **Do not commit these files to git**

3. **Test Locally:**
   - Test with dev key: `flutter run -d chrome --dart-define-from-file=env/dev.json`
   - Verify authentication works
   - Verify data access works
   - Test all major features

4. **Deploy to Production:**
   - Build: `flutter build web --release --dart-define-from-file=env/prod.json --base-href=/`
   - Deploy: `firebase deploy --only hosting`
   - Test production immediately after deployment

5. **Monitor:**
   - Monitor Supabase logs for errors
   - Check user authentication success rate
   - Verify RLS policies still work correctly
   - Monitor for 24-48 hours

**Important Notes:**
- Old anon key stops working immediately when reset
- Users will need to refresh the app to get new key
- No rollback possible - must use new key
- Ensure all environments updated simultaneously

### Incident Response Checklist

**If Key Exposure is Suspected or Confirmed:**

#### Immediate Actions (Within 1 Hour)

- [ ] **Assess the Situation:**
  - Determine which keys are exposed
  - Identify how they were exposed (git commit, public repo, etc.)
  - Assess potential impact

- [ ] **Rotate Affected Keys:**
  - Rotate Google Maps API key (if exposed)
  - Rotate Supabase anon key (if exposed)
  - Update all environment files
  - Deploy updated application immediately

- [ ] **Review Access Logs:**
  - Check Google Cloud Console for unusual API usage
  - Review Supabase logs for suspicious queries
  - Look for patterns indicating abuse
  - Document any unauthorized access

- [ ] **Secure the Source:**
  - Remove keys from git history (if committed)
  - Update `.gitignore` if needed
  - Revoke access to any exposed repositories
  - Notify team members

#### Short-Term Actions (Within 24 Hours)

- [ ] **Monitor Closely:**
  - Set up additional monitoring alerts
  - Review all access logs thoroughly
  - Check for any data breaches
  - Monitor billing for unusual charges

- [ ] **Assess Impact:**
  - Determine if any data was accessed
  - Identify affected users (if applicable)
  - Calculate potential costs from abuse
  - Document findings

- [ ] **Notify Stakeholders:**
  - Inform team members
  - Notify management (if significant impact)
  - Prepare user notification (if data compromised)

#### Long-Term Actions (Within 1 Week)

- [ ] **Document Incident:**
  - Record timeline of events
  - Document root cause
  - List remediation steps taken
  - Note lessons learned

- [ ] **Update Procedures:**
  - Review and update security procedures
  - Add additional safeguards if needed
  - Update documentation
  - Train team on prevention

- [ ] **Post-Incident Review:**
  - Conduct post-mortem meeting
  - Identify process improvements
  - Update incident response checklist
  - Schedule follow-up review

#### If Data Breach Suspected

- [ ] **Immediate:**
  - Rotate all keys immediately
  - Review all database access logs
  - Identify what data may have been accessed
  - Preserve logs for investigation

- [ ] **Legal/Compliance:**
  - Consult legal team (if applicable)
  - Check compliance requirements (GDPR, etc.)
  - Prepare breach notification (if required)
  - Document all actions taken

- [ ] **User Notification:**
  - Prepare clear, honest communication
  - Explain what happened
  - Explain what data may have been accessed
  - Provide guidance on next steps
  - Offer support resources

## Quick Security Checklists

### Before Committing Code

Use this checklist before every commit to prevent accidental key exposure:

- [ ] Verify no keys in code: `git diff | grep -i "supabase.*key\|google.*maps.*key" | grep -v example`
- [ ] Check tracked files: `git ls-files | grep "env/.*\.json" | grep -v example` (should return nothing)
- [ ] Verify `.gitignore` includes `env/*.json` (except example files)
- [ ] Review all files being committed for any hardcoded keys
- [ ] Ensure `env/dev.json` and `env/prod.json` are not in staging area
- [ ] If using IDE, verify it's not auto-committing env files

**Quick Command:**
```bash
# Run this before every commit
git status | grep "env/.*\.json" | grep -v example
# Should return nothing - if it shows files, unstage them!
```

### Before Deploying to Production

Use this checklist before every production deployment:

- [ ] **Google Maps API Key:**
  - [ ] HTTP referrer restrictions configured (production domains only)
  - [ ] API restrictions enabled (only Maps, Places, Static Maps)
  - [ ] Quota limits set appropriately
  - [ ] Billing alerts configured (50%, 90%, 100%)
  - [ ] Usage monitoring enabled

- [ ] **Supabase:**
  - [ ] RLS policies enabled on all tables
  - [ ] RLS policies tested with different user roles
  - [ ] Using anon key (NOT service_role key)
  - [ ] Access logging enabled
  - [ ] Monitoring alerts configured

- [ ] **Environment Variables:**
  - [ ] `env/prod.json` exists and contains all required keys
  - [ ] Keys are not placeholders
  - [ ] Production keys are different from dev keys
  - [ ] Build command includes `--dart-define-from-file=env/prod.json`
  - [ ] Verified build with `scripts/verify_build.ps1` or `scripts/verify_build.sh`

- [ ] **Code Security:**
  - [ ] No `print()` statements in production code
  - [ ] No debug mode enabled
  - [ ] Error messages are user-friendly (no stack traces)
  - [ ] Input validation in place
  - [ ] Security headers configured in `firebase.json`

- [ ] **Testing:**
  - [ ] Tested production build locally
  - [ ] Verified maps load correctly
  - [ ] Verified authentication works
  - [ ] Verified data access works
  - [ ] Checked browser console for errors

### Key Rotation Checklist

Use this checklist when rotating API keys:

**Pre-Rotation:**
- [ ] Document current key restrictions (screenshot or copy settings)
- [ ] Note current quota limits
- [ ] Create backup of current `env/prod.json` (store securely)
- [ ] Schedule rotation during low-traffic period
- [ ] Notify team members of planned rotation

**During Rotation:**
- [ ] Create new key with same restrictions as old key
- [ ] Test new key in development environment
- [ ] Update `env/dev.json` and test locally
- [ ] Update `env/prod.json` with new key
- [ ] Build production: `flutter build web --release --dart-define-from-file=env/prod.json --base-href=/`
- [ ] Test production build locally
- [ ] Deploy to Firebase: `firebase deploy --only hosting`
- [ ] Verify deployment works correctly

**Post-Rotation (24-48 hours):**
- [ ] Monitor for errors in browser console
- [ ] Check API usage is normal
- [ ] Verify billing alerts are working
- [ ] Review access logs for issues
- [ ] Delete old key (after confirming no issues)

**Rollback (if needed):**
- [ ] Revert to old key in `env/prod.json`
- [ ] Rebuild and redeploy immediately
- [ ] Investigate issues before retrying rotation

### Key Exposure Incident Response

Use this checklist if key exposure is suspected or confirmed:

**Immediate (Within 1 Hour):**
- [ ] Assess which keys are exposed
- [ ] Identify how keys were exposed
- [ ] Rotate affected keys immediately
- [ ] Update and deploy application
- [ ] Review access logs for abuse
- [ ] Secure the source (remove from git, etc.)

**Short-Term (Within 24 Hours):**
- [ ] Set up additional monitoring
- [ ] Review all access logs thoroughly
- [ ] Check for data breaches
- [ ] Monitor billing for unusual charges
- [ ] Assess impact and document findings
- [ ] Notify stakeholders

**Long-Term (Within 1 Week):**
- [ ] Document incident timeline
- [ ] Identify root cause
- [ ] Update security procedures
- [ ] Conduct post-mortem
- [ ] Schedule follow-up review

### Monthly Security Review

Use this checklist for monthly security reviews:

- [ ] **Google Maps API:**
  - [ ] Review usage patterns (normal vs unusual)
  - [ ] Check billing charges (any unexpected costs?)
  - [ ] Verify quota limits are appropriate
  - [ ] Review geographic distribution of requests
  - [ ] Check for failed requests (may indicate abuse)

- [ ] **Supabase:**
  - [ ] Review authentication logs
  - [ ] Check for failed RLS policy checks
  - [ ] Review query patterns
  - [ ] Verify RLS policies are working correctly
  - [ ] Check for unusual data access

- [ ] **Code & Configuration:**
  - [ ] Verify no keys in git history
  - [ ] Review `.gitignore` is correct
  - [ ] Check environment files are not committed
  - [ ] Review security headers configuration
  - [ ] Verify error handling is secure

- [ ] **Documentation:**
  - [ ] Review and update security procedures
  - [ ] Update incident response checklist if needed
  - [ ] Document any new security measures
  - [ ] Share learnings with team

### Quarterly Security Audit

Use this checklist for quarterly comprehensive audits:

- [ ] **Key Rotation:**
  - [ ] Rotate Google Maps API key (if due)
  - [ ] Rotate Supabase anon key (if due)
  - [ ] Document rotation in security log

- [ ] **Access Review:**
  - [ ] Review who has access to environment files
  - [ ] Review who has access to Google Cloud Console
  - [ ] Review who has access to Supabase dashboard
  - [ ] Remove access for former team members

- [ ] **Policy Review:**
  - [ ] Review and test all RLS policies
  - [ ] Verify Google Maps API restrictions are correct
  - [ ] Review quota limits and adjust if needed
  - [ ] Verify billing alerts are configured correctly

- [ ] **Security Updates:**
  - [ ] Review Flutter security updates
  - [ ] Review Supabase security updates
  - [ ] Review Google Cloud security best practices
  - [ ] Update dependencies for security patches

- [ ] **Incident Review:**
  - [ ] Review any security incidents from past quarter
  - [ ] Verify all incidents were properly documented
  - [ ] Check that remediation steps were completed
  - [ ] Update procedures based on learnings

## Additional Resources

- [Google Cloud API Key Security Best Practices](https://cloud.google.com/docs/authentication/api-keys)
- [Supabase Security Guide](https://supabase.com/docs/guides/auth/row-level-security)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Flutter Security Best Practices](https://docs.flutter.dev/security)

