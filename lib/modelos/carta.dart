/// Una carta de la lotería. Dos cartas con el mismo id son la misma carta.
class Carta {
  final int id;
  final String nombre;

  const Carta({required this.id, required this.nombre});

  @override
  bool operator ==(Object other) => other is Carta && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => nombre;
}
