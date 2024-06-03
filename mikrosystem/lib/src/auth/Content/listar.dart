import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mikrosystem/models/client.dart';
import 'package:mikrosystem/models/district.dart';
import 'package:mikrosystem/service/client.dart';
import 'dart:convert';

import 'package:mikrosystem/service/district.dart';

class Lista extends StatefulWidget {
  const Lista({Key? key}) : super(key: key);

  @override
  _ListaState createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  List<Client> _filteredClients = [];
  late Future<List<Client>> clients;
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final cellphoneController = TextEditingController();
  final emailController = TextEditingController();
  final typeDocumentController = TextEditingController();
  final documentNumberController = TextEditingController();
  final districtController = TextEditingController();
  final addressController = TextEditingController();
  final stateController = TextEditingController();
  bool _showInactive = false;

// Paso 1: Agrega la función compareByLastName
  int compareByLastName(Client a, Client b) {
    return a.last_name.compareTo(b.last_name);
  }

  @override
  void initState() {
    super.initState();
    clients = _getClient();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      stateController.text = 'A';
    });
  }

  Future<List<Client>> _getClient() async {
    try {
      if (_showInactive) {
        return _filterByActive(await api.getInactiveClients());
      }

      String searchQuery = _searchController.text.toLowerCase();
      if (searchQuery.isEmpty) {
        return _filterByActive(await getClient());
      }

      if (searchQuery.startsWith('dni') || searchQuery.startsWith('cne')) {
        String typeDocument = searchQuery.substring(0, 3).toUpperCase();
        String value = searchQuery.substring(3);
        return _filterByActive(
            await api.searchTCsByTypeDocument(typeDocument, value));
      }

      return _filterByActive(await api.searchClientByName(searchQuery));
    } catch (e) {
      print('Error al obtener client: $e');
      throw e;
    }
  }

  bool _isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  List<Client> _filterByActive(List<Client> clients) {
    var filteredList = clients.where((client) {
      // Aplica el filtro de búsqueda y de usuarios activos o inactivos
      return (client.name
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) ||
              client.last_name
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase())) &&
          (_showInactive ? client.state == 'I' : client.state == 'A');
    }).toList();

    // Ordena la lista por apellidos de manera ascendente
    filteredList.sort(compareByLastName);

    return filteredList;
  }

  //encabezado
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text(
          'Lista de cliente',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 34, 117, 172),
        elevation: 5,
        shadowColor: Color.fromARGB(255, 255, 255, 255),
        toolbarHeight: 80,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.black), // Borde negro
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: _searchController,
                      autofocus: false,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        labelText: 'Buscar',
                        hintText: 'Buscar usuarios...',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {},
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(
                    value: _showInactive,
                    onChanged: (value) {
                      setState(() {
                        _showInactive = value;
                        clients = _getClient();
                      });
                    },
                  ),
                ),
                Text(_showInactive ? 'Inactivos' : 'Activos'),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                try {
                  setState(() {
                    clients = _getClient();
                  });
                } catch (e) {
                  print('Error al actualizar usuarios: $e');
                }
              },
              child: FutureBuilder<List<Client>>(
                future: clients,
                builder: (context, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snap.hasError) {
                    return Center(
                      child: Text("Ups, hubo un error: ${snap.error}"),
                    );
                  } else if (snap.hasData) {
                    _filteredClients = _filterByActive(snap.data!);
                    return ListView.builder(
                      itemCount: _filteredClients.length,
                      itemBuilder: (context, i) {
                        return InkWell(
                          onTap: () {
                            showDetailsDialog(_filteredClients[i]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${_filteredClients[i].last_name} ${_filteredClients[i].name}",
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Tipo de Documento: ${_filteredClients[i].type_document}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      "Número de Documento: ${_filteredClients[i].document_number}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Celular: ${_filteredClients[i].cellphone}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        PopupMenuButton<String>(
                                          onSelected: (value) {
                                            if (value == 'details') {
                                              showDetailsDialog(
                                                  _filteredClients[i]);
                                            }
                                          },
                                          itemBuilder: (BuildContext context) =>
                                              [
                                            PopupMenuItem(
                                              value: 'details',
                                              child: Row(
                                                children: const [
                                                  Icon(Icons.info_outline),
                                                  SizedBox(width: 8),
                                                  Text('Detalles'),
                                                ],
                                              ),
                                            ),
                                          ],
                                          icon: const Icon(Icons.more_vert),
                                        ),
                                        if (_filteredClients[i].state == 'I')
                                          ElevatedButton(
                                            onPressed: () {
                                              reactivateUser(
                                                  _filteredClients[i]);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color.fromARGB(
                                                      255, 255, 255, 255),
                                            ),
                                            child: const Text("Restaurar"),
                                          ),
                                        if (_filteredClients[i].state ==
                                            'A') ...[
                                          ElevatedButton(
                                            onPressed: () {
                                              showEditDialog(
                                                  _filteredClients[i]);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.deepOrangeAccent,
                                            ),
                                            child: const Text("Editar"),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              showDeleteDialog(
                                                  _filteredClients[i]);
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                        child: Text("No hay datos disponibles"));
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showForm,
        child: const Icon(Icons.add),
      ),
    );
  }

/*FUNCION DE DETALLE*/
  void showDetailsDialog(Client client) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              SizedBox(width: 10),
              Text("Detalles del cliente"),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text("Nombre"),
                  subtitle: Text(client.name),
                ),
                ListTile(
                  title: Text("Apellido"),
                  subtitle: Text(client.last_name),
                ),
                ListTile(
                  title: Text("Tipo de Documento"),
                  subtitle: Text(client.type_document),
                ),
                ListTile(
                  title: Text("Número de Documento"),
                  subtitle: Text(client.document_number),
                ),
                ListTile(
                  title: Text("Email"),
                  subtitle: Text(client.email),
                ),
                ListTile(
                  title: Text("Celular"),
                  subtitle: Text(client.cellphone),
                ),
                ListTile(
                  title: Text("Distrito"),
                  subtitle: Text("${client.district.name}"),
                ),
                ListTile(
                  title: Text("Direccion"),
                  subtitle: Text(client.address),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                overlayColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered)) {
                      return Colors.blueAccent;
                    }
                    return Colors.transparent;
                  },
                ),
              ),
              child: const Text("Cerrar"),
            ),
          ],
        );
      },
    );
  }

