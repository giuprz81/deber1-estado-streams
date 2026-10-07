import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/repositories/conexion_plus_repository.dart';
import 'domain/use_cases/consultar_conexion.dart';
import 'domain/use_cases/observar_conexion.dart';
import 'presentation/cubit/conexion_cubit.dart';
import 'presentation/pages/pantalla_future.dart';
import 'presentation/pages/pantalla_stream.dart';

void main() {
  final repository = ConexionPlusRepository();
  final consultarConexion = ConsultarConexion(repository);
  final observarConexion = ObservarConexion(repository);

  runApp(
    BlocProvider(
      create: (context) =>
          ConexionCubit(consultarConexion, observarConexion)..iniciar(),
      child: MyApp(consultarConexion: consultarConexion),
    ),
  );
}

class MyApp extends StatelessWidget {
  final ConsultarConexion consultarConexion;

  const MyApp({super.key, required this.consultarConexion});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conexion',
      theme: ThemeData(useMaterial3: true),
      home: PantallaPrincipal(consultarConexion: consultarConexion),
    );
  }
}

class PantallaPrincipal extends StatefulWidget {
  final ConsultarConexion consultarConexion;

  const PantallaPrincipal({super.key, required this.consultarConexion});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  int _indiceActual = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _indiceActual,
        children: [
          PantallaFuture(consultarConexion: widget.consultarConexion),
          const PantallaStream(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indiceActual,
        onDestinationSelected: (indice) {
          setState(() {
            _indiceActual = indice;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.refresh),
            label: 'Con Future',
          ),
          NavigationDestination(
            icon: Icon(Icons.wifi),
            label: 'Con Stream',
          ),
        ],
      ),
    );
  }
}
