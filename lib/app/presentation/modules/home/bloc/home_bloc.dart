import '../../../../domain/repositories/exchange_repository.dart';
import 'home_state.dart';
import 'package:flutter/material.dart';

class HomeBloc extends ChangeNotifier{
  HomeBloc({
    required this.exchangeRepository
  });
  final ExchangeRepository exchangeRepository;

  HomeState _state = HomeState.loading();

  HomeState get state => _state;

  Future<void> init()async{
    state.maybeWhen(
        loading: () {},
        orElse: () {
          _state = HomeState.loading();
          notifyListeners();
        }
    );

   final result = await exchangeRepository.getPrices(
       ['bitcoin', 'litecoin','usd-coin', 'dogecoin']);

    _state = result.when(
        left: (_) => HomeState.failed(),
        right: (crypto) => HomeState.loaded(crypto)
    );

    notifyListeners();

  }


}