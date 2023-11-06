import 'package:flutter/material.dart';
import 'package:service/methods/common_methods.dart';
import 'package:service/pages/login_page.dart';
import 'package:service/widgets/loading_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _FirebaseSignUpState();
}

class _FirebaseSignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  CommonMethods commonMethods = CommonMethods();

  checkIfNetworkIsAvailable(){
    commonMethods.checkConnectivity(context);
  }

  signupFormValidation(){
    if(_nameController.text.trim().isEmpty || _emailController.text.trim().isEmpty || _passwordController.text.trim().isEmpty){
      commonMethods.displaySnackBar("Por favor, ingrese todos los campos", context);
    }else if(!_emailController.text.trim().contains("@")){
      commonMethods.displaySnackBar("Por favor, ingrese un correo válido", context);
    }
    else if(_passwordController.text.trim().length < 6){
      commonMethods.displaySnackBar("La contraseña debe tener al menos 6 caracteres", context);
    }else{
      register();
    }
  }

  register() async{
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => LoadingDialog(message: "Registrando usuario")
    );

    final User? userFirebase = (
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text, 
        password: _passwordController.text
      // ignore: body_might_complete_normally_catch_error
      ).catchError((errorMessage){
        Navigator.pop(context);
        commonMethods.displaySnackBar(errorMessage.toString(), context);
      })
    ).user;
    if (!context.mounted) return; 
    Navigator.pop(context);

    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users").child(userFirebase!.uid);

    Map userDataMap =
    {
      "name": _nameController.text.trim(),
      "email": _emailController.text.trim(),
      "id": userFirebase.uid,

    };
    usersRef.set(userDataMap);
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
            child: Container(
                padding: const EdgeInsets.all(25),
                child: Form(
                  key: _formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/logo.png"),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              TextField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Nombre',
                                ),
                              ),
                              
                              const SizedBox(height: 20),
                              
                              TextField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  border:  OutlineInputBorder(),
                                  labelText: 'Correo',
                                ),
                              ),
                              
                              const SizedBox(height: 20),
                              
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
                                  signupFormValidation();
                                }, 
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0),
                                  ),
                                ),
                                child: const Text('Registrarse', style: TextStyle(color: Colors.white))
                              ),
                            ],
                          )
                        )
                      ]
                    ),
                ))));
  }
}
