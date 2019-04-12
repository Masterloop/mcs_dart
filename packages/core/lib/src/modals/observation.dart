import 'package:masterloop_core/src/modals/data_type.dart';

class Observation {
  final int id;
  final String name;
  final String description;
  final DataType dataType;

  Observation({
    this.id,
    this.name,
    this.description,
    this.dataType,
  })  : assert(id != null),
        assert(name != null),
        assert(dataType != null);

  factory Observation.fromJson(Map<String, dynamic> json) => json == null
      ? null
      : Observation(
          id: json["Id"],
          name: json["Name"],
          description: json["Description"],
          dataType: DataType.values[json["DataType"]],
        );

  @override
  bool operator ==(other) =>
      other is Observation &&
      id == other.id &&
      other.name == name &&
      other.description == description &&
      other.dataType == dataType;

  @override
  int get hashCode =>
      id.hashCode ^ name.hashCode ^ description.hashCode ^ dataType.hashCode;

  @override
  String toString() => "Observation: $id, $name, $description";
}
