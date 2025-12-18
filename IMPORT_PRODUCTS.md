# How to Import Products to Firestore

## Method 1: Firebase Console (Easiest - Recommended)

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project: `ros2-multi-robot`
3. Navigate to **Firestore Database**
4. Click **Start collection** (or select existing `products` collection if it exists)
5. For each product in `products_firestore.json`:
   - Click **Add document**
   - Use **Auto-ID** for Document ID (or set a custom ID)
   - Add the following fields:
     - `name` (string): Product name
     - `description` (string): Product description
     - `price` (number): Product price (make sure to select "number" type, not string)
     - `imagePath` (string): Image URL/path

### Example Document:
```
Document ID: (auto-generated)
├── name: "Wireless Headphones"
├── description: "Premium wireless headphones..."
├── price: 129.99 (number type)
└── imagePath: "https://images.unsplash.com/photo-1518445692467-5c7f0dcd8f0b"
```

## Method 2: Using Firebase CLI (Advanced)

If you have Firebase CLI installed:

1. Install Firebase CLI:
   ```bash
   npm install -g firebase-tools
   ```

2. Login:
   ```bash
   firebase login
   ```

3. Initialize Firestore (if not done):
   ```bash
   firebase init firestore
   ```

4. You can then use a script or manually import via the console.

## Method 3: Using Node.js Script (Advanced)

Create a Node.js script using Firebase Admin SDK to import the JSON file programmatically.

## Quick Copy-Paste for Firebase Console

Here are the products ready to copy:

**Product 1:**
- name: `Wireless Headphones`
- description: `Premium wireless headphones with noise cancellation and 30-hour battery life.`
- price: `129.99` (as number)
- imagePath: `https://images.unsplash.com/photo-1518445692467-5c7f0dcd8f0b`

**Product 2:**
- name: `Smart Watch`
- description: `Feature-rich smartwatch with fitness tracking and heart rate monitor.`
- price: `249.99` (as number)
- imagePath: `https://images.unsplash.com/photo-1516574187841-cb9cc2ca948b`

**Product 3:**
- name: `Laptop Stand`
- description: `Ergonomic aluminum laptop stand for better posture and cooling.`
- price: `49.99` (as number)
- imagePath: `https://images.unsplash.com/photo-1587825140708-dfaf72ae4b04`

**Product 4:**
- name: `USB-C Hub`
- description: `7-in-1 USB-C hub with HDMI, USB ports, and SD card reader.`
- price: `39.99` (as number)
- imagePath: `https://images.unsplash.com/photo-1616578273577-9d545b7b87c8`

**Product 5:**
- name: `Mechanical Keyboard`
- description: `RGB mechanical keyboard with Cherry MX switches.`
- price: `89.99` (as number)
- imagePath: `https://images.unsplash.com/photo-1517336714731-489689fd1ca8`

**Product 6:**
- name: `Wireless Mouse`
- description: `Ergonomic wireless mouse with precision tracking.`
- price: `29.99` (as number)
- imagePath: `https://images.unsplash.com/photo-1587829741301-dc798b83add3`

## Notes

- Make sure the `price` field is set as **number** type, not string
- The `imagePath` field should contain the full URL
- The app now supports both network images (URLs starting with http/https) and local assets
- After importing, restart your Flutter app to see the products

