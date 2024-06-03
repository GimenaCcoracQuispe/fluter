import 'package:flutter/material.dart';
import 'package:mikrosystem/src/auth/Login/Registro.dart';
import 'package:mikrosystem/src/auth/Content/listar.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(context),
              _inputField(context),
              _forgotPassword(context),
              //_signup(context),
            ],
          ),
        ),
      ),
    );
  }

  _header(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Agregar una imagen desde una URL
        /*Image.network(
          'https://i.ibb.co/8BJ63dh/330158531-1321988551711293-7007550439193672835-n.jpg',
          height: 100, // Ajusta la altura según tus necesidades
        ),*/
        const SizedBox(height: 20), // Ajusta el espacio según tus necesidades
        Text(
          'Bienvenido!',
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        Text('MycroSystem', textAlign: TextAlign.center),
      ],
    );
  }

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: "Usuario",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: BorderSide.none,
            ),
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            suffixIcon: const Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 15),
        TextField(
          decoration: InputDecoration(
            hintText: "Contraseña",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(3),
              borderSide: BorderSide.none,
            ),
            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
            filled: true,
            suffixIcon: const Icon(Icons.password),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Lista()),
            );
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  0), // Cambiar el radio a 0 para que sea rectangular
            ),
            backgroundColor: const Color.fromARGB(255, 41, 100, 239),
            padding: const EdgeInsets.symmetric(vertical: 13),
          ),
          child: Text(
            'INGRESAR',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white, // Color blanco para el texto
            ),
          ),
        ),
      ],
    );
  }

  _forgotPassword(context) {
    return TextButton(
        onPressed: () {}, child: const Text('¿Olvidaste tu contraseña?'));
  }

  /*Widget _signup(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('¿No cuentas con un usuario?'),
        TextButton(
          onPressed: () {
            // Navegar a la nueva vista de registro
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Registro()),
            );
          },
          child: const Text('Crear'),
        ),
      ],
    );
  }*/
}
