import '../models/product.dart';

class MockProducts {
  static List<Product> getProducts() {
    return [
      Product(
        id: '1',
        name: 'Wireless Headphones',
        description: 'Premium wireless headphones with noise cancellation and 30-hour battery life.',
        price: 129.99,
        imagePath: 'assets/images/1.png',
      ),
      Product(
        id: '2',
        name: 'Smart Watch',
        description: 'Feature-rich smartwatch with fitness tracking and heart rate monitor.',
        price: 249.99,
        imagePath: 'assets/images/2.png',
      ),
      Product(
        id: '3',
        name: 'Laptop Stand',
        description: 'Ergonomic aluminum laptop stand for better posture and cooling.',
        price: 49.99,
        imagePath: 'assets/images/1.png',
      ),
      Product(
        id: '4',
        name: 'USB-C Hub',
        description: '7-in-1 USB-C hub with HDMI, USB ports, and SD card reader.',
        price: 39.99,
        imagePath: 'assets/images/2.png',
      ),
      Product(
        id: '5',
        name: 'Mechanical Keyboard',
        description: 'RGB mechanical keyboard with Cherry MX switches.',
        price: 89.99,
        imagePath: 'assets/images/1.png',
      ),
      Product(
        id: '6',
        name: 'Wireless Mouse',
        description: 'Ergonomic wireless mouse with precision tracking.',
        price: 29.99,
        imagePath: 'assets/images/2.png',
      ),
    ];
  }
}

