abstract interface class InterfaceRepository<T> {
  Future<List<T>> getAll();
  Future<T?> add(T item);
  Future<T?> update(String id, T newItem);
  Future<T?> delete(String id);
  Future<T?> getById(String id);
}
