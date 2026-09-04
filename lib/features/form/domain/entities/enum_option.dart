import 'package:equatable/equatable.dart';

/// A single option inside a dropdown's `enums` list.
/// e.g. {"code": "IN", "name": "Stock In"}
class EnumOption extends Equatable {
  final String code;
  final String name;

  const EnumOption({required this.code, required this.name});

  @override
  List<Object?> get props => [code, name];
}