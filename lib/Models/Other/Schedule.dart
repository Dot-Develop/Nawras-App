import 'package:flutter/cupertino.dart';

class Schedule {
  final int id;
  final int salePersonId;
  final String name;
  final String phone;
  final String day;
  final String lat;
  final String lng;
  final String zoneName;
  final DateTime createdAt;

  Schedule({
    @required this.id,
    @required this.salePersonId,
    @required this.name,
    @required this.phone,
    @required this.day,
    @required this.lat,
    @required this.lng,
    @required this.zoneName,
    @required this.createdAt,
  });

  factory Schedule.fromJson(Map<String, dynamic> data) => Schedule(
        id: data['id'],
        salePersonId: data['sale_person_id'],
        name: data['name'],
        phone: data['phone'],
        day: data['day'],
        lat: data['lat'],
        lng: data['lng'],
        zoneName: data['zone_name'],
        createdAt: DateTime.parse(data['created_at']),
      );
}
