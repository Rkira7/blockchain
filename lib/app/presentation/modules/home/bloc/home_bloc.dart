import '../../../../domain/repositories/exchange_repository.dart';
import 'home_state.dart';
import 'package:flutter/material.dart';

class HomeBloc extends ChangeNotifier{
  HomeBloc({
    required this.exchangeRepository
  });
  final ExchangeRepository exchangeRepository;

  HomeState _state = HomeStateLoading();

  HomeState get state => _state;

  Future<void> init()async{
    if(state is! HomeStateLoading){
      _state = HomeStateLoading();
      notifyListeners();
    }
   final result = await exchangeRepository.getPrices(
       ['bitcoin', 'litecoin','usd-coin', 'dogecoin']);

    _state = result.when(
        left: (_) => HomeStateFailed(),
        right: (crypto) => HomeStateLoaded(crypto)
    );

    notifyListeners();

  }


}