import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'models.dart';
import 'widgets/product.dart';

class SavedProductPage extends StatefulWidget {
  const SavedProductPage({super.key});

  @override
  _SavedProductPageState createState() => _SavedProductPageState();
}

class _SavedProductPageState extends State<SavedProductPage> {
  List<Product> savedProducts = [];

  @override
  void initState() {
    super.initState();
    fetchSavedProducts();
  }

  void fetchSavedProducts() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    List<Product> products = await databaseHelper.getSavedProducts();
    setState(() {
      savedProducts = products;
    });
  }

  void removeProduct(Product product) {
    DatabaseHelper.removeProduct(product);
    fetchSavedProducts();
  }

  void renameProduct(Product product, String newName) {
    DatabaseHelper.updateProductName(product.barcode, newName);
    fetchSavedProducts();
  }

  void _showProduct(Product product) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return ProductWidget(key: UniqueKey(), product: product);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Products'),
      ),
      body: ListView.builder(
        itemCount: savedProducts.length,
        itemBuilder: (context, index) {
          Product product = savedProducts[index];
          return ListTile(
            leading: product.image != null
                ? Image.network(
                    product.image,
                    width: 30.0,
                  )
                : const Icon(Icons.image, size: 30.0),
            title: Text(product.name),
            subtitle: Text(product.barcode),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    String newName = product.name;
                    // Show dialog to rename product
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Rename Product'),
                        content: TextField(
                          onChanged: (value) {
                            setState(() {
                              newName = value; // Update the newName variable
                            });
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                // Update the product name with the new name
                                renameProduct(product, newName);
                              });
                              Navigator.pop(context);
                            },
                            child: const Text('Save'),
                          )
                        ],
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    removeProduct(product);
                  },
                ),
              ],
            ),
            onTap: () {
              _showProduct(product);
            },
          );
        },
      ),
    );
  }
}
