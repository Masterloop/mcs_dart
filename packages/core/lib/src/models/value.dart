import 'package:masterloop_core/src/utils.dart' show toDateTime;

abstract class LiveValue {}

class Value<T> {
  final T value;
  final DateTime timestamp;

  Value({
    this.value,
    this.timestamp,
  });

  factory Value.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return Value(
      value: json["Value"] as T,
      timestamp: toDateTime(json["Timestamp"]),
    );
  }

  Value<C> cast<C>() => Value<C>(
        value: value as C,
        timestamp: timestamp,
      );

  @override
  operator ==(other) =>
      other is Value && other.value == value && other.timestamp == timestamp;

  @override
  int get hashCode => value.hashCode ^ timestamp.hashCode;

  @override
  String toString() => "Value $value, sent @ $timestamp";
}

class ObservationValue extends Value implements LiveValue {
  final int id;

  ObservationValue({
    this.id,
    dynamic value,
    DateTime timestamp,
  })  : assert(id != null),
        super(
          value: value,
          timestamp: timestamp,
        );

  factory ObservationValue.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return ObservationValue(
      id: json["Id"],
      value: json["Value"],
      timestamp: toDateTime(json["Timestamp"]),
    );
  }

  @override
  operator ==(other) =>
      other is ObservationValue && other.id == id && super == other;

  @override
  int get hashCode => id.hashCode ^ super.hashCode;

  @override
  String toString() => "ObservationValue $id = $value, sent @ $timestamp";
}

class CommandValue implements LiveValue {
  final int id;
  final DateTime deliveredAt;
  final DateTime timestamp;
  final DateTime expiresAt;
  final bool wasAccepted;
  final Iterable<ArgumentValue> arguments;

  CommandValue({
    this.id,
    this.deliveredAt,
    this.timestamp,
    this.expiresAt,
    this.wasAccepted,
    this.arguments,
  }) : assert(id != null);

  factory CommandValue.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return CommandValue(
      id: json["Id"],
      deliveredAt: toDateTime(json["DeliveredAt"]),
      timestamp: toDateTime(json["Timestamp"]),
      expiresAt: toDateTime(json["ExpiresAt"]),
      wasAccepted: json["WasAccepted"],
      arguments: List.unmodifiable(
        json["Arguments"]?.map(
          (v) => ArgumentValue.fromJson(v),
        ),
      ),
    );
  }
  @override
  operator ==(other) =>
      other is CommandValue &&
      other.id == id &&
      other.deliveredAt == deliveredAt &&
      other.timestamp == timestamp &&
      other.expiresAt == expiresAt &&
      other.wasAccepted == wasAccepted &&
      other.arguments == arguments;

  @override
  int get hashCode =>
      id.hashCode ^
      deliveredAt.hashCode ^
      timestamp.hashCode ^
      expiresAt.hashCode ^
      wasAccepted.hashCode ^
      arguments.hashCode;

  @override
  String toString() =>
      "CommandValue $id, sent @ $timestamp with arguments $arguments, delivered @ $deliveredAt, expires @ $expiresAt, wasAccepted? $wasAccepted";
}

class ArgumentValue {
  final int id;
  final dynamic value;

  ArgumentValue({this.id, this.value});

  factory ArgumentValue.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return ArgumentValue(
      id: json["Id"],
      value: json["Value"],
    );
  }

  @override
  operator ==(other) =>
      other is ArgumentValue && other.id == id && other.value == value;

  @override
  int get hashCode => id.hashCode ^ value.hashCode;

  @override
  String toString() => "ArgumentValue $id = $value";
}
