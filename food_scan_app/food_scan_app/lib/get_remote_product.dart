import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'models.dart';
import 'conf.dart';

// Creating a Dio instance with options.
var dio = Dio(BaseOptions(
  baseUrl: "https://world.openfoodfacts.org/api/v0/",
  connectTimeout: const Duration(milliseconds: 5000),
  receiveTimeout: const Duration(milliseconds: 5000),
));

/// Fetches product information from the remote API based on the provided barcode.
/// Throws a [DioException ] if the request fails or if the response is not as expected.
Future<Product> getRemoteProduct(BuildContext context, String barcode) async {
  log.d("Getting product $barcode");
  String url = "product/$barcode.json"; // The base URL is set in Dio options.

  try {
    Response response = await dio.get(url);

    // Check if the response data is not null and contains the expected fields.
    if (response.data != null && response.data["status"] != null) {
      return Product.fromJson(response.data);
    } else {
      throw DioException(
        requestOptions: RequestOptions(path: url),
        response: response,
        error: "Invalid response format",
      );
    }
  } on DioException catch (e) {
    // Handle Dio errors by displaying an error screen.
    errorScreen("Can not download product info: ${e.message}",
        context: context);
    rethrow; // Rethrow the DioError to indicate failure.
  }
}
