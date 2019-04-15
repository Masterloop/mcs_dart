import 'package:dio/dio.dart';
import 'package:masterloop_core/core.dart' show Template, Device, Api;
import 'dart:async';

class TemplatesApi implements Api {
  static final String basePath = "/api/templates";

  final Dio _client;
  Future<Iterable<Template>> get all => _client
      .get(basePath)
      .then(
        (response) => List<Template>.unmodifiable(
              response.data.map((d) => Template.fromJson(d)),
            ),
      )
      .catchError((_) => null);

  TemplatesApi({Dio client})
      : assert(client != null),
        _client = client;

  Future<Template> operator [](String tid) => _client
      .get("$basePath/$tid")
      .then((response) => Template.fromJson(response.data))
      .catchError((_) => null);

  Future<Iterable<Device>> devices({String tid}) => _client
      .get("$basePath/$tid/devices")
      .then(
        (response) => List<Device>.unmodifiable(
              response.data.map((d) => Device.fromJson(d)),
            ),
      )
      .catchError((_) => null);
}
