import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketManager {
  static final SocketManager _instance = SocketManager._internal();
  late IO.Socket socket;

  factory SocketManager() {
    return _instance;
  }

  SocketManager._internal() {
    socket = IO.io('https://flupus-server.onrender.com', <String, dynamic>{
      'transports': ['websocket'],
    });
    // socket = IO.io('http://10.4.2.58:4000', <String, dynamic>{
    //   'transports': ['websocket'],
    // });
  }
}
