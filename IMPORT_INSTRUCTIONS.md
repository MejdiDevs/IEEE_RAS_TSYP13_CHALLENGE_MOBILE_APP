# Import Products to Firestore

## Method 1: Using the Import Script (Recommended)

### Prerequisites
1. Make sure you have created the `.env` file with your Firebase credentials
2. Ensure `products_firestore.json` is in the root directory

### Windows
Run from the project root directory:
```bash
dart run lib/scripts/import_products.dart
```

Or double-click `import_products.bat`

### Linux/Mac
Run from the project root directory:
```bash
dart run lib/scripts/import_products.dart
```

Or make it executable and run:
```bash
chmod +x import_products.sh
./import_products.sh
```

## Method 2: Manual Import via Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `ros2-multi-robot`
3. Navigate to **Firestore Database**
4. Click **Start collection** (or select existing `products` collection)
5. For each product in `products_firestore.json`:
   - Click **Add document**
   - Use **Auto-ID** for Document ID
   - Add fields:
     - `name` (string): Product name
     - `description` (string): Product description  
     - `price` (number): Product price
     - `imagePath` (string): Image URL/path

## Method 3: Using Firebase Admin SDK (Advanced)

You can write a Node.js or Python script using the Firebase Admin SDK to import the JSON file programmatically.

## Notes

- The script will automatically create documents in the `products` collection
- Each product will get an auto-generated document ID
- Make sure your `.env` file is properly configured before running the script
- The app now supports both network images (URLs) and local asset paths

