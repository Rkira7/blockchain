import '../../bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class HomeAppBar extends StatelessWidget with PreferredSizeWidget{
  const HomeAppBar({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final HomeBloc bloc = context.watch();
    return AppBar(
      title: bloc.state.mapOrNull(
          loaded: (state) => Text(
            //COMPRUEBA EL ETADO Y MUESTRA EL ESTADO
              state.wsStatus.when(
                  connecting: () => 'connecting',
                  connected: () => 'connected',
                  failed:() => 'failed')

          )
      ) ,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
