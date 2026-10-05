import '../repositories/contador_repository.dart';

class Decrementar {
  final ContadorRepository repository;

  Decrementar(this.repository);

  Future<int> call() async {
    final valorActual = await repository.leer();
    final nuevoValor = valorActual - 1;
    await repository.guardar(nuevoValor);
    return nuevoValor;
  }
}
