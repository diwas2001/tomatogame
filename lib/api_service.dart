import 'package:http/http.dart' as http;

class ApiService {
  static Future<String> getImageUrl() async {
    final response = await http.get(Uri.parse('http://marcconrad.com/uob/tomato/api.php'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load image');
    }
  }
}
