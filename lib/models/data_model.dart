class DataModel {
  String sensorName;
  String sensorDistance;
  num sensorSpending;
  num sensorVolume;
  String sensorTime;
  String sensorTimeDay;
  DataModel({
    required this.sensorName,
    required this.sensorDistance,
    required this.sensorSpending,
    required this.sensorVolume,
    required this.sensorTime,
    required this.sensorTimeDay,
  });

  DataModel.fromJson(Map<String, dynamic> json)
      : sensorName = json["sensorName"],
        sensorDistance = json["sensorDistance"],
        sensorSpending = json["sensorSpending"],
        sensorVolume = json["sensorVolume"],
        sensorTime = json["sensorTime"],
        sensorTimeDay = json["sensorTimeDay"];

  @override
  String toString() {
    return 'DataModel(sensorName: $sensorName, sensorDistance: $sensorDistance, sensorSpending: $sensorSpending, sensorVolume: $sensorVolume, sensorTime: $sensorTime, sensorTimeDay: $sensorTimeDay)';
  }
}
