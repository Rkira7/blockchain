import 'widgets/app_bar.dart';
import 'widgets/error.dart';
import 'widgets/loaded.dart';

import '../../../../domain/repositories/exchange_repository.dart';
import '../bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => HomeBloc(
            exchangeRepository: context.read(),
            wsRepository: context.read()
        )..init(), //LLAMA AL METODO PARA INICIALIZAR LA PETICION Y EL SOCKET
        builder: (context, _){
          final HomeBloc bloc = context.watch();
          return Scaffold(
            backgroundColor: const Color(0xffF2F5F8),
            appBar: const HomeAppBar(),
            body: bloc.state.map(
                loading: (_) => const Center(child: CircularProgressIndicator()),//MOSTRAR PROGRESS
                failed: (_) => const HomeError(), // ERROR
                loaded: (_) => const HomeLoaded()) // CONTENIDO
          );
      },
    );
  }
}
