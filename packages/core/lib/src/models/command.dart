import 'package:masterloop_core/src/models/argument.dart';

class Command {
  final int id;
  final String name;
  final String description;
  final Iterable<Argument> arguments;

  Command({this.id, this.name, this.description, this.arguments})
      : assert(id != null),
        assert(name != null);

  factory Command.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    Iterable<T> toList<T>(Iterable items) => items == null
        ? null
        : List<T>.unmodifiable(
            items.map(
              (a) => Argument.fromJson(a),
            ),
          );

    return Command(
      id: json["Id"],
      name: json["Name"],
      description: json["Description"],
      arguments: toList(json["Arguments"]),
    );
  }

  @override
  bool operator ==(other) =>
      other is Command &&
      other.id == id &&
      other.name == name &&
      other.description == description;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ description.hashCode;

  @override
  String toString() => "Command: $id, $name, $description, $arguments";
}
