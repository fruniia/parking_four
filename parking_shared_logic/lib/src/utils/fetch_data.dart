import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

Future<T> fetchData<T>({
  required String url,
  required String method,
  Map<String, String>? headers,
  dynamic body,
  required T Function(dynamic) fromJson,
}) async {
  try {
    final uri = Uri.parse(url);
    late http.Response response;

    switch (method) {
      case 'POST':
        response = await http.post(
          uri,
          headers: headers ?? {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        );
        break;
      case 'PUT':
        response = await http.put(
          uri,
          headers: headers ?? {'Content-Type': 'application/json'},
          body: jsonEncode(body),
        );
        break;
      case 'DELETE':
        response = await http.delete(
          uri,
          headers: headers ?? {'Content-Type': 'application/json'},
        );
        break;
      case 'GET':
        response = await http.get(
          uri,
          headers: headers ?? {'Content-Type': 'application/json'},
        );
        break;
      default:
        throw Exception('Unknown HTTP method: $method');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final data = jsonDecode(response.body);

        switch (method) {
          case 'DELETE':
            print('$T deleted');
            break;
          case 'PUT':
            print('$T updated');
            break;
          case 'POST':
            print('$T created');
            break;
          case 'GET':
            break;
          default:
            print('Unknown HTTP method: $method');
        }

        return fromJson(data);
      } catch (e) {
        throw Exception('Failed to parse response body');
      }
    } else {
      throw Exception(
          'Request failed with status: ${response.statusCode}, Body: ${response.body}');
    }
  } catch (e) {
    if (e is SocketException) {
      throw Exception(
          'Network error: Unable to reach server. Check your connection');
    } else if (e is http.ClientException) {
      print('Error in fetchData: $e');
      throw Exception(
          'Network error: Unable to reach the server. Check your connection');
    } else if (e is FormatException) {
      throw Exception(
          'Error parsing response from server. Please try again later');
    } else {
      throw Exception('An unexpected error occured: $e');
    }
  }
}
