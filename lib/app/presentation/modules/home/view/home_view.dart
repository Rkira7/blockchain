import '../../../../domain/repositories/exchange_repository.dart';
import '../bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final ExchangeRepository repository = context.read();
    return ChangeNotifierProvider(
        create: (_) => HomeBloc(
            exchangeRepository: context.read(),
          wsRepository: context.read()
        )..init(), //LLAMA AL METODO
      builder: (context, _){
          final HomeBloc bloc = context.watch();
          return Scaffold(
            appBar: AppBar(
              title: bloc.state.mapOrNull(
                loaded: (state) => Text(
                  //COMPRUEBA EL ETADO Y MUESTRA EL ESTADO
                    state.wsStatus.when(
                        connecting: () => 'connecting',
                        connected: () => 'connected',
                        failed:() => 'failed')

                )
              ) ,
            ),
            body: bloc.state.map(
                loading: (_) => const Center(child: CircularProgressIndicator()),
                failed: (state){
                  final String message = state.failure.when(
                      network: () => 'Verifica tu internet',
                      notFound: () => 'Informacion no encontrada',
                      server: () => 'Error interno del servidor',
                      unauthorized: () => 'Sin autorizacion',
                      badRequest: () =>'No se realizo la peticion',
                      local: () =>'Error desconocido');

                  return  Center(child: Text(message));
                },
                loaded: (state) => ListView.builder(
                  itemCount: state.crypto.length, // EN EST ESTADO SI TIENE LA VARIABLE CRYPTO
                  itemBuilder: (_, index){
                    final cryptos = state.crypto[index];
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
