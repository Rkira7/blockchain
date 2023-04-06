import '../services/remote/exchage_api.dart';
import '../../domain/repositories/exchange_repository.dart';

class ExchangeRepositoryImpl implements ExchangeRepository{
  ExchangeRepositoryImpl(this._api);
  final ExchangeAPI _api;

  //SE IMPLEMENTA LA CLASE ABSTRACTA ExchangeRepository QUE SOLO TIENE UN METODO
  //CONSULTA A LA API
  @override
  GetPriceFuture getPrices(List<String> ids) {
    return _api.getPrices(ids);
  }
  

}
