import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service/pages/signup_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(
              children: [
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border:  OutlineInputBorder(),
                    labelText: 'Correo',
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Contraseña',
                  ),
                ),
                const FloatingActionButton(onPressed: null, child: Text('Ingresar')),
                FloatingActionButton(onPressed: () => 
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUp())),
                 child: const Text('Registrarse')
                )
              ],
            )
          )  
          ],
        ),
      ),
    );
  }
}
