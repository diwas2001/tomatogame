import 'package:http/http.dart' as http;

/// A class for making API requests related to image retrieval.
class ApiService {
  /// Asynchronous method to get the image URL from the specified API.
  ///
  /// Returns a [Future] containing a [String] representing the image URL.
  ///
  /// Throws an [Exception] if the API request fails or the response status code is not 200.
  static Future<String> getImageUrl() async {
    final response =
        await http.get(Uri.parse('http://marcconrad.com/uob/tomato/api.php'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load image');
    }
  }
}
