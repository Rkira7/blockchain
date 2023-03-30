import 'package:blockchain/app/domain/repositories/exchange_repository.dart';
import 'package:blockchain/app/domain/results/get_prices/get_prices_result.dart';
import 'package:blockchain/app/presentation/modules/home/bloc/home_state.dart';
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

    if(result is GetPricesSuccess){
      _state = HomeStateLoaded(result.cryptos);
    }else{
      _state = HomeStateFailed();
    }
    notifyListeners();

  }


}