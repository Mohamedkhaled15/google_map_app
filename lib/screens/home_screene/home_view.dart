import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
// StreamSubscription<Position>? positionStream;
  double startLatitude =52.2165157;
  double startLongitude=6.9437819;
  double endLatitude= 52.3546274;
  double endLongitude=  4.8285838;


  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {

      if (kDebugMode) {
        print('لازم تشغل خدمة الموقع علي تليفونك يبو عمو');
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

        return Future.error('ياغالي denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {

      return Future.error(
          'Location permission permanently denied');
    }
    if(permission==LocationPermission.whileInUse){
        double distanceInMeters = Geolocator.distanceBetween(startLatitude, startLongitude,endLatitude , endLongitude);
    if (kDebugMode) {
      print('******************** distance is here ! *****************  ');
      print('${distanceInMeters/1000} km' );
    }
     // positionStream = Geolocator.getPositionStream().listen(
     //        (Position? position) {
     //      print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
     //    });

  }
    return await Geolocator.getCurrentPosition();
  }
  @override
  void initState() {
    _determinePosition();
    super.initState();


  }

  // @override
  // void dispose(){
  //   if(positionStream!= null){
  //     positionStream!.cancel();
  //   }
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    return  Scaffold (
      appBar: AppBar(
        title: const Text('GoogleMap',
        style: TextStyle(
          color: Colors.white
        ),),
        backgroundColor: Colors.cyan,
      ),
      body: const Column(
        children: [
          Center(
            child: Text(
              'Google_Map'
            ),
          )
        ],
      ),
    );
  }
}
