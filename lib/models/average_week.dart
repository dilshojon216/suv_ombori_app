import 'package:suv_ombori_app/models/id_model.dart';

class AverageWeek {
  IDmodel id;
  num avgSpeding;
  num avgValuing;
  num maxValuing;
  num minValuing;
  AverageWeek({
    required this.id,
    required this.avgSpeding,
    required this.avgValuing,
    required this.maxValuing,
    required this.minValuing,
  });

  AverageWeek.fromJson(Map<String, dynamic> json)
      : id = IDmodel.fromJson(json["_id"]),
        avgSpeding = json["avgSpeding"],
        avgValuing = json["avgValuing"],
        maxValuing = json["maxValuing"],
        minValuing = json["minValuing"];

  @override
  String toString() {
    return 'AverageWeek(id: $id, avgSpeding: $avgSpeding, maxValuing: $maxValuing, minValuing: $minValuing, avgValuing:$avgValuing)';
  }
}
