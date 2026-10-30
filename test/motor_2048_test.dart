import 'package:flutter_test/flutter_test.dart';
import 'package:nieves_2048/logica/motor_2048.dart';

void main() {
  test('compactarFila quita los huecos y mantiene el orden', () {
    expect(Motor2048.compactarFila([2, null, 4, null]), [2, 4, null, null]);
  });

  test('compactarFila sin huecos no cambia nada', () {
    expect(Motor2048.compactarFila([2, 4, 8, 16]), [2, 4, 8, 16]);
  });

  test('fusionarFila combina un par adyacente igual', () {
    final resultado = Motor2048.fusionarFila([2, 2, 4, null]);
    expect(resultado.fila, [4, null, 4, null]);
    expect(resultado.puntosGanados, 4);
  });

  test('fusionarFila no fusiona tres iguales seguidos más de una vez', () {
    final resultado = Motor2048.fusionarFila([2, 2, 2, null]);
    expect(resultado.fila, [4, null, 2, null]);
    expect(resultado.puntosGanados, 4);
  });

  test('mover una fila a la izquierda compacta y fusiona correctamente', () {
    final resultado = Motor2048.moverFilaIzquierda([null, 2, 2, 4]);
    expect(resultado.fila, [4, 4, null, null]);
    expect(resultado.puntosGanados, 4);
    expect(resultado.seMovio, isTrue);
  });

  test('una fila en su posición final reporta seMovio en falso', () {
    final resultado = Motor2048.moverFilaIzquierda([2, 4, null, null]);
    expect(resultado.seMovio, isFalse);
  });
}
