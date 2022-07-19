import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';

class LocationService with ChangeNotifier {
  double lat;
  double lng;
  bool locationLoading = false;

  getLocation() async {
    locationLoading = true;
    notifyListeners();
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        locationLoading = false;
        notifyListeners();
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        locationLoading = false;
        notifyListeners();
        return;
      }
    }

    _locationData = await location.getLocation();
    lat = _locationData.latitude;
    lng = _locationData.longitude;
    locationLoading = false;
    notifyListeners();
  }
}
