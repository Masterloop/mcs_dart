import 'package:masterloop_core/src/models/template.dart';
import 'package:masterloop_core/src/utils.dart' show toDateTime;

class Device {
  final DateTime createdOn;
  final DateTime updatedOn;
  final DateTime latestPulse;
  final String tid;
  final String mid;
  final String name;
  final String description;
  final Template template;
  final DeviceState deviceState;
  final String preSharedKey;
  final String httpAuthenticationKey;

  Device({
    this.createdOn,
    this.updatedOn,
    this.latestPulse,
    this.tid,
    this.mid,
    this.name,
    this.description,
    this.template,
    this.preSharedKey,
    this.httpAuthenticationKey,
  })  : assert(mid != null),
        assert(name != null),
        deviceState = toDeviceState(latestPulse);

  factory Device.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    final Map<String, dynamic> metadata = json["Metadata"];

    return Device(
      createdOn: toDateTime(json["CreatedOn"]),
      updatedOn: toDateTime(json["UpdatedOn"]),
      latestPulse: toDateTime(json["LatestPulse"]),
      tid: json["TemplateId"],
      mid: json["MID"],
      name: json["Name"],
      description: json["Description"],
      template: Template.fromJson(metadata),
      preSharedKey: json["PreSharedKey"],
      httpAuthenticationKey: json["HTTPAuthenticationKey"],
    );
  }

  static DeviceState toDeviceState(DateTime latestPulse) {
    if (latestPulse == null) {
      return DeviceState.unknown;
    } else {
      final diff = latestPulse.difference(DateTime.now());

      if (diff.inHours <= 2 && diff.inDays == 0) {
        return DeviceState.online;
      } else if (diff.inDays <= 2) {
        return DeviceState.hibernate;
      } else {
        return DeviceState.offline;
      }
    }
  }

  @override
  bool operator ==(other) =>
      other is Device &&
      other.mid == mid &&
      other.name == name &&
      other.description == description &&
      other.createdOn == createdOn &&
      other.updatedOn == updatedOn;

  @override
  int get hashCode =>
      mid.hashCode ^
      name.hashCode ^
      description.hashCode ^
      createdOn.hashCode ^
      updatedOn.hashCode;

  @override
  String toString() => "Device: $mid, $name, $description";
}

enum DeviceState { online, offline, hibernate, unknown }
