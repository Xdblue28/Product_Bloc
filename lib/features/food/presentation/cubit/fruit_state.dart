import 'package:bloc_cubit1/features/food/domain/entities/fruit.dart';
import 'package:equatable/equatable.dart';

abstract class FruitState extends Equatable {
  const FruitState();
  @override
  List<Object?> get props => [];
}

class FruitInitial extends FruitState {}

class FruitLoading extends FruitState {}

class FruitSuccess extends FruitState {
  final List<Fruit> fruits;
  const FruitSuccess(this.fruits);
  @override
  List<Object?> get props => [fruits, DateTime.now()];
}

class FruitFailure extends FruitState {}
