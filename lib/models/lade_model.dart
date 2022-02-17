class LadeModel {
  String? id;
  String sensorId;
  String sensorName;
  String sensorDistance;
  String sensorCorrection;
  String sensorLavel;

  LadeModel({
    this.id,
    required this.sensorId,
    required this.sensorName,
    required this.sensorDistance,
    required this.sensorLavel,
    required this.sensorCorrection,
  });

  LadeModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        sensorId = json["sensorId"],
        sensorName = json["sensorName"],
        sensorDistance = json["sensorDistance"],
        sensorLavel = json["sensorLavel"],
        sensorCorrection = json["sensorCorrection"];

  Map<String, String> toJson() {
    return {
      "id": id!,
      "sensorId": sensorId,
      "sensorName": sensorName,
      "sensorDistance": sensorDistance,
      "sensorCorrection": sensorCorrection,
      "sensorLavel": sensorLavel,
    };
  }

  @override
  String toString() {
    return 'LadeModel(id: $id, sensorId: $sensorId, sensorName: $sensorName, sensorDistance: $sensorDistance, sensorCorrection: $sensorCorrection, sensorLavel:$sensorLavel)';
  }
}
