// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'crypto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Crypto {
  String get id => throw _privateConstructorUsedError;
  String get symbol => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CryptoCopyWith<Crypto> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CryptoCopyWith<$Res> {
  factory $CryptoCopyWith(Crypto value, $Res Function(Crypto) then) =
      _$CryptoCopyWithImpl<$Res>;
  $Res call({String id, String symbol, double price});
}

/// @nodoc
class _$CryptoCopyWithImpl<$Res> implements $CryptoCopyWith<$Res> {
  _$CryptoCopyWithImpl(this._value, this._then);

  final Crypto _value;
  // ignore: unused_field
  final $Res Function(Crypto) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? symbol = freezed,
    Object? price = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: symbol == freezed
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      price: price == freezed
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
abstract class _$$_CryptoCopyWith<$Res> implements $CryptoCopyWith<$Res> {
  factory _$$_CryptoCopyWith(_$_Crypto value, $Res Function(_$_Crypto) then) =
      __$$_CryptoCopyWithImpl<$Res>;
  @override
  $Res call({String id, String symbol, double price});
}

/// @nodoc
class __$$_CryptoCopyWithImpl<$Res> extends _$CryptoCopyWithImpl<$Res>
    implements _$$_CryptoCopyWith<$Res> {
  __$$_CryptoCopyWithImpl(_$_Crypto _value, $Res Function(_$_Crypto) _then)
      : super(_value, (v) => _then(v as _$_Crypto));

  @override
  _$_Crypto get _value => super._value as _$_Crypto;

  @override
  $Res call({
    Object? id = freezed,
    Object? symbol = freezed,
    Object? price = freezed,
  }) {
    return _then(_$_Crypto(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      symbol: symbol == freezed
          ? _value.symbol
          : symbol // ignore: cast_nullable_to_non_nullable
              as String,
      price: price == freezed
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$_Crypto implements _Crypto {
  _$_Crypto({required this.id, required this.symbol, required this.price});

  @override
  final String id;
  @override
  final String symbol;
  @override
  final double price;

  @override
  String toString() {
    return 'Crypto(id: $id, symbol: $symbol, price: $price)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Crypto &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.symbol, symbol) &&
            const DeepCollectionEquality().equals(other.price, price));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(symbol),
      const DeepCollectionEquality().hash(price));

  @JsonKey(ignore: true)
  @override
  _$$_CryptoCopyWith<_$_Crypto> get copyWith =>
      __$$_CryptoCopyWithImpl<_$_Crypto>(this, _$identity);
}

abstract class _Crypto implements Crypto {
  factory _Crypto(
      {required final String id,
      required final String symbol,
      required final double price}) = _$_Crypto;

  @override
  String get id;
  @override
  String get symbol;
  @override
  double get price;
  @override
  @JsonKey(ignore: true)
  _$$_CryptoCopyWith<_$_Crypto> get copyWith =>
      throw _privateConstructorUsedError;
}
