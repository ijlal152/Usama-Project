import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({Key? key}) : super(key: key);

  @override
  State<CurrentLocation> createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {

  String Address = 'search';

  final Completer<GoogleMapController> _controller = Completer();
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(33.5690628,72.6349776),
    zoom: 11, tilt: 60,
  );

  //List<Marker> _marker = [];
  final List<Marker> _marker =  <Marker>[
    const Marker(
        markerId: MarkerId('1'),
        position: LatLng(33.5651,73.0169),
        infoWindow: InfoWindow(
            title: 'Rawalpindi'
        )
    ),

  ];

  loadData () {
    getUserCurrentLocation().then((value) async{
      print('My current location: ');
      print("${value.latitude} ${value.longitude}");
      List<Placemark> placemarks = await placemarkFromCoordinates(value.latitude, value.longitude);
      print(placemarks);
      Placemark place = placemarks[0];
      Address = '${place.locality}, ${place.country}';
      var newlocality = '${place.locality}';
      var newcountry = '${place.country}';
      var newDistrict = '${place.subAdministrativeArea}';
      var newprovice = '${place.administrativeArea}';
      setState(() {
        print('$Address');
        print('Locality: ${place.locality}, District: ${newDistrict}, Province: ${newprovice} Country: ${place.country}');
      });



      _marker.add(
          Marker(
              markerId: MarkerId('2'),
              position: LatLng(value.latitude, value.longitude),
              infoWindow: InfoWindow(
                  title: 'My current location'
              )
          )
      );
      CameraPosition cameraPosition = CameraPosition(
        zoom: 14,
        target: LatLng(value.latitude, value.longitude),
      );
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState((){

      });
    }
    );
  }

  Future<Position> getUserCurrentLocation() async{
    await Geolocator.requestPermission().then((value){

    }).onError((error, stackTrace) {
      print('Error'+error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState(){
    super.initState();
    loadData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _kGooglePlex,
          markers: Set<Marker>.of(_marker),
          mapType: MapType.normal,
          myLocationEnabled: true,
          compassEnabled: true,
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          getUserCurrentLocation().then((value) async{
            print('My current location: ');
            print(value.latitude.toString()+" "+ value.longitude.toString());

            _marker.add(
                Marker(
                    markerId: MarkerId('2'),
                    position: LatLng(value.latitude, value.longitude),
                    infoWindow: InfoWindow(
                        title: 'My current location'
                    )
                )
            );
            CameraPosition cameraPosition = CameraPosition(
              zoom: 14,
              target: LatLng(value.latitude, value.longitude),
            );
            final GoogleMapController controller = await _controller.future;
            controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
            setState((){

            });
          }
          );
        },
        child: Icon(Icons.my_location),
      ),
    );
  }
}