/*FUNCION DE DETALLE*/
/*FUNCION EDITAR*/
  void showEditDialog(Client client) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController nameController =
            TextEditingController(text: client.name);
        final TextEditingController lastNameController =
            TextEditingController(text: client.last_name);
        final TextEditingController typeDocumentController =
            TextEditingController(text: client.type_document);
        final TextEditingController documentNumberController =
            TextEditingController(text: client.document_number);
        final TextEditingController emailController =
            TextEditingController(text: client.email);
        final TextEditingController cellphoneController =
            TextEditingController(text: client.cellphone);
        final TextEditingController districtController =
            TextEditingController(text: client.district.name);
        final TextEditingController addressController =
            TextEditingController(text: client.address);

        return AlertDialog(
          title: const Text("Editar Cliente"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  keyboardType: TextInputType.text,
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Nombre"),
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: lastNameController,
                  decoration: const InputDecoration(labelText: "Apellido"),
                ),
                DropdownButtonFormField<String>(
                  value: typeDocumentController.text.isNotEmpty
                      ? typeDocumentController.text
                      : 'DNI',
                  onChanged: (String? newValue) {
                    setState(() {
                      typeDocumentController.text = newValue!;
                    });
                  },
                  items: <String>['DNI', 'CNE']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Documento',
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: documentNumberController,
                  decoration: const InputDecoration(
                    labelText: "Numero de Documento",
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: cellphoneController,
                  decoration: const InputDecoration(labelText: "Celular"),
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: districtController,
                  decoration: const InputDecoration(labelText: "Distrito"),
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: addressController,
                  decoration: const InputDecoration(labelText: "Dirección"),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                Map<String, dynamic> updatedClientData = {
                  "name": nameController.text,
                  "last_name": lastNameController.text,
                  "type_document": typeDocumentController.text,
                  "document_number": documentNumberController.text,
                  "email": emailController.text,
                  "cellphone": cellphoneController.text,
                  "district_id": int.parse(districtController.text),
                  "address": addressController.text,
                };

                try {
                  await api.updateClient(client.id!, updatedClientData);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cliente actualizado exitosamente'),
                    ),
                  );

                  setState(() {
                    clients = _getClient();
                  });

                  Navigator.of(context).pop();
                } catch (e) {
                  print('Error al actualizar el cliente: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error al actualizar el cliente'),
                    ),
                  );
                }
              },
              child: const Text("Guardar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }
/*FUNCION FINAL EDITAR*/

/*FUNCION ELIMINAR  CLIENT */
  void showDeleteDialog(Client client) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Eliminar Cliente"),
          content: Text("¿Estás seguro que deseas eliminar a ${client.name}?"),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await api.deleteClient(client.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Usuario eliminado exitosamente'),
                    ),
                  );
                  Navigator.of(context).pop();
                  setState(() {
                    clients = _getClient();
                  });
                } catch (e) {
                  print('Error al eliminar el usuario: $e');
                }
              },
              child: const Text("Eliminar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }

/*LISTAR CLIENTE*/
  Future<List<Client>> getClient() async {
    try {
      final res = await http
          .get(Uri.parse("http://192.168.1.43:8085/v1/clients/active"));
      final dynamic responseData =
          jsonDecode(utf8.decode(res.bodyBytes)); /*CODIGO PARA UTF8*/

      if (responseData is List) {
        var allUsers =
            responseData.map((element) => Client.fromJson(element)).toList();
        allUsers.sort(compareByLastName);
        return allUsers;
      } else if (responseData is Map<String, dynamic>) {
        if (responseData.containsKey('data') && responseData['data'] is List) {
          var allUsers = responseData['data']
              .map((element) => Client.fromJson(element))
              .toList();
          allUsers.sort(compareByLastName);
          return allUsers;
        }
      }
      throw Exception('Error al obtener usuarios: respuesta inesperada');
    } catch (e) {
      print('Error al obtener usuarios: $e');
      throw e;
    }
  }

/*FUNCION REACTIVAR*/
  void reactivateUser(Client client) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Reactivar Cliente"),
          content: Text("¿Estás seguro que deseas reactivar a ${client.name}?"),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await api.reactivateClient(client.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Usuario reactivado exitosamente'),
                    ),
                  );
                  Navigator.of(context).pop();
                  setState(() {
                    clients = _getClient();
                  });
                } catch (e) {
                  print('Error al reactivar el usuario: $e');
                }
              },
              child: const Text("Reactivar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
          ],
        );
      },
    );
  }

