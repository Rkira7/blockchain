import 'dart:convert';
import 'dart:io';

import '../../../domain/either/either.dart';
import '../../../domain/repositories/exchange_repository.dart';

import '../../../domain/failures/http_request_failure.dart';
import '../../../domain/models/crypto/crypto.dart';
import 'package:http/http.dart';

class ExchangeAPI {
  ExchangeAPI(this._client);
  final Client _client;

  //CONSUMO DE LA API DE CRIPTOMONEDAS
  GetPriceFuture getPrices(List<String> ids) async {
    try {
      final response = await _client.get(
          Uri.parse(
          "https://api.coincap.io/v2/assets?ids=${ids.join(",")}")
      );

      //RESPUESTA CORRECTA
      if(response.statusCode == 200){
        final json = jsonDecode(response.body);
        //CREA UNA LISTA CON LAS
        final cryptos =  (json['data'] as List).map(
            (e) => Crypto(
                id: e['id'],
                symbol: e['symbol'],
                name: e['name'],
                price: double.parse(e['priceUsd']),
                changePercent24Hr: double.parse(e['changePercent24Hr'])),
        );

        return Either.right(cryptos.toList());
      }

      //RESPUESTAS ERRONEAS
      if(response.statusCode == 404){
        throw HttpRequestFailure.notFound();
      }
      if(response.statusCode >= 500){
        throw HttpRequestFailure.server();
      }
      throw HttpRequestFailure.local();

    }
    catch(e){
      late HttpRequestFailure failure;
      if(e is HttpRequestFailure){
        failure = e;
      }else if(e is SocketException || e is ClientException){
        failure = HttpRequestFailure.network();
      }
      else{
        failure = HttpRequestFailure.local();
      }
      return Either.left(failure);
    }
  }
}
