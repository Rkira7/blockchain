import 'dart:async';
import '../../../../domain/models/ws_status/ws_status.dart';

import '../../../../domain/repositories/ws_repository.dart';
import '../../../../domain/repositories/exchange_repository.dart';
import 'home_state.dart';
import 'package:flutter/material.dart';

class HomeBloc extends ChangeNotifier{
  HomeBloc({
    required this.wsRepository,
    required this.exchangeRepository
  });
  final ExchangeRepository exchangeRepository;
  final WsRepository wsRepository;
  StreamSubscription? _priccesSubscription, _wsSubscription;

  HomeState _state = const HomeState.loading();

  HomeState get state => _state;

  final _ids = [
    'bitcoin',
    'ethereum'
    'tether',
    'binance-coin',
    'monero',
    'litecoin',
    'usd-coin',
    'dogecoin'];

  //INICIALIZA AL HACER LA INSTANCIA
  Future<void> init()async{
    //INICIALIZA EL PRIMER ESTADO
    //EL LOAFING HACE QUE NOTIFIQUE Y MUETRE EL PROGRESS
    state.maybeWhen(
        loading: () {},
        orElse: () {
          _state = const HomeState.loading();
          notifyListeners();
        }
    );

    //OBTIENE EL RESULTADO DE LA API
   final result = await exchangeRepository.getPrices(_ids);

    //result ES DE TIPO GetPriceFuture QUE EXTIENDE DE Either<L,R>
    _state = result.when(
        left: (failure) => HomeState.failed(failure),
        right: (crypto) {
          startPriceListening();
          return HomeState.loaded(crypto: crypto);
        }
    );

    notifyListeners();

  }


  //ESCUCHAR EL ESTADO DEL SOCKET
  Future<bool> startPriceListening() async {
    //SE CONECTA CONECTA CON EL WEBSOCKET
    final connected = await wsRepository.connect(_ids);

    state.mapOrNull(  //PARA NO DEFIRIR TODAS LAS FUNCIONES
        loaded: (state){
          //SI LA CONEXION ES CORRECTA
          if(connected){
            //ACTUALIZAR EL PRECIO
            _onPricesChanged();
          }
          //VALIDA EL ESTADO DE LA CONECCION TRUE O FALSE
          //REGRESAMOS LA CONECCION A LOADED
          //ASIGNAMOS EL ESTADO CON EL copyWith
          _state = state.copyWith(
            wsStatus: connected
                ? const WsStatus.connected()
                : const WsStatus.failed()
          );
          notifyListeners();
        },
    );

    return connected;
  }

  //ACTUALIZA EL PRECIO DE LAS MONEDAS CON EL SOCKET
  void _onPricesChanged(){
    _priccesSubscription?.cancel();
    _wsSubscription?.cancel();
    //ESPERA EL CAMBIO DEL STREAM PARA NOTIFICAR A LA VISTA Y CAMBIAR LOS PRECIOS
    _priccesSubscription = wsRepository.onPricesChanged.listen((changes) { //OBTIENE LA KEY Y EL PRECIO
      state.mapOrNull(
        loaded: (state) {
          final keys = changes.keys; //  OBTIENE LA KEY

          //ACTUALIZA LA LISTA DE CRYPTOS DEPENDIENDO DE LOS CAMBIOS
          //RECORRE LA LISA DE LAS CRYPTO
            //"bitcoin" -> 28224.94
            //"binance-coin" -> 314.83
          _state = state.copyWith(
            crypto: [...state.crypto.map((crypto) {
              if(keys.contains(crypto.id)){//BUSCA LA KEY EN LA LISTA DE IDS
                return crypto.copyWith(
                    price: changes[crypto.id]! //OBTIENE EL VALOR DEL PRECIO
                );
              }
              return crypto;
            }).toList()]
          );

          //NOTIFICA LOS ESCUCHAS
          notifyListeners();

         /*
         List<Crypto> cryptos = [...state.crypto]; // SE CRE UNA NUEVA LISTA CON LAS VALORES
         final keys = changes.keys;

         for(int i = 0; i<cryptos.length; i++){
            final crypto = cryptos[i];
            if(keys.contains(crypto.id)){
              cryptos[i] = crypto.copyWith(
                price: changes[crypto.id]! //OBTIENE EL VALOR DEL PRECIO
              );
            }
          }
          _state= state.copyWith(
            crypto: cryptos //ACTUALIZA LA LISTA
          );
          notifyListeners();*/
        }
      );
    });

    //ESPERA EL CAMBIO DEL STREAM PARA NOTIFICAR A LA VISTA PARA EL APPBAR
    _wsSubscription = wsRepository.onStatusChanged.listen((status) {
        state.mapOrNull(
          loaded: (state) {
            _state = state.copyWith(wsStatus: status);
            notifyListeners();
          }
        );
    });
  }

  @override
  void dispose() {
    _priccesSubscription?.cancel();
    _wsSubscription?.cancel();
    super.dispose();
  }


}