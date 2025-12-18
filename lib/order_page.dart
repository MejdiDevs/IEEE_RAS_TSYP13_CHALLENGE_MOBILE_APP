import 'package:flutter/material.dart';
import 'tracking_page.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();

  String? _selectedProduct;

  final List<String> _products = [
    'Product A',
    'Product B',
    'Product C',
  ];

  void _submitOrder() {
    if (_formKey.currentState!.validate() && _selectedProduct != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TrackingPage(
            name: _nameController.text,
            surname: _surnameController.text,
            product: _selectedProduct!,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and select a product'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Order Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                "Client Information",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),

              // First Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) => value!.isEmpty ? 'Enter your name' : null,
              ),
              const SizedBox(height: 16),
              
              // Surname
              TextFormField(
                controller: _surnameController,
                decoration: const InputDecoration(
                  labelText: 'Surname',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) => value!.isEmpty ? 'Enter your surname' : null,
              ),
              const SizedBox(height: 16),
              
              // Product Selection
              DropdownButtonFormField<String>(
                value: _selectedProduct,
                decoration: const InputDecoration(
                  labelText: 'Select Product',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.shopping_cart),
                ),
                items: _products
                    .map((product) => DropdownMenuItem(
                          value: product,
                          child: Text(product),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProduct = value;
                  });
                },
                validator: (value) => value == null ? 'Select a product' : null,
              ),
              const SizedBox(height: 24),
              
              // Submit Button
              ElevatedButton.icon(
                onPressed: _submitOrder,
                icon: const Icon(Icons.send),
                label: const Text('Submit Order'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
