import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // final Completer<GoogleMapController> _controller =
  // Completer<GoogleMapController>();
GoogleMapController? gmController;
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(31.037933, 31.381523),
    zoom: 14.4746,
  );

  double lt=0;
  double ld=0;

  List<Marker> marks=[
    // const Marker(markerId: MarkerId("1"),
    // position: LatLng(31.037933, 31.381523)
    // ),
    // //  Marker(markerId: MarkerId("2"),
    // //     position: LatLng(lt, ld)
    // // )
  ];
StreamSubscription<Position>? positionStream;
  initalStream() async{
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
      positionStream  = Geolocator.getPositionStream().listen(
              (Position? position) {
                marks.add(Marker(markerId: const MarkerId('1'),
                    position: LatLng(position!.latitude,position.longitude)
                ));
                gmController!.animateCamera(CameraUpdate.newLatLng(
                  LatLng(position.latitude,position.longitude)
                ));
                setState(() {

                });
               });
      // double distanceInMeters =
      // Geolocator.distanceBetween(startLatitude, startLongitude,endLatitude , endLongitude);
      // if (kDebugMode) {
      //   print('******************** distance is here ! *****************  ');
      //   print('${positionStream/1000} km' );
      // }
      // positionStream = Geolocator.getPositionStream().listen(
      //        (Position? position) {
      //      print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
      //    });

    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    initalStream();
    super.initState();
  }
  @override
  void dispose() {
  positionStream!.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Google Map',
          style: TextStyle(
            color: Colors.white
          ),

        ),
      ),
      body:  Container(
        height: double.infinity,
        child: GoogleMap(
          onTap: (LatLng latLng) async{
            List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

           print(placemarks[0].country);
           print(placemarks[0].street);
           print(placemarks[0].postalCode);
           print(placemarks[0].administrativeArea);
           print(placemarks[0].isoCountryCode);
            // print('${latLng.longitude  } , ${latLng.latitude}');
            //
            // marks.add(Marker(markerId: const MarkerId('1'),
            //   position: LatLng(latLng.latitude,latLng.longitude)
            // ));
            // setState(() {
            //
            // });
          },
          markers: marks.toSet(),
          mapType: MapType.normal,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (mapController) {
            gmController = mapController;
          },
        ),
      ),
    );
  }
}
