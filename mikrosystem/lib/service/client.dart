import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mikrosystem/models/client.dart';

class UsersApi {
  final String baseUrl;

  UsersApi(this.baseUrl);

  Future<Client> savedClient(Map<String, dynamic> savedClient) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        body: jsonEncode(savedClient),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Client.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to save Student: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error al guardar cliente: $e');
      throw e;
    }
  }

  Future<Client> getClientById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        return Client.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to get client: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error al obtener Cliente por ID: $e');
      throw e;
    }
  }

  Future<void> activateClient(int id) async {
    try {
      final response = await http.put(Uri.parse('$baseUrl/active/$id'));

      if (response.statusCode != 200) {
        throw Exception('Failed to activate Client');
      }
    } catch (e) {
      print('Error al activar Cliente: $e');
      throw e;
    }
  }

  Future<void> inactivateClient(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode != 200) {
        throw Exception('Failed to inactivate client');
      }
    } catch (e) {
      print('Error al desactivar Cliente: $e');
      throw e;
    }
  }

  Future<void> reactivateClient(int id) async {
    try {
      final response = await http.put(Uri.parse('$baseUrl/activate/$id'));

      if (response.statusCode == 200) {
        print('Client reactivated successfully');
      } else {
        print(
            'Failed to reactivate client. Status code: ${response.statusCode}');
        throw Exception('Failed to reactivate client');
      }
    } catch (e) {
      print('Error during client reactivation: $e');
      throw e;
    }
  }

  Future<Client> updateClient(
      int id, Map<String, dynamic> updatedClientData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        body: jsonEncode(updatedClientData),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return Client.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
            'Failed to update client: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error al actualizar client: $e');
      throw e;
    }
  }

  Future<void> deleteClient(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/inactive/$id'));

      if (response.statusCode == 200) {
        print('Client logically deleted successfully');
      } else {
        print(
            'Failed to logically delete client. Status code: ${response.statusCode}');
        throw Exception('Failed to logically delete client');
      }
    } catch (e) {
      print('Error during client logical deletion: $e');
      throw e;
    }
  }

  Future<List<Client>> searchClientByName(String query) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/search?name=$query'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((client) => Client.fromJson(client)).toList();
      } else {
        throw Exception(
            'Failed to search clients by name: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in clients search by name: $e');
      throw e;
    }
  }

  Future<List<Client>> searchTCsByTypeDocument(
      String typeDocument, String value) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/type_document/$typeDocument/$value'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((client) => Client.fromJson(client)).toList();
      } else {
        throw Exception(
          'Failed to search Clients by type document: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error in Client search by type document: $e');
      throw e;
    }
  }

  Future<List<Client>> searchClientByNumberDocument(
      String numberDocument) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/number_document/$numberDocument'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((client) => Client.fromJson(client)).toList();
      } else {
        throw Exception(
          'Failed to search clients by number document: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      print('Error in client search by number document: $e');
      throw e;
    }
  }

  Future<List<Client>> getInactiveClients() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/inactive'));

      if (response.statusCode == 200) {
        final dynamic responseData = jsonDecode(response.body);

        if (responseData is List) {
          return responseData
              .map((element) => Client.fromJson(element))
              .toList();
        } else if (responseData is Map<String, dynamic> &&
            responseData.containsKey('data') &&
            responseData['data'] is List) {
          return responseData['data']
              .map((element) => Client.fromJson(element))
              .toList();
        }
      }

      throw Exception(
          'Error al obtener clientes inactivos: respuesta inesperada');
    } catch (e) {
      print('Error al obtener clientes inactivos: $e');
      throw e;
    }
  }
}

final api = UsersApi("http://192.168.1.43:8085/v1/clients");
