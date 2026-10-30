import 'dart:math';

import 'direccion.dart';
import 'estado_juego.dart';
import 'grid.dart';

class MotorJuego {
  Grid grid;
  int puntaje = 0;
  EstadoJuego estado = EstadoJuego.jugando;
  static const int objetivoVictoria = 2048;

  MotorJuego({Random? aleatorio}) : grid = Grid.vacio() {
    grid.agregarFichaAleatoria(aleatorio: aleatorio);
    grid.agregarFichaAleatoria(aleatorio: aleatorio);
  }

  void mover(Direccion direccion) {
    if (estado != EstadoJuego.jugando) return;

    final antes = grid.celdas.map((fila) => List<int?>.from(fila)).toList();

    int puntosGanados;
    switch (direccion) {
      case Direccion.izquierda:
        puntosGanados = grid.moverIzquierda();
      case Direccion.derecha:
        puntosGanados = grid.moverDerecha();
      case Direccion.arriba:
        puntosGanados = grid.moverArriba();
      case Direccion.abajo:
        puntosGanados = grid.moverAbajo();
    }

    puntaje += puntosGanados;

    if (grid.haGanado(objetivoVictoria)) {
      estado = EstadoJuego.ganado;
      return;
    }

    final huboMovimiento = !_gridsIguales(antes, grid.celdas);
    if (huboMovimiento) {
      grid.agregarFichaAleatoria();
    }

    if (!grid.hayMovimientosPosibles()) {
      estado = EstadoJuego.perdido;
    }
  }

  bool _gridsIguales(List<List<int?>> a, List<List<int?>> b) {
    for (var fila = 0; fila < a.length; fila++) {
      for (var columna = 0; columna < a[fila].length; columna++) {
        if (a[fila][columna] != b[fila][columna]) return false;
      }
    }
    return true;
  }
}
