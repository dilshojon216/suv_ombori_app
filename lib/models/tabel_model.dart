class Tabel {
  String sensorName;
  int tabelNumber;
  String tabelValue;
  Tabel({
    required this.sensorName,
    required this.tabelNumber,
    required this.tabelValue,
  });

  Tabel.fromJson(Map<String, dynamic> json)
      : sensorName = json["sensorName"],
        tabelNumber = json["tabelNumber"],
        tabelValue = json["tabelValue"];

  Map<String, dynamic> toJson() {
    return {
      "sensorName": sensorName,
      "tabelNumber": tabelNumber.toInt(),
      "tabelValue": tabelValue
    };
  }

  @override
  String toString() =>
      'Tabel(sensorName: $sensorName, tabelNumber: $tabelNumber, tabelValue: $tabelValue)';
}
