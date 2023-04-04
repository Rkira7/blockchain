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
    final ExchangeRepository repository = context.read();
    return ChangeNotifierProvider(
        create: (_) => HomeBloc(
            exchangeRepository: context.read(),
          wsRepository: context.read()
        )..init(), //LLAMA AL METODO
      builder: (context, _){
          final HomeBloc bloc = context.watch();
          return Scaffold(
            appBar: const HomeAppBar(),
            body: bloc.state.map(
                loading: (_) => const Center(child: CircularProgressIndicator()),
                failed: (_) => const HomeError(),
                loaded: (_) => const HomeLoaded())
          );
      },
    );
  }
}
