import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:service/controllers/authentication_controller.dart';
import 'package:service/controllers/user_controller.dart';
import 'package:service/methods/common_methods.dart';
import 'package:service/models/requests.dart';
import 'package:service/pages/chat_page.dart';
import 'package:service/pages/chats_list_page.dart';
import 'package:service/pages/getting_service_page.dart';
import 'package:service/pages/historial_list_page.dart';
import 'package:service/pages/login_page.dart';
import 'package:service/services/request_service.dart';
import 'package:service/widgets/proposals_box.dart';

import '../widgets/loading_dialog.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>{
  AuthenticationController authenticationController = Get.find();
  UserController userController = Get.find();
  final RequestService _requestService = RequestService();
  List<Request> requests = [];
  Set<Marker> markers = {};

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
    userController.setLocation(positionOfUserLatLng.latitude, positionOfUserLatLng.longitude);
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

  looking() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => LoadingDialog(message: "Buscando trabajos...")
    );
    requests = await _requestService.getRequests();
    Set<Marker> marks = {};
    for(Request request in requests){
      marks.add(Marker(
        markerId: MarkerId(request.requestId),
        position: LatLng(double.parse(request.requestLat), double.parse(request.requestLng)),
        infoWindow: InfoWindow(
          title: request.description,
          snippet: request.price,
          onTap: (){
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) => AlertDialog(
                title: Text(request.description),
                content: Text("Precio: ${request.price}"),
                actions: [
                  TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: const Text("Cerrar")
                  ),
                  TextButton(
                    onPressed: (){
                      _requestService.proposalRequest(
                        FirebaseAuth.instance.currentUser!.uid, 
                          request.requesterId, 
                          request.requestId
                      );
                      Navigator.pop(context);
                      userController.stopLooking();
                      setState(() => markers = {});
                      Navigator.push((context), MaterialPageRoute(builder: (context) => 
                        ChatPage(recieverUserName: "", recieverUserId: request.requesterId)));
                    },
                    child: const Text("Enviar propuesta")
                  )
                ],
              )
            );
          }
        ),
      ));
    }
    if(!context.mounted) return;
    Navigator.pop(context);
    setState(() => markers = marks);
  }

  setMarkers() async{
    if(userController.lookingJob){
      await looking();
    }else{
      markers.clear();
    }
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
                        Obx( () => Text(userController.username, 
                                style: const TextStyle(fontSize: 16, 
                                  fontWeight: FontWeight.bold, 
                                  color: Colors.white
                              ))
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

              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatsScreen()));
                },
                child: ListTile(
                  leading: IconButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatsScreen()));
                      },
                      icon: const Icon(Icons.chat, color: Colors.grey)
                    ),
                    title: const Text("Mensajes"),
                  )
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const HistorialListPage()));
                },
                child: ListTile(
                  leading: IconButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const HistorialListPage()));
                    },
                    icon: const Icon(Icons.history, color: Colors.grey)
                  ),
                  title: const Text("Historial"),
                )
              ),

              GestureDetector(
                onTap: (){
                  if(userController.isWaiting) _requestService.deleteRequest(userController.pendingRequest);
                  userController.reset();
                  authenticationController.logOut();
                  FirebaseAuth.instance.signOut();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
                },
                child: ListTile(
                  leading: IconButton(
                    onPressed: () {
                      if(userController.isWaiting) _requestService.deleteRequest(userController.pendingRequest);
                      userController.reset();
                      authenticationController.logOut();
                      FirebaseAuth.instance.signOut();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
                    },
                    icon: const Icon(Icons.logout, color: Colors.grey)
                  ),
                title: const Text("Cerrar sesión"),
              )),
          ]),
        )
      ),
      body: Container(
        padding: const EdgeInsets.all(0),
        child: Stack(
              children: [
                Obx(() => 
                  GoogleMap(
                    padding: const EdgeInsets.only(top: 30, bottom: 320),
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController mapController){
                      googleMapController = mapController;
                      _googleMapsController.complete(mapController);
                      getUserInfo();
                      getCurrentLiveLocation();
                    },
                    markers: userController.isWaiting ? 
                      {
                        Marker(
                          markerId: const MarkerId("Esperando"), 
                          position: LatLng(userController.location[0], userController.location[1])
                        )
                      }  : markers,
                  ),
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
                ),
              
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 5,

                  child: Obx( 
                    () => userController.isWaiting? 
                     Column(
                        children: [
                          Container(
                            height: 200,
                            alignment: Alignment.center,
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
                            child: ProposalsBox(requestId: userController.pendingRequest)
                          ),
                          const SizedBox(height: 350),
                          ElevatedButton(
                            onPressed: (){
                              if(userController.isWaiting){
                                userController.stopWaiting();
                                _requestService.deleteRequest(userController.pendingRequest);
                                userController.setPendingRequest('');
                              }else{
                                userController.stopLooking();
                              }
                              setMarkers();
                              setState(() => requests = []);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)
                              ),
                              padding: const EdgeInsets.only(bottom: 10, top: 10, left: 40, right: 40)
                            ),
                            child: const Text(
                              "Cancelar", 
                              style: TextStyle(color: Colors.white, fontSize: 20), 
                              textAlign: TextAlign.center
                            )
                          )
                        ]
                    )
                    : 
                    userController.lookingJob ? 
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: (){
                            if(userController.isWaiting){
                              userController.stopWaiting();
                              _requestService.deleteRequest(userController.pendingRequest);
                              userController.setPendingRequest('');
                            }else{
                              userController.stopLooking();
                            }
                            setMarkers();
                            setState(() => requests = []);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                            ),
                            padding: const EdgeInsets.only(bottom: 10, top: 10, left: 40, right: 40)
                          ),
                          child: const Text(
                            "Cancelar", 
                            style: TextStyle(color: Colors.white, fontSize: 20), 
                            textAlign: TextAlign.center
                          )
                        )
                      ]
                    ) 
                    : SizedBox(
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const GetServicePage()));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(24)
                            ),
                            child: const Icon(Icons.search, color: Colors.white, size: 25)),
                            ElevatedButton(
                              onPressed: (){
                                userController.looking();
                                setMarkers();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(24)
                              ),
                              child: const Icon(Icons.work, color: Colors.white, size: 25)),
                        ]
                      ),
                    )
                  )
                )
              ],
            ),
      )
    );
  }
}