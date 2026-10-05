import '../repositories/contador_repository.dart';

class ObtenerContador {
  final ContadorRepository repository;

  ObtenerContador(this.repository);

  Future<int> call() {
    return repository.leer();
  }
}
