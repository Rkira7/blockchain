import 'package:blockchain/app/presentation/modules/home/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import '../../../../../domain/models/crypto/crypto.dart';


class HomeLoaded extends StatelessWidget {
  const HomeLoaded({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final  HomeBloc bloc = context.watch();
    final state = bloc.state;
    
    return state.maybeMap(
        orElse: () => const SizedBox(),
        loaded: (state) {
          final crypto = state.crypto;
          return ListView.builder(
            itemCount: crypto.length, // EN EST ESTADO SI TIENE LA VARIABLE CRYPTO
            itemBuilder: (_, index){
              final cryptos = crypto[index];
              return ListTile(
                title: Text(cryptos.id),
                subtitle: Text(cryptos.symbol),
                trailing: Text(cryptos.price.toStringAsFixed(2)),);
            },
          );
        }
    );

  }
}
