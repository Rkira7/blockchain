import '../../bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';


const color = <String, Color>{
  'BTC' : Colors.orange,
  'ETH' : Colors.deepPurple,
  'USDT' : Colors.green,
  'BNB' : Colors.yellow,
  'USDC' : Colors.blue,
  'DODGE' : Colors.amber,
  'LTC' : Colors.grey,
  'XMR' : Colors.deepOrangeAccent,
};

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
            padding: const EdgeInsets.all(10),
            itemCount: crypto.length, // EN EST ESTADO SI TIENE LA VARIABLE CRYPTO
            itemBuilder: (_, index){
              final cryptos = crypto[index];
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset('assets/icons/${cryptos.symbol}.svg',
                        width: 30,
                        height: 30,
                        color: color[cryptos.symbol],
                      ),
                    ],
                  ),
                  title: Text(cryptos.name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(cryptos.symbol),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          NumberFormat.currency(name: '\$ ').format(cryptos.price),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),


                      Text('${cryptos.changePercent24Hr.toStringAsFixed(2)}%',
                        style: TextStyle(
                            color: cryptos.changePercent24Hr.isNegative
                                ? Colors.redAccent
                                : Colors.green),),
                    ],
                  ),),
              );
            },
          );
        }
    );

  }
}
