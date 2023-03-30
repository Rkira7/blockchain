import 'package:blockchain/app/domain/models/crypto/crypto.dart';

abstract class HomeState {}

class HomeStateLoading extends HomeState{}

class HomeStateFailed extends HomeState{}

class HomeStateLoaded extends HomeState{
  final List<Crypto> crypto;

  HomeStateLoaded(this.crypto);

}