import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/scan_button.dart';
import 'widgets/product.dart';
import 'saved_product.dart';
import 'models.dart';
import 'conf.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  bool _isConfigReady = false;
  final List<Product> _recentProducts = [];

  @override
  void initState() {
    onConfReady.then((_) {
      setState(() {
        _isConfigReady = true;
      });
    });
    super.initState();
  }

  void _showProduct(Product product) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return ProductWidget(key: UniqueKey(), product: product);
      },
    );
  }

  void _viewSavedProducts() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SavedProductPage()),
    );
  }

  void addRecentProduct(Product product) {
    if (!_recentProducts.contains(product)) {
      setState(() {
        _recentProducts.insert(0, product);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ClipPath(
            clipper: const HeaderClipper(),
            child: Container(
              height: 180,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(246, 202, 15, 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo1.png',
                    height: 70,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Snap Fit',
                    style: GoogleFonts.epilogue(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (_isConfigReady)
            _recentProducts.isNotEmpty
                ? Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: _recentProducts.length,
                          itemBuilder: (BuildContext context, int index) {
                            final product = _recentProducts[index];
                            return ListTile(
                              leading: product.image != null
                                  ? Image.network(
                                      product.image,
                                      width: 30.0,
                                    )
                                  : const Icon(Icons.image, size: 30.0),
                              title: Text(
                                product.name ?? 'Unknown product',
                              ),
                              subtitle: Text(product.barcode ?? ''),
                              onTap: () {
                                _showProduct(product);
                              },
                            );
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _viewSavedProducts,
                        child: const Text('View Saved Products'),
                      ),
                    ],
                  )
                : Center(
                    child: Column(
                      children: [
                        const Text(
                          'No products scanned yet',
                          style: TextStyle(fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _viewSavedProducts,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(246, 202, 15, 1),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text('View Saved Products'),
                        ),
                      ],
                    ),
                  )
          else
            const CircularProgressIndicator(),
        ],
      ),
      floatingActionButton: ScanButton(key: UniqueKey()),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  const HeaderClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
