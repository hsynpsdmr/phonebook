abstract class ServiceLocator {
  void register<T>(T service);
  T get<T>();
  void remove<T>();
}
