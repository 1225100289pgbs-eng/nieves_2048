import 'package:flutter/material.dart';

import '../logica/direccion.dart';
import '../logica/estado_juego.dart';
import '../logica/motor_juego.dart';

class Ficha extends StatelessWidget {
  final int? valor;

  const Ficha({super.key, required this.valor});

  static const Map<int, List<Color>> _gradientes = {
    2: [Color(0xFFFFFDE7), Color(0xFFFFF9C4)],
    4: [Color(0xFFF8BBD0), Color(0xFFF48FB1)],
    8: [Color(0xFFD7CCC8), Color(0xFFA1887F)],
    16: [Color(0xFFFFE0B2), Color(0xFFFFB74D)],
    32: [Color(0xFFC8E6C9), Color(0xFF81C784)],
    64: [Color(0xFFE1BEE7), Color(0xFFBA68C8)],
    128: [Color(0xFF8D6E63), Color(0xFF4E342E)],
    256: [Color(0xFFFFE082), Color(0xFFFFC107)],
    512: [Color(0xFF6D4C41), Color(0xFF3E2723)],
    1024: [Color(0xFFFFF3E0), Color(0xFFFFCC80)],
    2048: [Color(0xFF006341), Color(0xFFFFFFFF)],
  };

  static const Map<int, String> _nombres = {
    2: 'Vainilla',
    4: 'Fresa',
    8: 'Chocolate',
    16: 'Mango',
    32: 'Limón',
    64: 'Uva',
    128: 'Mole',
    256: 'Tequila',
    512: 'Café',
    1024: 'Rompope',
    2048: '¡Independencia!',
  };

  @override
  Widget build(BuildContext context) {
    final colores = _gradientes[valor] ??
        [Colors.grey.shade200, Colors.grey.shade300];

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) =>
          ScaleTransition(scale: animation, child: child),
      child: Container(
        key: ValueKey(valor),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colores,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: valor == null
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        alignment: Alignment.center,
        child: valor == null
            ? null
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    valor.toString(),
                    style: TextStyle(
                      fontSize: valor! >= 128 ? 18 : 22,
                      fontWeight: FontWeight.bold,
                      color: valor! >= 128 ? Colors.white : Colors.black87,
                    ),
                  ),
                  Text(
                    _nombres[valor] ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      color: valor! >= 128 ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
      ),
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
  bool _dialogoVisible = false;

  @override
  void initState() {
    super.initState();
    _motor = MotorJuego();
  }

  void _mover(Direccion direccion) {
    if (_motor.estado != EstadoJuego.jugando) return;
    setState(() => _motor.mover(direccion));
    if (_motor.estado != EstadoJuego.jugando && !_dialogoVisible) {
      _mostrarResultado();
    }
  }

  void _mostrarResultado() {
    _dialogoVisible = true;
    final gano = _motor.estado == EstadoJuego.ganado;

    showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'resultado',
      transitionDuration: const Duration(milliseconds: 450),
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.elasticOut),
          child: FadeTransition(
            opacity: animation,
            child: AlertDialog(
              title: Text(
                gano ? '¡Independencia lograda!' : 'Se acabaron los movimientos',
              ),
              content: Text('Puntaje final: ${_motor.puntaje}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() => _motor = MotorJuego());
                    _dialogoVisible = false;
                  },
                  child: const Text('Jugar de nuevo'),
                ),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      _dialogoVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nieves 2048 - Dolores Hidalgo')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TweenAnimationBuilder<int>(
                tween: IntTween(begin: 0, end: _motor.puntaje),
                duration: const Duration(milliseconds: 400),
                builder: (context, valor, _) => Text(
                  'Puntaje: $valor',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onHorizontalDragEnd: (detalle) {
                  final velocidad = detalle.primaryVelocity ?? 0;
                  if (velocidad > 0) _mover(Direccion.derecha);
                  if (velocidad < 0) _mover(Direccion.izquierda);
                },
                onVerticalDragEnd: (detalle) {
                  final velocidad = detalle.primaryVelocity ?? 0;
                  if (velocidad > 0) _mover(Direccion.abajo);
                  if (velocidad < 0) _mover(Direccion.arriba);
                },
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: 16,
                    itemBuilder: (context, indice) {
                      final valor =
                          _motor.grid.celdas[indice ~/ 4][indice % 4];
                      return Ficha(valor: valor);
                    },
                  ),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Desliza en cualquier dirección para mover las nieves',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
