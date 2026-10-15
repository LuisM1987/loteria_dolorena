import 'package:flutter/material.dart';

import 'logica/baraja.dart';
import 'logica/motor_juego.dart';
import 'logica/tabla.dart';

void main() => runApp(const LoteriaApp());

class LoteriaApp extends StatelessWidget {
  const LoteriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lotería Doloreña',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const JuegoScreen(),
    );
  }
}

class JuegoScreen extends StatefulWidget {
  const JuegoScreen({super.key});

  @override
  State<JuegoScreen> createState() => _JuegoScreenState();
}

class _JuegoScreenState extends State<JuegoScreen> {
  late MotorJuego _motor;
  late Tabla _tabla;
  String _ultimaCarta = 'Toca Cantar para empezar';

  @override
  void initState() {
    super.initState();
    _nuevoJuego();
  }

  /// Crea baraja, tabla y motor nuevos (sin avisar a la pantalla).
  void _nuevoJuego() {
    final baraja = Baraja.crearBarajaCompleta()..mezclar();
    _tabla = Tabla.generar(Baraja.crearBarajaCompleta().cartasRestantes);
    _motor = MotorJuego(baraja: baraja, tabla: _tabla);
    _ultimaCarta = 'Toca Cantar para empezar';
  }

  void _reiniciar() {
    setState(_nuevoJuego);
  }

  void _cantar() {
    final carta = _motor.cantarYMarcar();
    setState(() => _ultimaCarta = carta?.nombre ?? 'Ya no quedan cartas');

    if (_motor.haGanado) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: const Text('¡Lotería!'),
          content: const Text('Completaste una línea, columna o diagonal.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _reiniciar();
              },
              child: const Text('Jugar de nuevo'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lotería Doloreña')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              _ultimaCarta,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemCount: 16,
              itemBuilder: (context, i) {
                final f = i ~/ 4;
                final col = i % 4;
                final carta = _tabla.filas[f][col];
                final marcada = _tabla.marcadas[f][col];
                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: marcada ? Colors.deepOrange : Colors.orange.shade50,
                    border: Border.all(color: Colors.deepOrange),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      carta.nombre,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        color: marcada ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: _cantar,
              icon: const Icon(Icons.campaign),
              label: const Text('Cantar siguiente carta'),
            ),
          ),
        ],
      ),
    );
  }
}