// GUARDADO FUNCION
  void saveClient() async {
    // Verificar que todos los campos obligatorios estén llenos
    if (nameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        documentNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, completa todos los campos obligatorios'),
        ),
      );
      return;
    }

    // Verificar que el campo LAST_NAME no esté vacío
    if (lastNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, completa el campo Apellido'),
        ),
      );
      return;
    }

    final clientData = {
      "name": nameController.text,
      "last_name": lastNameController.text,
      "type_document": typeDocumentController.text,
      "document_number": documentNumberController.text,
      "district": {
        "id": int.tryParse(districtController.text) ?? 0,
      },
      "address": addressController.text,
      "email": emailController.text,
      "cellphone": cellphoneController.text,
      "state": 'A',
    };

    print("Client Data: $clientData");

    try {
      Client client = await api.savedClient(clientData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Cliente guardado exitosamente'),
        ),
      );

      setState(() {
        clients = _getClient();
      });
    } catch (e) {
      print("Error al guardar el cliente: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Error al crear el cliente'),
        ),
      );
    }
  }

  void showForm() {
    // Lista para almacenar los distritos recuperados
    List<District> districts = [];

    // Llama al método getDistricts del servicio
    DistrictService districtService = DistrictService();
    districtService.getDistricts().then((value) {
      setState(() {
        districts = value;
      });
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Agregar Cliente"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: "Nombre"),
                  ),
                  TextField(
                    controller: lastNameController,
                    decoration: InputDecoration(labelText: "Apellido"),
                  ),
                  DropdownButtonFormField<String>(
                    value: null,
                    onChanged: (String? newValue) {
                      final selectedDistrict = districts.firstWhere(
                        (district) => district.name == newValue,
                        orElse: () => District(id: 0, name: ''),
                      );
                      districtController.text = selectedDistrict.id.toString();
                    },
                    items: districts.map<DropdownMenuItem<String>>((district) {
                      return DropdownMenuItem<String>(
                        value: district.name ??
                            '', // Si district.name es null, usamos un valor predeterminado
                        child: Text(district.name ??
                            ''), // Igual aquí, si es null, usamos un valor predeterminado
                      );
                    }).toList(),
                    decoration: InputDecoration(labelText: "Distrito"),
                  ),
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(labelText: "Dirección"),
                  ),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: "Email"),
                  ),
                  TextField(
                    controller: cellphoneController,
                    decoration: InputDecoration(labelText: "Celular"),
                  ),
                  DropdownButtonFormField<String>(
                    value: 'DNI', // Valor predeterminado
                    onChanged: (String? newValue) {
                      typeDocumentController.text = newValue!;
                    },
                    items: <String>['DNI', 'CNE']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: InputDecoration(labelText: "Tipo de Documento"),
                  ),
                  TextField(
                    controller: documentNumberController,
                    decoration:
                        InputDecoration(labelText: "Número de Documento"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  saveClient();
                  Navigator.of(context).pop();
                },
                child: const Text("Guardar"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Cancelar"),
              ),
            ],
          );
        },
      );
    }).catchError((error) {
      print("Error fetching districts: $error");
      // Manejar el error si ocurre
    });
  }
}
