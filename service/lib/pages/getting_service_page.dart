import 'package:flutter/material.dart';

class GetServicePage extends StatefulWidget{
  const GetServicePage({Key? key}) : super(key: key);

  @override
  State<GetServicePage> createState() => _GetServicePageState();
}

class _GetServicePageState extends State<GetServicePage>{
  TextEditingController typeServiceController = TextEditingController();
  TextEditingController priceController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 10,
              child: Container(
                height: 250,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white70,
                      blurRadius: 5.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7)
                    ),
                  ]
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, top: 48, right: 24, bottom: 20),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.arrow_back, color: Colors.black),
                          ),
                          const Center(
                            child: Text("Escoger servicio", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(5),

                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: TextField(
                                  controller: typeServiceController,
                                  decoration: const InputDecoration(
                                    hintText: "Tipo de servicio",
                                    fillColor: Colors.grey,
                                    filled: true,
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(left: 11, top: 9, bottom: 9)
                                  ),
                                )
                              )
                            )
                          )
                        ],
                      ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(5),

                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: TextField(
                                controller: priceController,
                                decoration: const InputDecoration(
                                  hintText: "Precio",
                                  fillColor: Colors.grey,
                                  filled: true,
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.only(left: 11, top: 9, bottom: 9)
                                ),
                              )
                            )
                          )
                        )
                      ],
                    ),                    
                    ],
                  )
                )
              )
            )
          ],
        )
      )
    );
  }
}