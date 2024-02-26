import 'package:flutter/material.dart';
import 'models.dart';
import 'get_remote_product.dart';
import 'widgets/product.dart';

class ProductPage extends StatefulWidget {
  final String barcode;

  const ProductPage({super.key, required this.barcode});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late Future<Product> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = getRemoteProduct(context, widget.barcode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
      ),
      body: FutureBuilder<Product>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.red,
                  ),
                  SizedBox(height: 20),
                  Text('Error fetching product details',
                      style: TextStyle(fontSize: 20)),
                ],
              ),
            );
          } else if (!snapshot.hasData || !snapshot.data!.productFound) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning,
                    size: 60,
                    color: Colors.yellow,
                  ),
                  SizedBox(height: 20),
                  Text('Product details not found',
                      style: TextStyle(fontSize: 20)),
                ],
              ),
            );
          } else {
            Product product = snapshot.data!;
            return ProductWidget(key: UniqueKey(), product: product);
          }
        },
      ),
    );
  }
}
