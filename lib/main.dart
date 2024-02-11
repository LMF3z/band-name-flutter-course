import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:brand_names/services/socket_io_service.dart';

import 'package:brand_names/screens/index.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => SocketIoService(),
      )
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: "/",
      routes: {
        "/": (_) => const HomeScreen(),
        "/status": (_) => const StatusScreen()
      },
    );
  }
}
