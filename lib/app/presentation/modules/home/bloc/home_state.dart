import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../domain/models/crypto/crypto.dart';

part 'home_state.freezed.dart';

@freezed
class HomeState with _$HomeState{
  factory HomeState.loading() =  HomeStateLoading;
  factory HomeState.failed() =  HomeStateFailed;
  factory HomeState.loaded(List<Crypto> crypto) =  HomeStateLoaded;

}
