import 'dart:math';

import 'motor_2048.dart';

class Grid {
  List<List<int?>> celdas;

  Grid(this.celdas);

  static Grid vacio() => Grid(
        List.generate(4, (_) => List<int?>.filled(4, null)),
      );

  int moverIzquierda() {
    var puntos = 0;
    for (var fila = 0; fila < celdas.length; fila++) {
      final resultado = Motor2048.moverFilaIzquierda(celdas[fila]);
      celdas[fila] = resultado.fila;
      puntos += resultado.puntosGanados;
    }
    return puntos;
  }

  int moverDerecha() {
    var puntos = 0;
    for (var fila = 0; fila < celdas.length; fila++) {
      final invertida = celdas[fila].reversed.toList();
      final resultado = Motor2048.moverFilaIzquierda(invertida);
      celdas[fila] = resultado.fila.reversed.toList();
      puntos += resultado.puntosGanados;
    }
    return puntos;
  }

  List<List<int?>> _transponer(List<List<int?>> matriz) {
    final n = matriz.length;
    return List.generate(
      n,
      (i) => List.generate(n, (j) => matriz[j][i]),
    );
  }

  int moverArriba() {
    celdas = _transponer(celdas);
    final puntos = moverIzquierda();
    celdas = _transponer(celdas);
    return puntos;
  }

  int moverAbajo() {
    celdas = _transponer(celdas);
    final puntos = moverDerecha();
    celdas = _transponer(celdas);
    return puntos;
  }

  void agregarFichaAleatoria({Random? aleatorio}) {
    final rnd = aleatorio ?? Random();
    final vacias = <List<int>>[];

    for (var fila = 0; fila < celdas.length; fila++) {
      for (var columna = 0; columna < celdas[fila].length; columna++) {
        if (celdas[fila][columna] == null) {
          vacias.add([fila, columna]);
        }
      }
    }

    if (vacias.isEmpty) return;

    final elegida = vacias[rnd.nextInt(vacias.length)];
    final valor = rnd.nextDouble() < 0.9 ? 2 : 4;
    celdas[elegida[0]][elegida[1]] = valor;
  }

  bool hayCeldasVacias() =>
      celdas.expand((fila) => fila).any((valor) => valor == null);

  bool hayMovimientosPosibles() {
    if (hayCeldasVacias()) return true;

    for (var fila = 0; fila < celdas.length; fila++) {
      for (var columna = 0; columna < celdas[fila].length - 1; columna++) {
        if (celdas[fila][columna] == celdas[fila][columna + 1]) {
          return true;
        }
      }
    }

    for (var columna = 0; columna < celdas.length; columna++) {
      for (var fila = 0; fila < celdas.length - 1; fila++) {
        if (celdas[fila][columna] == celdas[fila + 1][columna]) {
          return true;
        }
      }
    }

    return false;
  }

  bool haGanado(int objetivo) =>
      celdas.expand((fila) => fila).any(
            (valor) => valor != null && valor >= objetivo,
          );
}
