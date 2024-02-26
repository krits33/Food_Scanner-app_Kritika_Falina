import 'package:flutter/material.dart';
import '../models.dart';
import '../database_helper.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({
    required Key key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: ListView(
        children: <Widget>[
          const SizedBox(height: 10.0),
          Text(
            product.name ?? 'Name not found',
            textScaleFactor: 1.8,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          Container(
            height: 200.0,
            color: Colors.grey[200],
            child: product.image != null
                ? Image.network(product.image, fit: BoxFit.cover)
                : const Center(child: Icon(Icons.image, size: 50.0)),
          ),
          const SizedBox(height: 20.0),
          Text(
            "Quantity: ${product.quantity}",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10.0),
          Card(
            elevation: 2.0,
            child: product.ingredients != null
                ? Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        const Text("Ingredients",
                            textScaleFactor: 1.5, textAlign: TextAlign.center),
                        const SizedBox(height: 10.0),
                        Text(product.ingredients, textAlign: TextAlign.center),
                        const SizedBox(height: 10.0),
                        if (product.ingredientsImage.isNotEmpty ?? false)
                          Image.network(product.ingredientsImage),
                      ],
                    ),
                  )
                : const SizedBox(),
          ),
          const SizedBox(height: 10.0),
          if (product.origins.isNotEmpty ||
              product.manufacturingPlaces.isNotEmpty)
            Card(
              elevation: 2.0,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    const Text("Provenance", textScaleFactor: 1.5),
                    const SizedBox(height: 10.0),
                    if (product.origins.isNotEmpty)
                      Text("Origins: ${product.origins}",
                          textAlign: TextAlign.center),
                    if (product.manufacturingPlaces.isNotEmpty)
                      Text(
                        "Manufacturing places: ${product.manufacturingPlaces}",
                        textAlign: TextAlign.center,
                      ),
                    const SizedBox(height: 10.0),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.calendar_view_day),
              Text(" ${product.barcode ?? 'Barcode not found'}")
            ],
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              DatabaseHelper.saveProduct(product);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Product saved'),
                    behavior: SnackBarBehavior.floating),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellow[700], // set button color
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('Save Product'),
          ),
          const SizedBox(height: 40.0),
        ],
      ),
    );
  }
}
