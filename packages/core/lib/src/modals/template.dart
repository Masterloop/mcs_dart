import 'package:masterloop_core/src/modals/observation.dart';
import 'package:masterloop_core/src/modals/command.dart';

class Template {
  final String tid;
  final String name;
  final String description;
  final String revision;

  final Iterable<Observation> observations;
  final Iterable<Command> commands;

  Template({
    this.tid,
    this.name,
    this.description,
    this.revision,
    this.observations,
    this.commands,
  })  : assert(tid != null),
        assert(name != null),
        assert(revision != null);

  factory Template.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    Iterable<T> toList<T>(Iterable items, mapper) => items == null
        ? null
        : List<T>.unmodifiable(
            items.map((o) => mapper(o)) ?? [],
          );

    return Template(
      tid: json["Id"],
      name: json["Name"],
      description: json["Description"],
      revision: json["Revision"],
      observations: toList(
        json["Observations"],
        (o) => Observation.fromJson(o),
      ),
      commands: toList(
        json["Commands"],
        (c) => Command.fromJson(c),
      ),
    );
  }

  @override
  bool operator ==(other) =>
      other is Template &&
      other.tid == tid &&
      other.name == name &&
      other.description == description &&
      other.revision == revision &&
      other.observations == observations &&
      other.commands == commands;

  @override
  int get hashCode =>
      tid.hashCode ^
      name.hashCode ^
      description.hashCode ^
      revision.hashCode ^
      observations.hashCode ^
      commands.hashCode;

  @override
  String toString() => "Device: $tid, $name, $description, $revision";
}
