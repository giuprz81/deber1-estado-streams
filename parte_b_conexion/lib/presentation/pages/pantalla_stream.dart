import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/estado_conexion.dart';
import '../cubit/conexion_cubit.dart';

class PantallaStream extends StatefulWidget {
  const PantallaStream({super.key});

  @override
  State<PantallaStream> createState() => _PantallaStreamState();
}

class _PantallaStreamState extends State<PantallaStream> {
  int _cambios = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monitoreo de conexion')),
      body: BlocListener<ConexionCubit, EstadoConexion>(
        listener: (context, estado) {
          setState(() {
            _cambios++;
          });
        },
        child: Center(
          child: BlocBuilder<ConexionCubit, EstadoConexion>(
            builder: (context, estado) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _iconoEstado(estado),
                    color: _colorEstado(estado),
                    size: 56,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _textoEstado(estado),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text('Cambios desde que se abrio: $_cambios'),
                  const SizedBox(height: 12),
                  const Text('Los cambios se actualizan automaticamente.'),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String _textoEstado(EstadoConexion estado) {
    switch (estado) {
      case EstadoConexion.wifi:
        return 'Wi-Fi';
      case EstadoConexion.datosMoviles:
        return 'Datos moviles';
      case EstadoConexion.otro:
        return 'Otra red';
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
}
