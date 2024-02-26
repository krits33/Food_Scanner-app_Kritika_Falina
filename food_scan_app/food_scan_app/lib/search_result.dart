import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'models.dart';

// Creating a Dio instance with options.
var dio = Dio(BaseOptions(
  baseUrl: "https://world.openfoodfacts.org/cgi/",
  connectTimeout: const Duration(milliseconds: 5000),
  receiveTimeout: const Duration(milliseconds: 5000),
));

class SearchResultsPage extends StatefulWidget {
  final String productName;

  const SearchResultsPage({super.key, required this.productName});

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late List<Product> _searchResults;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSearchResults();
  }

  Future<void> _fetchSearchResults() async {
    String url = "search.pl?search_terms=${widget.productName}&json=1";

    try {
      Response response = await dio.get(url);

      // Parse the response and extract search results
      if (response.statusCode == 200 && response.data != null) {
        setState(() {
          _searchResults = (response.data['products'] as List)
              .map((json) => Product.fromJson(json))
              .toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (e) {
      print('Error fetching search results: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Results'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _searchResults.isEmpty
              ? const Center(child: Text('No results found'))
              : ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    Product product = _searchResults[index];
                    return ListTile(
                      leading: product.image != null
                          ? Image.network(product.image, width: 30.0)
                          : const Icon(Icons.image, size: 30.0),
                      title: Text(product.name ?? 'Unknown'),
                      subtitle: Text(product.barcode ?? ''),
                      onTap: () {
                        Navigator.pushNamed(context, '/product',
                            arguments: product.barcode);
                      },
                    );
                  },
                ),
    );
  }
}
