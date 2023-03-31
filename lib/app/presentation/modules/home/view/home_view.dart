import 'package:blockchain/app/domain/failures/http_request_failure.dart';

import '../../../../domain/repositories/exchange_repository.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final ExchangeRepository repository = context.read();
    return ChangeNotifierProvider(
        create: (_) => HomeBloc(
            exchangeRepository: context.read()
        )..init(), //LLAMA AL METODO
      builder: (context, _){
          final HomeBloc bloc = context.watch();
          return Scaffold(
            body: bloc.state.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                failed: (failure){
                  final String message = failure.when(
                      network: () => 'Verifica tu internet',
                      notFound: () => 'Informacion no encontrada',
                      server: () => 'Error interno del servidor',
                      unauthorized: () => 'Sin autorizacion',
                      badRequest: () =>'No se realizo la peticion',
                      local: () =>'Error desconocido');

                  return  Center(child: Text(message));
                },
                loaded: (crypto) => ListView.builder(
                  itemCount: crypto.length, // EN EST ESTADO SI TIENE LA VARIABLE CRYPTO
                  itemBuilder: (_, index){
                    final cryptos = crypto[index];
                    return ListTile(
                      title: Text(cryptos.id),
                      subtitle: Text(cryptos.symbol),
                      trailing: Text(cryptos.price.toStringAsFixed(2)),);
                  },
                ))
          );
      },
    );
  }
}
