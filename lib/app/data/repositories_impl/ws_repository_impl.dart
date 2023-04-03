import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../domain/repositories/ws_repository.dart';

class WsRepositoryImpl implements WsRepository {
  WsRepositoryImpl(this.builder);

  //RECIBE LA CONECCION DEL MAIN
  final WebSocketChannel Function(List<String>) builder;

  WebSocketChannel? _channel;
  StreamController<Map<String, double>>? _controller;
  StreamSubscription? _subscription;


  @override
  Future<bool> connect(List<String> ids) async {
    try{
      //VERIFICA LA CONEXION Y MANDA LOS IDS
      _channel = builder(ids);
      await _channel!.ready;

      //ESCUCHAR LOS CAMBIOS
      _subscription = _channel!.stream.listen(
        (event) {
          //CONVERTIR A MAP
          final map = Map<String, String>.from(jsonDecode(event));

          //CAMBIAR UN MAP A OTRO MAP DOUBLE
          final data = <String, double> {}..addEntries(
              map.entries.map((e) =>
                MapEntry(e.key, double.parse(e.value)))
          );

          //SI HAY UN ESCUCHA
          if(_controller?.hasListener ?? false){
            _controller!.add(data);
          }
        });
      return true;
    }
    catch(e){
      if (kDebugMode) {
        print(e);
      }
      return false;
    }


  }

  @override
  Future<void> disconnect() async{
   _subscription?.cancel();
   await _controller?.close();
   await _channel?.sink.close();
   _channel = null;
  }

  @override
  Stream<Map<String, double>> get onPricesChanged {
    _controller ??= StreamController.broadcast();
    return _controller!.stream;
  }
}
