import 'dart:async';
import 'dart:convert';

import '../../domain/models/ws_status/ws_status.dart';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../domain/repositories/ws_repository.dart';

class WsRepositoryImpl implements WsRepository {
  WsRepositoryImpl(
      this.builder,
      [this._reconnectDuration = const Duration(seconds: 5)]); //PARAMETRO OPCIONAL

  //RECIBE LA CONECCION DEL MAIN
  final WebSocketChannel Function(List<String>) builder;
  final Duration _reconnectDuration;

  WebSocketChannel? _channel;
  StreamController<Map<String, double>>? _priceController;
  StreamController<WsStatus>? _wscontroller;
  StreamSubscription? _subscription;

  Timer? _timer;


  @override
  Future<bool> connect(List<String> ids) async {
    try{
      //CAMBIA ESTADO EN EL APPBAR
      _notifyStatus(const WsStatus.connecting());
      //VERIFICA LA CONEXION Y MANDA LOS IDS A LA FUNCION builder
      _channel = builder(ids);
      await _channel!.ready;

      //ESCUCHAR LOS CAMBIOS DE LA CHIPTOMONEDA
      _subscription = _channel!.stream.listen(
        (event) {
          //CONVERTIR A MAP DE LA CHIPTOMONEDA --{\"bitcoin\":\"28239.47\"}
          final map = Map<String, String>.from(jsonDecode(event));

          //CAMBIAR EL VALOR DEL A DOUBLE
          final data = <String, double> {}..addEntries(
              map.entries.map((e) =>
                MapEntry(e.key, double.parse(e.value)))
          );

          //SI HAY UN ESCUCHA
          if(_priceController?.hasListener ?? false){
            _priceController!.add(data); //NOTIFICA AL listen DEL STREAM
          }
        },
          //SI SE PERDIO LA CONEXION DEL SOCKET
        onDone: () => _reconnect(ids)

      );
      _notifyStatus(const WsStatus.connected());
      return true;
    }
    catch(e){
      if (kDebugMode) {
        print(e);
      }
      _reconnect(ids);
      return false;
    }


  }

  //RECONECTAR AL SOCKET
  void _reconnect(List<String> ids){
    if(_subscription != null){
      _timer?.cancel();
      //ESPERA EL TEIMPO PARA LA RECONEXION
      _timer = Timer(_reconnectDuration, (){
        connect(ids);
      });


    }
  }

  //NOTIFICA EL ESTADO DEL SOCKET EN EL APPBAR
  void _notifyStatus(WsStatus status){
    if(_subscription == null){
      return;
    }

    if(_wscontroller?.hasListener ?? false){
      _wscontroller!.add(status);
    }
  }

  //SE DESUSCRIBE DE TODOS LOS OYENTES
  @override
  Future<void> disconnect() async{
    _timer?.cancel();
    _timer = null;
   _subscription?.cancel();
   _subscription = null;
   await _wscontroller?.close();
   await _priceController?.close();
   await _channel?.sink.close();
   _channel = null;
  }

  @override
  Stream<Map<String, double>> get onPricesChanged {
    _priceController ??= StreamController.broadcast();
    return _priceController!.stream;
  }

  @override
  // TODO: implement onStatusChanged
  Stream<WsStatus> get onStatusChanged {
   _wscontroller ??= StreamController.broadcast();
   return _wscontroller!.stream;
  }
}
