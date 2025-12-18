class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imagePath;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
  });
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;
}

class Cart {
  final List<CartItem> items = [];

  void addItem(Product product) {
    final existingIndex = items.indexWhere((item) => item.product.id == product.id);
    if (existingIndex >= 0) {
      items[existingIndex].quantity++;
    } else {
      items.add(CartItem(product: product));
    }
  }

  void removeItem(String productId) {
    items.removeWhere((item) => item.product.id == productId);
  }

  void updateQuantity(String productId, int quantity) {
    final index = items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        removeItem(productId);
      } else {
        items[index].quantity = quantity;
      }
    }
  }

  double get totalPrice {
    return items.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  int get itemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  void clear() {
    items.clear();
  }
}

