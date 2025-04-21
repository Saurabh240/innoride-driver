import 'dart:convert';

class DriverPosition {
  String latitude;
  String longitude;
  String driverId;
  String userId;
  String rideId;
  DriverPosition({
    required this.latitude,
    required this.longitude,
    required this.driverId,
    required this.userId,
    required this.rideId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'latitude': latitude,
      'longitude': longitude,
      'driverId': driverId,
      'userId': userId,
      'rideId': rideId,
    };
  }

  factory DriverPosition.fromMap(Map<String, dynamic> map) {
    return DriverPosition(
      latitude: map['latitude'] as String,
      longitude: map['longitude'] as String,
      driverId: map['driverId'] as String,
      userId: map['userId'] as String,
      rideId: map['rideId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DriverPosition.fromJson(String source) =>
      DriverPosition.fromMap(json.decode(source) as Map<String, dynamic>);
}
