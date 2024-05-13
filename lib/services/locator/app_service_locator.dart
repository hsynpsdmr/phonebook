import 'dart:developer';

import 'service_locator.dart';

class AppServiceLocator implements ServiceLocator {
  static final AppServiceLocator _instance = AppServiceLocator._internal();
  factory AppServiceLocator() => _instance;
  AppServiceLocator._internal();
  final Map<Type, dynamic> _services = {};

  @override
  void register<T>(T service) {
    _services[service.runtimeType] = service;
  }

  @override
  T get<T>() {
    final serviceType = T;
    if (!_services.containsKey(serviceType)) {
      log('Service not found: $serviceType');
    }

    return _services[serviceType] as T;
  }

  @override
  void remove<T>() {
    _services.remove(T);
  }
}
