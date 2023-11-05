import 'package:flutter/material.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _controller;

@override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ServiceApp"),
        actions: const [
          IconButton(onPressed: null, icon: Icon(Icons.message_rounded))
          ],
        ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [const Text("Mapa"),
            TabBar(
            controller: _controller,
            tabs: const [
                Tab(icon: Icon(Icons.room_service_rounded)),
                Tab(icon: Icon(Icons.design_services_sharp)),
                Tab(icon: Icon(Icons.history_sharp))
            ]),
            Expanded(
              child: TabBarView(
                controller: _controller,
                children: [
                  Column(children: [
                    const Text("Contratar servicio"), 
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: "Servicio"), 
                        keyboardType: TextInputType.text
                      )
                    ),
                    SizedBox(
                      width: 200,
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: "Precio"), 
                        keyboardType: TextInputType.number
                      )
                    ),
                    const IconButton.outlined(onPressed: null, icon: Icon(Icons.search))
                    ]
                  ),
                  const Column(
                    children: [
                      Text("Ver trabajos en el mapa"),
                      IconButton.outlined(onPressed: null, icon: Icon(Icons.work))
                    ]
                  ),
                  const Column(
                    children: [
                      Text("Historial")
                    ]
                  )
                ]
              ),
            )
          ]
        ),
      )
    );
  }
}