import 'package:flutter/material.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/use_cases/consultar_conexion.dart';

class PantallaFuture extends StatefulWidget {
  final ConsultarConexion consultarConexion;

  const PantallaFuture({super.key, required this.consultarConexion});

  @override
  State<PantallaFuture> createState() => _PantallaFutureState();
}

class _PantallaFutureState extends State<PantallaFuture> {
  EstadoConexion? _estadoConexion;
  DateTime? _ultimaConsulta;
  String? _error;
  bool _cargando = false;

  Future<void> _consultarAhora() async {
    setState(() {
      _cargando = true;
      _error = null;
    });

    try {
      final estado = await widget.consultarConexion();

      if (!mounted) return;

      setState(() {
        _estadoConexion = estado;
        _ultimaConsulta = DateTime.now();
        _cargando = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _error = 'No se pudo consultar el estado de conexion.';
        _cargando = false;
      });
    }
  }

  String _textoEstado(EstadoConexion estado) {
    switch (estado) {
      case EstadoConexion.wifi:
        return 'Conectado a WiFi';
      case EstadoConexion.datosMoviles:
        return 'Conectado con datos moviles';
      case EstadoConexion.otro:
        return 'Conectado a otra red';
      case EstadoConexion.sinConexion:
        return 'Sin conexion';
    }
  }

  IconData _iconoEstado(EstadoConexion estado) {
    switch (estado) {
      case EstadoConexion.wifi:
        return Icons.wifi;
      case EstadoConexion.datosMoviles:
        return Icons.signal_cellular_alt;
      case EstadoConexion.otro:
        return Icons.settings_ethernet;
      case EstadoConexion.sinConexion:
        return Icons.wifi_off;
    }
  }

  Color _colorEstado(EstadoConexion estado) {
    switch (estado) {
      case EstadoConexion.wifi:
      case EstadoConexion.datosMoviles:
        return Colors.green;
      case EstadoConexion.otro:
        return Colors.orange;
      case EstadoConexion.sinConexion:
        return Colors.red;
    }
  }

  String _formatearHora(DateTime fecha) {
    final horas = fecha.hour.toString().padLeft(2, '0');
    final minutos = fecha.minute.toString().padLeft(2, '0');
    final segundos = fecha.second.toString().padLeft(2, '0');
    return '$horas:$minutos:$segundos';
  }

  @override
  Widget build(BuildContext context) {
    final hora = _ultimaConsulta == null
        ? null
        : _formatearHora(_ultimaConsulta!);

    return Scaffold(
      appBar: AppBar(title: const Text('Conexion')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_cargando) const CircularProgressIndicator(),
              if (_error != null) ...[
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 12),
                Text(_error!),
              ],
              if (_estadoConexion != null && !_cargando) ...[
                Icon(
                  _iconoEstado(_estadoConexion!),
                  color: _colorEstado(_estadoConexion!),
                  size: 56,
                ),
                const SizedBox(height: 12),
                Text(
                  _textoEstado(_estadoConexion!),
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
              ],
              if (hora != null) ...[
                const SizedBox(height: 12),
                Text('Ultima consulta: $hora'),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _cargando ? null : _consultarAhora,
                child: const Text('Consultar ahora'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
