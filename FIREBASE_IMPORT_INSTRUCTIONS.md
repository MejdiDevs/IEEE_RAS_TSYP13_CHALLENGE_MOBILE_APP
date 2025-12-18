# Firestore Import Instructions

## Import Products to Firestore

### Option 1: Using Firebase Console (Recommended)

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `ros2-multi-robot`
3. Navigate to **Firestore Database**
4. Click on **Start collection** or select the existing `products` collection
5. For each product in `products_firestore.json`:
   - Click **Add document**
   - Leave Document ID as **Auto-ID** (or set a custom ID)
   - Add the following fields:
     - `name` (string): Product name
     - `description` (string): Product description
     - `price` (number): Product price
     - `imagePath` (string): Image path/URL (fill this in with your image URLs)

### Option 2: Using Firebase CLI

1. Install Firebase CLI if you haven't:
   ```bash
   npm install -g firebase-tools
   ```

2. Login to Firebase:
   ```bash
   firebase login
   ```

3. Initialize Firebase in your project (if not already done):
   ```bash
   firebase init firestore
   ```

4. Create a script to import the JSON file, or manually add documents using the Firebase Console.

### Option 3: Using Firestore REST API or Admin SDK

You can write a script to import the JSON file programmatically.

## Image Path Format

For the `imagePath` field, you can use:
- Local asset paths: `assets/images/1.png`
- Firebase Storage URLs: `gs://ros2-multi-robot.firebasestorage.app/images/product1.png`
- HTTP/HTTPS URLs: `https://example.com/images/product1.jpg`

## Example Document Structure

Each product document should look like this:

```
Document ID: (auto-generated or custom)
├── name: "Wireless Headphones"
├── description: "Premium wireless headphones..."
├── price: 129.99
└── imagePath: "assets/images/1.png" (or your image URL)
```

## Notes

- The `imagePath` field is left empty in the JSON file for you to fill in
- Make sure the `imagePath` values match where your images are stored
- If using Firebase Storage, upload images first and use the storage URLs
- If using local assets, use paths like `assets/images/1.png`

