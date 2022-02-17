class OnlineModel {
  String? sensorId;
  String sensorName;
  String sensorDistance;
  num sensorSpending;
  String sensorCorrection;
  String sensorTime;
  OnlineModel({
    required this.sensorName,
    required this.sensorDistance,
    required this.sensorSpending,
    required this.sensorCorrection,
    required this.sensorTime,
  });

  OnlineModel.fromJson(Map<String, dynamic> json)
      : sensorId = json["sensorId"],
        sensorName = json["sensorName"],
        sensorDistance = json["sensorDistance"],
        sensorSpending = json["sensorSpending"],
        sensorCorrection = json["sensorCorrection"],
        sensorTime = json["sensorTime"];

  @override
  String toString() {
    return 'OnlineModel(sensorId: $sensorId, sensorName: $sensorName, sensorDistance: $sensorDistance, sensorSpending: $sensorSpending, sensorCorrection: $sensorCorrection, sensorTime: $sensorTime)';
  }
}
