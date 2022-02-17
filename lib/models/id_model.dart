class IDmodel {
  String sensorName;
  String sensorTimeDay;
  IDmodel({
    required this.sensorName,
    required this.sensorTimeDay,
  });

  IDmodel.fromJson(Map<String, dynamic> json)
      : sensorName = json["sensorName"],
        sensorTimeDay = json["sensorTimeDay"];

  @override
  String toString() =>
      'IDmodel(sensorName: $sensorName, sensorTimeDay: $sensorTimeDay)';
}
