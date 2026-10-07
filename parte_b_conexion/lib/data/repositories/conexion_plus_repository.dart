import 'package:connectivity_plus/connectivity_plus.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/repositories/conexion_repository.dart';

class ConexionPlusRepository implements ConexionRepository {
  @override
  Future<EstadoConexion> consultarAhora() async {
    final resultados = await Connectivity().checkConnectivity();
    return _convertirEstado(resultados);
  }

  @override
  Stream<EstadoConexion> observarCambios() {
    return Connectivity().onConnectivityChanged.map(_convertirEstado);
  }

  EstadoConexion _convertirEstado(List<ConnectivityResult> resultados) {
    if (resultados.isEmpty) {
      return EstadoConexion.sinConexion;
    }

    if (resultados.contains(ConnectivityResult.wifi)) {
      return EstadoConexion.wifi;
    }

    if (resultados.contains(ConnectivityResult.mobile)) {
      return EstadoConexion.datosMoviles;
    }

    if (resultados.contains(ConnectivityResult.none)) {
      return EstadoConexion.sinConexion;
    }

    return EstadoConexion.otro;
  }
}
