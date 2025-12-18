# Firebase Setup Instructions

## 1. Create .env file

Create a `.env` file in the root directory with your Firebase credentials:

```
FIREBASE_API_KEY=your_api_key_here
FIREBASE_APP_ID=your_app_id_here
FIREBASE_PROJECT_ID=your_project_id_here
FIREBASE_MESSAGING_SENDER_ID=your_messaging_sender_id_here
FIREBASE_STORAGE_BUCKET=your_storage_bucket_here
```

## 2. Firebase Firestore Structure

### Products Collection (`/products`)
Each product document should have:
- `name` (string): Product name
- `description` (string): Product description
- `price` (number): Product price
- `imagePath` (string): Path to product image (e.g., 'assets/images/1.png')

### Tasks Collection (`/tasks`)
Tasks are automatically created with the format:
- Document ID: `TASK_001`, `TASK_002`, etc.
- `assigned_to` (string): Vehicle ID (default: "vehA")
- `status` (string): Task status (default: "pending")
- `target` (object):
  - `x` (number): Latitude coordinate
  - `y` (number): Longitude coordinate

## 3. Getting Firebase Credentials

1. Go to Firebase Console: https://console.firebase.google.com/
2. Select your project
3. Go to Project Settings
4. Scroll down to "Your apps" section
5. Click on the web app icon (</>) or create a new web app
6. Copy the Firebase configuration values:
   - `apiKey` → `FIREBASE_API_KEY`
   - `appId` → `FIREBASE_APP_ID`
   - `projectId` → `FIREBASE_PROJECT_ID`
   - `messagingSenderId` → `FIREBASE_MESSAGING_SENDER_ID`
   - `storageBucket` → `FIREBASE_STORAGE_BUCKET`

## 4. Firestore Security Rules

Make sure your Firestore security rules allow read access to products and write access to tasks:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /products/{productId} {
      allow read: if true;
      allow write: if false; // Only admins can write
    }
    match /tasks/{taskId} {
      allow read: if true;
      allow create: if true; // Allow creating tasks
      allow update, delete: if false; // Only admins can update/delete
    }
  }
}
```

