class DataModel2 {
  String sensorName;
  String sensorDistance;
  num sensorSpending;
  num sensorVolume;
  String sensorTime;
  DataModel2(
      {required this.sensorName,
      required this.sensorDistance,
      required this.sensorSpending,
      required this.sensorVolume,
      required this.sensorTime});

  DataModel2.fromJson(Map<String, dynamic> json)
      : sensorName = json["sensorName"],
        sensorDistance = json["sensorDistance"],
        sensorSpending = json["sensorSpending"],
        sensorVolume = json["sensorVolume"],
        sensorTime = json["sensorTime"];

  @override
  String toString() {
    return 'DataModel(sensorName: $sensorName, sensorDistance: $sensorDistance, sensorSpending: $sensorSpending, sensorVolume: $sensorVolume, sensorTime: $sensorTime)';
  }
}
