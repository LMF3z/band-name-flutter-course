import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:brand_names/services/socket_io_service.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final socketServiceProvider = Provider.of<SocketIoService>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('${socketServiceProvider.serverStatus}')],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.message_sharp),
        onPressed: () {
          socketServiceProvider.emit(
            'listen-message',
            {
              'name': 'Flutter',
              'message': 'Hola desde Flutter',
            },
          );
        },
      ),
    );
  }
}
