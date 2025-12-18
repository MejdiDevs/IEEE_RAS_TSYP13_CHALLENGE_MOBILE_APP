import 'package:flutter/material.dart';

class ClientSummaryPage extends StatelessWidget {
  final String name;
  final String surname;
  final String product;

  const ClientSummaryPage({
    super.key,
    required this.name,
    required this.surname,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order Summary")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order Summary",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),

            Text("Name: $name"),
            Text("Surname: $surname"),
            Text("Product: $product"),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Back"),
            )
          ],
        ),
      ),
    );
  }
}
