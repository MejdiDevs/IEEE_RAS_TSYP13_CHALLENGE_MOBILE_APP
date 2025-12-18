import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) {
      print('Firebase already initialized');
      return;
    }
    
    try {
      print('Initializing Firebase (using google-services.json)...');
      await Firebase.initializeApp();
      _initialized = true;
      final app = Firebase.app();
      print('✓ Firebase initialized successfully');
      print('  App name: ${app.name}');
      print('  Project ID: ${app.options.projectId}');
    } catch (e, stackTrace) {
      print('✗ Error initializing Firebase: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getProducts() async {
    try {
      // Ensure Firebase is initialized
      if (!_initialized) {
        print('Firebase not initialized, initializing now...');
        await initialize();
      }
      
      print('=== Fetching products from Firestore ===');
      print('Collection: products');
      
      final firestore = FirebaseFirestore.instance;
      print('Firestore instance: ${firestore.app.name}');
      print('Project ID: ${firestore.app.options.projectId}');
      
      final snapshot = await firestore
          .collection('products')
          .get();
      
      print('✓ Query completed');
      print('Found ${snapshot.docs.length} products in Firestore');
      
      if (snapshot.docs.isEmpty) {
        print('⚠ WARNING: No products found in Firestore collection "products"');
        print('Troubleshooting steps:');
        print('1. Check Firestore Console: https://console.firebase.google.com/');
        print('2. Verify collection name is exactly "products" (lowercase)');
        print('3. Check Firestore security rules allow read access');
        print('4. Verify product documents have fields: name, description, price, imagePath');
        print('5. Make sure price is a NUMBER type, not string');
      } else {
        print('Products found:');
        for (var doc in snapshot.docs) {
          final data = doc.data();
          print('  - Document ID: ${doc.id}');
          print('    Name: ${data['name'] ?? 'MISSING'}');
          print('    Description: ${data['description'] ?? 'MISSING'}');
          print('    Price: ${data['price']} (type: ${data['price'].runtimeType})');
          print('    ImagePath: ${data['imagePath'] ?? 'MISSING'}');
        }
      }
      
      final products = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          ...data,
        };
      }).toList();
      
      print('=== End product fetch ===');
      return products;
    } catch (e, stackTrace) {
      print('✗ ERROR fetching products: $e');
      print('Error type: ${e.runtimeType}');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  static Future<String> createTask({
    required String assignedTo,
    required double x,
    required double y,
  }) async {
    try {
      // Ensure Firebase is initialized
      if (!_initialized) {
        await initialize();
      }
      
      print('=== Creating task in Realtime Database ===');
      
      final database = FirebaseDatabase.instance;
      final tasksRef = database.ref('tasks');
      
      // Get current tasks to determine next task number
      final snapshot = await tasksRef.get();
      
      int taskNumber = 1;
      if (snapshot.exists && snapshot.value != null) {
        final tasks = snapshot.value as Map<dynamic, dynamic>;
        // Count existing tasks
        taskNumber = tasks.length + 1;
      }
      
      final taskId = 'TASK_${taskNumber.toString().padLeft(3, '0')}';
      
      // Round x and y to 2 decimal places
      final roundedX = (x * 100).roundToDouble() / 100;
      final roundedY = (y * 100).roundToDouble() / 100;
      
      print('Creating task: $taskId');
      print('  assigned_to: $assignedTo');
      print('  status: pending');
      print('  target: { x: $roundedX, y: $roundedY }');
      
      // Create task in Realtime Database
      await tasksRef.child(taskId).set({
        'assigned_to': assignedTo,
        'status': 'pending',
        'target': {
          'x': roundedX,
          'y': roundedY,
        },
      });
      
      print('✓ Task created successfully: $taskId');
      return taskId;
    } catch (e, stackTrace) {
      print('✗ Error creating task: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }
}

