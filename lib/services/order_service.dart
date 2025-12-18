import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class Order {
  final String id;
  final String fullName;
  final String phone;
  final List<CartItem> items;
  final double totalPrice;
  final DateTime orderDate;
  final double latitude;
  final double longitude;
  final String status;

  Order({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.items,
    required this.totalPrice,
    required this.orderDate,
    required this.latitude,
    required this.longitude,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phone': phone,
      'items': items.map((item) => {
        'productId': item.product.id,
        'productName': item.product.name,
        'quantity': item.quantity,
        'price': item.product.price,
      }).toList(),
      'totalPrice': totalPrice,
      'orderDate': Timestamp.fromDate(orderDate),
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
    };
  }

  factory Order.fromMap(String id, Map<String, dynamic> map) {
    return Order(
      id: id,
      fullName: map['fullName'] ?? '',
      phone: map['phone'] ?? '',
      items: [], // Will be populated separately if needed
      totalPrice: (map['totalPrice'] ?? 0.0).toDouble(),
      orderDate: (map['orderDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      status: map['status'] ?? 'pending',
    );
  }
}

class OrderService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<String> saveOrder({
    required String fullName,
    required String phone,
    required List<CartItem> items,
    required double totalPrice,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final orderData = {
        'fullName': fullName,
        'phone': phone,
        'items': items.map((item) => {
          'productId': item.product.id,
          'productName': item.product.name,
          'quantity': item.quantity,
          'price': item.product.price,
        }).toList(),
        'totalPrice': totalPrice,
        'orderDate': FieldValue.serverTimestamp(),
        'latitude': latitude,
        'longitude': longitude,
        'status': 'pending',
      };

      final docRef = await _firestore.collection('orders').add(orderData);
      return docRef.id;
    } catch (e) {
      print('Error saving order: $e');
      rethrow;
    }
  }

  static Future<List<Order>> getOrders() async {
    try {
      final snapshot = await _firestore
          .collection('orders')
          .orderBy('orderDate', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        return Order.fromMap(doc.id, doc.data());
      }).toList();
    } catch (e) {
      print('Error getting orders: $e');
      return [];
    }
  }
}

