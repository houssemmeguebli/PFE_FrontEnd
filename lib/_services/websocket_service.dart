import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  final String serverUrl = "ws://192.168.1.6:5000"; // Backend WebSocket URL
  WebSocketChannel? _channel;
  StreamController<Map<String, dynamic>>? _streamController;
  bool _isDisposed = false;

  WebSocketService() {
    _initialize();
  }

  void _initialize() {
    _streamController = StreamController<Map<String, dynamic>>.broadcast();
    _connect();
  }

  void _connect() {
    if (_isDisposed || _channel != null) return;

    try {
      _channel = WebSocketChannel.connect(Uri.parse(serverUrl));
      debugPrint("WebSocket connected to $serverUrl");

      _channel!.stream.listen(
            (data) {
          try {
            final jsonData = jsonDecode(data as String);
            if (jsonData is Map<String, dynamic> && !_streamController!.isClosed) {
              _streamController!.add(jsonData);
              debugPrint("Received WebSocket data: $jsonData");
            }
          } catch (e) {
            debugPrint("Error decoding WebSocket data: $e");
          }
        },
        onError: (error) {
          debugPrint("WebSocket error: $error");
          _streamController?.addError(error);
          _reconnect();
        },
        onDone: () {
          debugPrint("WebSocket connection closed");
          _channel = null;
          _reconnect();
        },
        cancelOnError: false,
      );
    } catch (e) {
      debugPrint("Failed to connect to WebSocket: $e");
      _reconnect();
    }
  }

  void _reconnect() async {
    if (_isDisposed || _channel != null) return;
    debugPrint("Attempting to reconnect to WebSocket in 2 seconds...");
    await Future.delayed(const Duration(seconds: 2));
    _connect();
  }

  Stream<Map<String, dynamic>> get stream => _streamController!.stream;

  void sendMessage(String message) {
    if (_channel != null && !_isDisposed) {
      _channel!.sink.add(jsonEncode({'message': message}));
    } else {
      debugPrint("WebSocket is not connected. Cannot send message.");
    }
  }

  void dispose() {
    if (!_isDisposed) {
      _channel?.sink.close();
      _streamController?.close();
      _isDisposed = true;
      debugPrint("WebSocketService disposed");
    }
  }
}