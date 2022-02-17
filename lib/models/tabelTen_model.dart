import 'tabel_model.dart';

class TabelTen {
  String number;
  Tabel? zero;
  Tabel? first;
  Tabel? two;
  Tabel? three;
  Tabel? four;
  Tabel? five;
  Tabel? six;
  Tabel? seven;
  Tabel? eight;
  Tabel? nine;
  TabelTen({
    required this.zero,
    required this.number,
    required this.first,
    required this.two,
    required this.three,
    required this.four,
    required this.five,
    required this.six,
    required this.seven,
    required this.eight,
    required this.nine,
  });

  @override
  String toString() {
    return 'TabelTen(number: $number, zero: $zero, first: $first, two: $two, three: $three, four: $four, five: $five, six: $six, seven: $seven, eight: $eight, nine: $nine)';
  }
}
