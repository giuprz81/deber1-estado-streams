import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/use_cases/consultar_conexion.dart';
import '../../domain/use_cases/observar_conexion.dart';

class ConexionCubit extends Cubit<EstadoConexion> {
  final ConsultarConexion _consultarConexion;
  final ObservarConexion _observarConexion;
  StreamSubscription<EstadoConexion>? _suscripcion;

  ConexionCubit(this._consultarConexion, this._observarConexion)
      : super(EstadoConexion.otro);

  Future<void> iniciar() async {
    final estadoActual = await _consultarConexion();
    emit(estadoActual);

    _suscripcion = _observarConexion().listen((estado) {
      emit(estado);
    });
  }

  @override
  Future<void> close() async {
    await _suscripcion?.cancel();
    return super.close();
  }
}
