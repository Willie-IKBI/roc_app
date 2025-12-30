# Build verification script for Flutter web (PowerShell)
# This script verifies that environment variables are embedded in the build output

Write-Host "🔍 Verifying Flutter web build..." -ForegroundColor Cyan

# Check if build directory exists
if (-not (Test-Path "build/web")) {
    Write-Host "❌ Error: build/web directory not found. Run 'flutter build web' first." -ForegroundColor Red
    exit 1
}

# Check for main JavaScript file
$mainJs = Get-ChildItem -Path "build/web" -Filter "main*.js" -Recurse | Select-Object -First 1
if (-not $mainJs) {
    Write-Host "❌ Error: main JavaScript file not found in build/web" -ForegroundColor Red
    exit 1
}

Write-Host "✓ Found main JavaScript file: $($mainJs.FullName)" -ForegroundColor Green

# Check if env/prod.json exists
if (-not (Test-Path "env/prod.json")) {
    Write-Host "⚠️  Warning: env/prod.json not found. Environment variables may not be embedded." -ForegroundColor Yellow
    exit 1
}

# Read env/prod.json
$envJson = Get-Content "env/prod.json" | ConvertFrom-Json

# Check if values are present
if (-not $envJson.SUPABASE_URL) {
    Write-Host "❌ Error: SUPABASE_URL not found in env/prod.json" -ForegroundColor Red
    exit 1
}

if (-not $envJson.SUPABASE_ANON_KEY) {
    Write-Host "❌ Error: SUPABASE_ANON_KEY not found in env/prod.json" -ForegroundColor Red
    exit 1
}

# Extract partial values for searching (first 20 chars for security)
$supabaseUrlPartial = $envJson.SUPABASE_URL.Substring(0, [Math]::Min(20, $envJson.SUPABASE_URL.Length))
$supabaseAnonKeyPartial = $envJson.SUPABASE_ANON_KEY.Substring(0, [Math]::Min(20, $envJson.SUPABASE_ANON_KEY.Length))

Write-Host "🔍 Checking if environment variables are embedded in build..." -ForegroundColor Cyan

# Read the JavaScript file content
$jsContent = Get-Content $mainJs.FullName -Raw

# Check for SUPABASE_URL
if ($jsContent -match [regex]::Escape($supabaseUrlPartial)) {
    Write-Host "✓ SUPABASE_URL appears to be embedded" -ForegroundColor Green
} else {
    Write-Host "❌ Warning: SUPABASE_URL not found in compiled JavaScript" -ForegroundColor Yellow
    Write-Host "   This may indicate the build did not include --dart-define-from-file=env/prod.json" -ForegroundColor Yellow
}

# Check for SUPABASE_ANON_KEY (check for JWT pattern)
if ($jsContent -match "eyJ") {
    Write-Host "✓ SUPABASE_ANON_KEY (JWT pattern) appears to be embedded" -ForegroundColor Green
} else {
    Write-Host "❌ Warning: SUPABASE_ANON_KEY (JWT pattern) not found in compiled JavaScript" -ForegroundColor Yellow
    Write-Host "   This may indicate the build did not include --dart-define-from-file=env/prod.json" -ForegroundColor Yellow
}

# Check for GOOGLE_MAPS_API_KEY
if ($envJson.GOOGLE_MAPS_API_KEY) {
    $mapsKeyPartial = $envJson.GOOGLE_MAPS_API_KEY.Substring(0, [Math]::Min(20, $envJson.GOOGLE_MAPS_API_KEY.Length))
    if ($jsContent -match [regex]::Escape($mapsKeyPartial)) {
        Write-Host "✓ GOOGLE_MAPS_API_KEY appears to be embedded" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Warning: GOOGLE_MAPS_API_KEY not found in compiled JavaScript" -ForegroundColor Yellow
        Write-Host "   This may indicate the build did not include --dart-define-from-file=env/prod.json" -ForegroundColor Yellow
    }
} else {
    Write-Host "⚠️  GOOGLE_MAPS_API_KEY not set in env/prod.json (optional for some features)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "✅ Build verification complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📝 Note: This script checks for partial matches. For complete verification," -ForegroundColor Cyan
Write-Host "   test the app in a browser and check the console for environment variable status." -ForegroundColor Cyan

