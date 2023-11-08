import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service/controllers/authentication_controller.dart';
import 'package:service/controllers/user_controller.dart';
import 'package:service/methods/common_methods.dart';
import 'package:service/pages/home.dart';
import 'package:service/pages/signup_page.dart';
import 'package:service/widgets/loading_dialog.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  AuthenticationController authenticationController = Get.find();
  UserController userController = Get.find();
  CommonMethods commonMethods = CommonMethods();

  checkIfNetworkIsAvailable(){
    commonMethods.checkConnectivity(context);
  }

  loginFormValidation() async{
    if(_emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty){
      commonMethods.displaySnackBar("Por favor, ingrese todos los campos", context);
    }else if(!_emailController.text.trim().contains("@")){
      commonMethods.displaySnackBar("Por favor, ingrese un correo válido", context);
    }
    else if(_passwordController.text.trim().length < 6){
      commonMethods.displaySnackBar("La contraseña debe tener al menos 6 caracteres", context);
    }else{
      await loginUser();
    }
  }

  loginUser() async{
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => LoadingDialog(message: "Iniciando sesión")
    );
    try{
      final User? userFirebase = (
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, 
          password: _passwordController.text
        // ignore: body_might_complete_normally_catch_error
        ).catchError((errorMessage){
          Navigator.pop(context);
          commonMethods.displaySnackBar(errorMessage.toString(), context);
        })
      ).user;

      if(!context.mounted) return;
      Navigator.pop(context);

      if(userFirebase != null){
        DatabaseReference userRef = FirebaseDatabase.instance.ref().child("users").child(userFirebase.uid); 
        userRef.once().then((snap){
          if(snap.snapshot.value != null){
            userController.setUsername((snap.snapshot.value as Map)["name"]);
            userController.setEmail((snap.snapshot.value as Map)["email"]);
            authenticationController.logIn();
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Home()));
          }else{
            FirebaseAuth.instance.signOut();
            commonMethods.displaySnackBar("No se encontró el usuario", context);
          }
        });
      }
    }catch(e){
      if(!context.mounted) return;
      commonMethods.displaySnackBar(e.toString(), context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Image.asset("assets/images/logo.png"),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border:  OutlineInputBorder(),
                    labelText: 'Correo',
                  ),
                ),

                const SizedBox(height: 8),

                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Contraseña',
                  ),
                ),
                
                const SizedBox(height: 20),
                
                ElevatedButton(
                  onPressed: (){
                    checkIfNetworkIsAvailable();
                    loginFormValidation();
                  }, 
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  child: const Text('Iniciar Sesión', style: TextStyle(color: Colors.white))
                ),
                
                const SizedBox(height: 20),
                
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUp())
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                  child: const Text('Registrarse', style: TextStyle(color: Colors.white))
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
