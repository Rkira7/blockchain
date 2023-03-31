import '../services/remote/exchage_api.dart';
import '../../domain/repositories/exchange_repository.dart';

class ExchangeRepositoryImpl implements ExchangeRepository{
  final ExchangeAPI _api;
  ExchangeRepositoryImpl(this._api);

  @override
  GetPriceFuture getPrices(List<String> ids) {
    return _api.getPrices(ids);
  }
  

}
