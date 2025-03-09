import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final String serverUrl = "ws://localhost:5000";
  late WebSocketChannel _channel;
  late StreamController<Map<String, dynamic>> _streamController;

  WebSocketService() {
    _streamController = StreamController<Map<String, dynamic>>.broadcast();
    _connect();
  }

  void _connect() {
    _channel = WebSocketChannel.connect(Uri.parse(serverUrl));
    _channel.stream.listen(
          (data) {
        final jsonData = jsonDecode(data);
        _streamController.add(jsonData);
      },
      onError: (error) {
        print("WebSocket error: $error");
      },
      onDone: () {
        print("WebSocket connection closed");
      },
    );
  }

  Stream<Map<String, dynamic>> get stream => _streamController.stream;

  void sendMessage(String message) {
    _channel.sink.add(jsonEncode({'message': message}));
  }

  void dispose() {
    _channel.sink.close();
    _streamController.close();
  }
}
