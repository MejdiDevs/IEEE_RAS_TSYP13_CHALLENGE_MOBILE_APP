# Troubleshooting: Products Not Appearing

## Check Console Logs

When you run the app, check the console/debug output for:
- `Fetching products from Firestore...`
- `Found X products in Firestore`
- Any error messages

## Common Issues and Solutions

### 1. Firestore Security Rules

Make sure your Firestore security rules allow read access to the products collection:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /products/{productId} {
      allow read: if true;  // Allow anyone to read products
      allow write: if false; // Only admins can write
    }
  }
}
```

### 2. Collection Name

Ensure the collection is named exactly `products` (lowercase, plural).

### 3. Document Fields

Each product document must have these fields:
- `name` (string)
- `description` (string)
- `price` (number) - **Important: Must be number type, not string**
- `imagePath` (string)

### 4. Firebase Initialization

Check if Firebase is properly initialized:
- Make sure `.env` file exists with correct credentials
- Check console for "Error initializing Firebase" messages

### 5. Pull to Refresh

Try pulling down on the products list page to refresh the data.

### 6. Hot Restart

After adding products to Firestore:
- Do a **Hot Restart** (not just Hot Reload) in Flutter
- Or fully close and reopen the app

## Debug Steps

1. **Check Firestore Console**: Verify the product exists in the `products` collection
2. **Check Console Logs**: Look for error messages or product count
3. **Verify Field Types**: Make sure `price` is a number, not a string
4. **Check Security Rules**: Ensure read access is allowed
5. **Try Pull-to-Refresh**: Swipe down on the products page
6. **Restart App**: Do a full app restart

## Test Firestore Connection

You can test if Firestore is working by checking the console output when the app loads. You should see:
```
Fetching products from Firestore...
Found X products in Firestore
Product: [doc_id] - [product_name]
```

If you see "Found 0 products", check:
- Collection name is `products`
- Security rules allow read access
- Product document has correct fields

