import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loggy/loggy.dart';
import 'package:service/controllers/authentication_controller.dart';
import 'package:service/controllers/user_controller.dart';
import 'package:service/methods/common_methods.dart';
import 'package:service/pages/login_page.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>{
  AuthenticationController authenticationController = Get.find();
  UserController userController = Get.find();
  final Completer<GoogleMapController> _googleMapsController =
      Completer<GoogleMapController>();
  GoogleMapController? googleMapController;
  late Position currentPositionOfUser;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  
  GlobalKey<ScaffoldState> sKey = GlobalKey<ScaffoldState>();
  CommonMethods commonMethods = CommonMethods();
  

  getCurrentLiveLocation() async{
    Position positionOfUser = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPositionOfUser = positionOfUser;

    LatLng positionOfUserLatLng = LatLng(currentPositionOfUser.latitude, currentPositionOfUser.longitude);
    CameraPosition cameraPosition = CameraPosition(target: positionOfUserLatLng, zoom: 15);
    googleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  getUserInfo() async{
    DatabaseReference userRef = FirebaseDatabase.instance.ref()
      .child("users")
      .child(FirebaseAuth.instance.currentUser!.uid);
    await userRef.once().then((snap){
      if(snap.snapshot.value != null){
        userController.setUsername((snap.snapshot.value as Map)["name"]);
        userController.setEmail((snap.snapshot.value as Map)["email"]);
      }else{
        FirebaseAuth.instance.signOut();
        Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sKey,
      drawer: Container(
        width: 255,
        color: Colors.white,
        child: Drawer(
          child: ListView(
            children: [
              Container(
              color: Colors.black,
              height: 160,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.black
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white
                    ),
                    const SizedBox(width: 16),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FutureBuilder(
                          future: getUserInfo(),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();  // Show a loading spinner while waiting
                            } else if (snapshot.error != null) {
                              return Text('Error: ${snapshot.error}');  // Show error message if something went wrong
                            } else {
                              return Text(userController.username, 
                                style: const TextStyle(fontSize: 16, 
                                  fontWeight: FontWeight.bold, 
                                  color: Colors.white
                              ));  // Show the username once the Future completes
                            }
                          },
                        )
                      ],
                    )

                  ],
                  

                )
              )
             ),
          
              const Divider(
                height: 1,
                color: Colors.grey,
                thickness: 1
              ),

              const SizedBox(height: 10),

               ListTile(
                leading: IconButton(
                  onPressed: (){
                    logInfo("------------------------------------------------\n");      
                    logInfo(userController.username);
                    logInfo("\n------------------------------------------------");
                  },
                  icon: const Icon(Icons.chat, color: Colors.grey)
                ),
                title: const Text("Mensajes"),
              ),
              const ListTile(
                leading: IconButton(
                  onPressed: null,
                  icon: Icon(Icons.history, color: Colors.grey)
                ),
                title: Text("Historial"),
              ),
              ListTile(
                leading: IconButton(
                  onPressed: () {
                    userController.dispose();
                    authenticationController.logOut();
                    FirebaseAuth.instance.signOut();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
                  },
                  icon: const Icon(Icons.logout, color: Colors.grey)
                  
                ),
                title: const Text("Cerrar sesión"),
              ),
          ]),
        )
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController mapController){
                    googleMapController = mapController;
                    _googleMapsController.complete(mapController);
                    getUserInfo();
                    getCurrentLiveLocation();
                  },
                ),
                Positioned(
                  top: 42,
                  left: 19,
                  child: GestureDetector(
                    onTap: (){
                      sKey.currentState!.openDrawer();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            spreadRadius: 0.5,
                            offset: Offset(0.7, 0.7),
                          )
                        ]
                      ),
                      child: const CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 20,
                        child: Icon(
                          Icons.menu,
                          color: Colors.black87
                        )
                      )
                    )
                  )
                )
              ],
            ),
      )
    );
  }
}