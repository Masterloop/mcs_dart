import 'package:masterloop_core/src/modals/data_type.dart';

class Argument {
  final int id;
  final String name;
  final DataType dataType;

  Argument({this.id, this.name, this.dataType})
      : assert(id != null),
        assert(name != null),
        assert(dataType != null);

  factory Argument.fromJson(Map<String, dynamic> json) => json == null
      ? null
      : Argument(
          id: json["Id"],
          name: json["Name"],
          dataType: DataType.values[json["DataType"]],
        );

  @override
  operator ==(other) =>
      other is Argument &&
      other.id == id &&
      other.name == name &&
      other.dataType == dataType;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ dataType.hashCode;

  @override
  String toString() => "Argument: $id, $name, $dataType";
}
