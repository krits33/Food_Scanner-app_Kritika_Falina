import 'package:flutter/material.dart';
import 'conf.dart';
import 'scan.dart';
import 'product.dart';
import 'upload_image.dart';
import 'index.dart';

final routes = {
  '/index': (BuildContext context) => const IndexPage(),
  '/scan': (BuildContext context) => const ScanPage(),
  '/uploadImage': (BuildContext context) => const UploadImagePage(),
  '/product': (BuildContext context) {
    final String barcode = ModalRoute.of(context)?.settings.arguments as String;
    return ProductPage(key: UniqueKey(), barcode: barcode);
  },
};

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Scan App',
      routes: routes,
      home: const IndexPage(),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initConf();
  runApp(const MyApp());
}
