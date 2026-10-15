import '../modelos/carta.dart';

class Tabla {
  final List<List<Carta>> filas;
  final List<List<bool>> marcadas;

  /// Constructor con el acomodo exacto de las filas (para las pruebas).
  Tabla.desdeFilas(this.filas)
      : marcadas = List.generate(4, (_) => List.generate(4, (_) => false));

  /// Tabla de 4x4 con las cartas en orden aleatorio.
  static Tabla generar(List<Carta> cartas) {
    final copia = List<Carta>.from(cartas)..shuffle();
    final filas = <List<Carta>>[];
    for (var f = 0; f < 4; f++) {
      filas.add(copia.sublist(f * 4, f * 4 + 4));
    }
    return Tabla.desdeFilas(filas);
  }

  /// Marca la celda de la carta cantada; si no está en la tabla, no hace nada.
  void marcar(Carta carta) {
    for (var f = 0; f < filas.length; f++) {
      for (var c = 0; c < filas[f].length; c++) {
        if (filas[f][c] == carta) {
          marcadas[f][c] = true;
          return;
        }
      }
    }
  }
}
