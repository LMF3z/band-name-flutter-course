import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketIoService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  final IO.Socket _socket = IO.io('http://192.168.18.5:3001', {
    'transports': ['websocket'],
    'autoConnect': true
  });

  SocketIoService() {
    _initConfig();
  }

  ServerStatus get serverStatus => _serverStatus;

  IO.Socket get socket => _socket;
  Function get emit => _socket.emit;

  void _initConfig() {
    _socket.on('connect', (data) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.on('disconnect', (data) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    // socket.on('new-message', (payload) {
    //   print('${payload.toString()}');
    // });

    // socket.onConnect((_) {
    //   print('connect');
    //   socket.emit('msg', 'test');
    // });
    // socket.on('event', (data) => print(data));
    // socket.onDisconnect((_) => print('disconnect'));
    // socket.on('fromServer', (_) => print(_));
  }
}
