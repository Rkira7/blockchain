import 'package:blockchain/app/domain/failures/http_request_failure.dart';
import 'package:blockchain/app/domain/repositories/ws_repository.dart';

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

  HomeState _state = const HomeState.loading();

  HomeState get state => _state;

  final _ids =  ['bitcoin', 'litecoin','usd-coin', 'dogecoin'];

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


}