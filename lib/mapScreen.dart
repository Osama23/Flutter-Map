import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import './place.dart';

class MapScreen extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isSelecting;

  MapScreen({
    this.initialLocation =
        const PlaceLocation(latitude: 37.422, longitude: -122.084),
    this.isSelecting = false,
  });

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Set<Marker> markers = Set();
  Position position;

  setMarkers() {
    markers.addAll([
      Marker(
        markerId: MarkerId('value'),
        position: LatLng(
          widget.initialLocation.latitude,
          widget.initialLocation.longitude,
        ),
        infoWindow: InfoWindow(
          // title is the address
          title: 'Osama',// address.addressLine,
          // snippet are the coordinates of the position
          // snippet:
          //     'Lat: ${address.coordinates.latitude}, Lng: ${address.coordinates.longitude}',
        ),
      )
    ]);
  }

  @override
  void initState() {
    super.initState();
    setMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Map'),
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
          zoom: 14,
        ),
        markers: markers,
      ),
    );
  }
}
