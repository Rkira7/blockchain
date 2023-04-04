import '../../bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import '../../../../../domain/failures/http_request_failure.dart';

class HomeError extends StatelessWidget {
  const HomeError({Key? key,}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final HomeBloc bloc = context.watch();
    final state = bloc.state;

    return state.maybeWhen(
        orElse:() => const SizedBox(),
        failed: (failure){
          final String message = failure.when(
              network: () => 'Verifica tu internet',
              notFound: () => 'Informacion no encontrada',
              server: () => 'Error interno del servidor',
              unauthorized: () => 'Sin autorizacion',
              badRequest: () =>'No se realizo la peticion',
              local: () =>'Error desconocido');

          return  Center(child: Text(message));
        }

    );

  }
}
