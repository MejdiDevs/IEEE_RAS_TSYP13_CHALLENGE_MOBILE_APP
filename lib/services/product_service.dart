import '../models/product.dart';
import 'firebase_service.dart';

class ProductService {
  static Future<List<Product>> getProducts() async {
    try {
      print('ProductService: Fetching products...');
      final productsData = await FirebaseService.getProducts();
      print('ProductService: Received ${productsData.length} products from FirebaseService');
      
      if (productsData.isEmpty) {
        print('ProductService: WARNING - No products data received');
        return [];
      }
      
      final products = productsData.map((data) {
        print('ProductService: Processing product - ${data['name']}');
        return Product(
          id: data['id'] ?? '',
          name: data['name'] ?? 'Unknown Product',
          description: data['description'] ?? '',
          price: (data['price'] ?? 0.0).toDouble(),
          imagePath: data['imagePath'] ?? 'assets/images/1.png',
        );
      }).toList();
      
      print('ProductService: Successfully converted ${products.length} products');
      return products;
    } catch (e, stackTrace) {
      print('ProductService: ERROR loading products: $e');
      print('ProductService: Stack trace: $stackTrace');
      // Return empty list or fallback products
      return [];
    }
  }
}

