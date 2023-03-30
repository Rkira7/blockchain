import 'package:blockchain/app/domain/repositories/exchange_repository.dart';
import 'package:blockchain/app/presentation/modules/home/bloc/home_bloc.dart';
import 'package:blockchain/app/presentation/modules/home/bloc/home_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';

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
            body: (){
              final state = bloc.state;

              if(state is HomeStateLoading){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if(state is HomeStateLoaded){ //SE HACE LE CASTING IMPLICITO
                return ListView.builder(
                    itemCount: state.crypto.length, // EN EST ESTADO SI TIENE LA VARIABLE CRYPTO
                    itemBuilder: (_, index){
                      final crypto = state.crypto[index];
                      return ListTile(
                        title: Text(crypto.id),
                        subtitle: Text(crypto.symbol),
                        trailing: Text(crypto.price.toStringAsFixed(2)),);
                    },
                );
              }

              return const Center(child: Text('ERROR'),);
            }(),
          );
      },
    );
  }
}
