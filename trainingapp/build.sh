#!/bin/bash

# Script to generate Hive type adapters
# Run this script after making changes to Hive models

echo "🔨 Building Hive type adapters..."
echo ""

# Clean previous build artifacts
echo "Cleaning previous build artifacts..."
flutter pub run build_runner clean

# Generate the type adapters
echo ""
echo "Generating type adapters..."
flutter pub run build_runner build --delete-conflicting-outputs

echo ""
echo "✅ Build complete! The workout_model.g.dart file has been generated."
echo ""
echo "You can now run the app with: flutter run"
