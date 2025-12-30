#!/bin/bash
# Build verification script for Flutter web
# This script verifies that environment variables are embedded in the build output

set -e

echo "🔍 Verifying Flutter web build..."

# Check if build directory exists
if [ ! -d "build/web" ]; then
    echo "❌ Error: build/web directory not found. Run 'flutter build web' first."
    exit 1
fi

# Check for main JavaScript file
MAIN_JS=$(find build/web -name "main*.js" | head -1)
if [ -z "$MAIN_JS" ]; then
    echo "❌ Error: main JavaScript file not found in build/web"
    exit 1
fi

echo "✓ Found main JavaScript file: $MAIN_JS"

# Check if env/prod.json exists
if [ ! -f "env/prod.json" ]; then
    echo "⚠️  Warning: env/prod.json not found. Environment variables may not be embedded."
    exit 1
fi

# Read expected values from env/prod.json (without exposing full values)
SUPABASE_URL=$(grep -o '"SUPABASE_URL": "[^"]*' env/prod.json | cut -d'"' -f4)
SUPABASE_ANON_KEY=$(grep -o '"SUPABASE_ANON_KEY": "[^"]*' env/prod.json | cut -d'"' -f4)
GOOGLE_MAPS_API_KEY=$(grep -o '"GOOGLE_MAPS_API_KEY": "[^"]*' env/prod.json | cut -d'"' -f4)

# Check if values are present
if [ -z "$SUPABASE_URL" ]; then
    echo "❌ Error: SUPABASE_URL not found in env/prod.json"
    exit 1
fi

if [ -z "$SUPABASE_ANON_KEY" ]; then
    echo "❌ Error: SUPABASE_ANON_KEY not found in env/prod.json"
    exit 1
fi

# Extract partial values for searching (first 10 chars for security)
SUPABASE_URL_PARTIAL=$(echo "$SUPABASE_URL" | cut -c1-20)
SUPABASE_ANON_KEY_PARTIAL=$(echo "$SUPABASE_ANON_KEY" | cut -c1-20)
GOOGLE_MAPS_API_KEY_PARTIAL=$(echo "$GOOGLE_MAPS_API_KEY" | cut -c1-20)

echo "🔍 Checking if environment variables are embedded in build..."

# Check for SUPABASE_URL
if grep -q "$SUPABASE_URL_PARTIAL" "$MAIN_JS" 2>/dev/null; then
    echo "✓ SUPABASE_URL appears to be embedded"
else
    echo "❌ Warning: SUPABASE_URL not found in compiled JavaScript"
    echo "   This may indicate the build did not include --dart-define-from-file=env/prod.json"
fi

# Check for SUPABASE_ANON_KEY (check for JWT pattern)
if grep -q "eyJ" "$MAIN_JS" 2>/dev/null; then
    echo "✓ SUPABASE_ANON_KEY (JWT pattern) appears to be embedded"
else
    echo "❌ Warning: SUPABASE_ANON_KEY (JWT pattern) not found in compiled JavaScript"
    echo "   This may indicate the build did not include --dart-define-from-file=env/prod.json"
fi

# Check for GOOGLE_MAPS_API_KEY
if [ -n "$GOOGLE_MAPS_API_KEY" ]; then
    if grep -q "$GOOGLE_MAPS_API_KEY_PARTIAL" "$MAIN_JS" 2>/dev/null; then
        echo "✓ GOOGLE_MAPS_API_KEY appears to be embedded"
    else
        echo "⚠️  Warning: GOOGLE_MAPS_API_KEY not found in compiled JavaScript"
        echo "   This may indicate the build did not include --dart-define-from-file=env/prod.json"
    fi
else
    echo "⚠️  GOOGLE_MAPS_API_KEY not set in env/prod.json (optional for some features)"
fi

echo ""
echo "✅ Build verification complete!"
echo ""
echo "📝 Note: This script checks for partial matches. For complete verification,"
echo "   test the app in a browser and check the console for environment variable status."

