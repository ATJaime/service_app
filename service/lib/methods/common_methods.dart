import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
class CommonMethods{
  checkConnectivity(BuildContext context) async{
    var connectionResult = await Connectivity().checkConnectivity();
    if (connectionResult != ConnectivityResult.mobile && connectionResult != ConnectivityResult.wifi) {
      if (!context.mounted) return;
      displaySnackBar("No hay conexión a internet", context);
      return;
    }
  }

  displaySnackBar(String message, BuildContext context){
    var snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}