import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:FlutterMap/credentials.dart';
import 'package:geocoder/geocoder.dart';

class OsamaMap extends StatefulWidget {
  @override
  _OsamaMapState createState() => _OsamaMapState();
}

class _OsamaMapState extends State<OsamaMap> {
  GoogleMapController _controller;
  PageController _pageController;
  Position position;
  int prevPage;
  Set<Marker> markers = Set();
  List<Marker> allMarkers = [];
  final places = new GoogleMapsPlaces(apiKey: "<API_KEY>");
  TextEditingController _searchController = new TextEditingController();
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: API_KEY);
  ///////////////////////
  Future<void> predict() async {
    Prediction prediction = await PlacesAutocomplete.show(
        context: context,
        apiKey: API_KEY,
        mode: Mode.fullscreen, // Mode.overlay
        language: "en",
        components: [Component(Component.country, "pk")]);

    _getLatLng(prediction);
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);

      var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      var address = await Geocoder.local.findAddressesFromQuery(p.description);

      print(lat);
      print(lng);
    }
  }

  void _getLatLng(Prediction prediction) async {
    GoogleMapsPlaces _places =
        new GoogleMapsPlaces(apiKey: API_KEY); //Same API_KEY as above
    PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(prediction.placeId);
    double latitude = detail.result.geometry.location.lat;
    double longitude = detail.result.geometry.location.lng;
    String address = prediction.description;
    print('########### $latitude $longitude $address');
  }

  ////////////////////////////
  getUserLocation() async {
    position = await getLocation();
    print('######### your position is $position');
    setState(() {
      markers.clear();
      markers.add(Marker(
        // draggable: false,
        infoWindow: InfoWindow(title: 'Osma'),
        markerId: MarkerId('osama'),
        position: LatLng(position.latitude, position.longitude),
        //  draggable: true,
        //  onDragEnd: (dragEndPosition){},
      ));
    });
    moveCamera();
  }

  Future<Position> getLocation() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  moveCamera() {
    print('########## move Camera');
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14.0,
        bearing: 45.0,
        tilt: 45.0)));
  }

  setUpMarker() {
    markers.add(Marker(
      markerId: MarkerId('value'),
      position: LatLng(40.7128, -74.0060),
    ));
  }

  @override
  void initState() {
    super.initState();
    setUpMarker();
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Osama Map')),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 50,
              child: TextFormField(
                controller: _searchController,
                onChanged: (_) async {
                  // show input autocomplete with selected mode
                  // then get the Prediction selected
                  Prediction p = await PlacesAutocomplete.show(
                      context: context, apiKey: API_KEY);
                  displayPrediction(p);
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[200],
                  isDense: true,
                  hintText: 'Search', // localization.translate('search'),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(25.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(40.7128, -74.0060),
                        zoom: 15,
                      ),
                      markers: markers,
                      onMapCreated: mapCreated,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FlatButton(
                color: Colors.green,
                onPressed: () {
                  print('###############');
                  getUserLocation();
                },
                child: Text('Share Your Location'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }
}
