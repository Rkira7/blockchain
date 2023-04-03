import 'dart:async';
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
  StreamSubscription? _subscription;

  HomeState _state = const HomeState.loading();

  HomeState get state => _state;

  final _ids =  ['bitcoin', 'ethereum', 'litecoin','usd-coin', 'dogecoin'];

  Future<void> init()async{
    state.maybeWhen(
        loading: () {},
        orElse: () {
          _state = const HomeState.loading();
          notifyListeners();
        }
    );

   final result = await exchangeRepository.getPrices(_ids);

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

  //ACTUALIZA EL PRECIO DE LAS MONEDAS
  void _onPricesChanged(){
    _subscription?.cancel();
    _subscription = wsRepository.onPricesChanged.listen((changes) { //OBTIENE LA KEY Y EL PRECIO
      state.mapOrNull(
        loaded: (state) {
          final cryptos = [...state.crypto]; // SE CRE UNA NUEVA LISTA CON LAS VALORES
          final keys = changes.keys; //  OBTIENE LA KEY
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
          notifyListeners();
        }
      );
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }


}