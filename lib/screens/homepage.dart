import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as location;
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;

  final LatLng _initialcameraposition = const LatLng(0.0, 0.0);
  late GoogleMapController _controller;
  final location.Location _location = location.Location();
  @override
  void initState() {
    checkGps();
    super.initState();
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          debugPrint("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        setState(() {});
        getLocation();
      }
    } else {
      debugPrint("GPS Service is not enabled, turn on GPS location");
    }

    setState(() {});
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    position = await Geolocator.getCurrentPosition();
    debugPrint("${position.longitude}");
    debugPrint("${position.latitude}");

    long = position.longitude.toString();
    lat = position.latitude.toString();

    setState(() {});
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _location.onLocationChanged.listen(
      (l) {
        _controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(position.longitude, position.latitude),
                zoom: 15),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition:
                  CameraPosition(target: _initialcameraposition),
              myLocationEnabled: true,
              compassEnabled: true,
            ),
          ],
        ),
      ),
    );
  }
}
