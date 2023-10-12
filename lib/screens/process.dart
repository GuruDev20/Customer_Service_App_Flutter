import 'package:customer_service_app_flutter/payment/payment.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class ProcessScreen extends StatefulWidget {
  static const String id = "ProcessScreen";
  final String text;
  ProcessScreen({required this.text});

  @override
  State<ProcessScreen> createState() => _ProcessScreenState();
}

class _ProcessScreenState extends State<ProcessScreen> {
  String selectedEmployeeEmail = "";
  GoogleMapController? mapController;
  Set<Marker> markers = Set<Marker>();
  LatLng initialCameraPosition = LatLng(0.0, 0.0);
  bool isTabBarVisible = false;

  Location location = Location();
  Marker? userLocationMarker;

  double meanRating = 0.0; // Variable to store the mean rating

  @override
  void initState() {
    super.initState();
    fetchEmployeeLocations();
    setupUserLocation();
  }

  void toggleTabBarVisibility() {
    setState(() {
      isTabBarVisible = !isTabBarVisible;
    });
  }

  void fetchEmployeeLocations() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('employeeDetails')
        .where('Type', isEqualTo: 'employee')
        .where('profession', isEqualTo: widget.text)
        .get();
    markers.clear();
    for (QueryDocumentSnapshot<Map<String, dynamic>> document
        in querySnapshot.docs) {
      final double latitude = document['latitude'] ?? 0.0;
      final double longitude = document['longitude'] ?? 0.0;
      final String username = document['Username'] ?? '';
      final String mobileNumber = document['Mobile Number'] ?? '';
      final String employeeEmail = document.id; // Use the document ID as email
      setState(() {
        selectedEmployeeEmail = employeeEmail;
      });
      if (latitude != 0.0 && longitude != 0.0) {
        setState(() {
          markers.add(
            Marker(
              markerId: MarkerId(employeeEmail),
              position: LatLng(latitude, longitude),
              infoWindow: InfoWindow(
                title: username,
                snippet: mobileNumber,
              ),
            ),
          );
        });
      }
    }
    if (markers.isNotEmpty && mapController != null) {
      initialCameraPosition = markers.first.position;
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(initialCameraPosition, 10),
      );
    }
  }

  // Add this method to handle marker tap
  void handleMarkerTap(Marker marker) {
    fetchEmployeeInformation(marker.markerId.value, marker.infoWindow.title!);
    toggleTabBarVisibility();
  }

  Future<void> setupUserLocation() async {
    LocationData locationData = await location.getLocation();
    setState(() {
      userLocationMarker = Marker(
        markerId: MarkerId('user_location'),
        position:
            LatLng(locationData.latitude ?? 0.0, locationData.longitude ?? 0.0),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueBlue, // Blue marker
        ),
        infoWindow: InfoWindow(
          title: 'Your Location',
        ),
      );
    });
  }

  Future<void> fetchEmployeeInformation(
      String employeeEmail, String username) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Color.fromARGB(255, 15, 17, 42),
              width: double.infinity,
              height: 70,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, right: 10),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Container(
                          height: 50,
                          width: 340,
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 120, top: 9),
                              child: Text(
                                widget.text,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GoogleMap(
                onMapCreated: (controller) {
                  setState(() {
                    mapController = controller;
                  });
                },
                markers: {
                  ...markers,
                  if (userLocationMarker != null) userLocationMarker!
                },
                initialCameraPosition: CameraPosition(
                  target: initialCameraPosition,
                  zoom: 15,
                ),
                onTap: (LatLng latLng) {
                  // Handle marker tap event here
                  for (Marker marker in markers) {
                    if (marker.infoWindow.snippet == latLng.toString()) {
                      handleMarkerTap(
                          marker); // Call the method to handle the tap
                      break;
                    }
                  }
                },
              ),
            ),
            if (isTabBarVisible)
              DefaultTabController(
                length: 2,
                child: Expanded(
                  child: Column(
                    children: [
                      TabBar(
                        tabs: [
                          Tab(text: 'Employees'),
                          Tab(text: 'Reviews'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            ListView.builder(
                              itemCount: markers.length,
                              itemBuilder: (context, index) {
                                final marker = markers.elementAt(index);
                                return TextButton(
                                  child: ListTile(
                                    title: Text(marker.infoWindow.title ?? ''),
                                    subtitle: Text(
                                      'Mobile: ${marker.infoWindow.snippet}',
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PaymentScreen(
                                          username:
                                              marker.infoWindow.title ?? '',
                                          mobileNumber:
                                              marker.infoWindow.snippet ?? '',
                                          serviceName: widget.text,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            Center(
                              child: Text('Reviews will be displayed here.'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            isTabBarVisible ? Colors.white : Color.fromARGB(255, 15, 17, 42),
        onPressed: () {
          toggleTabBarVisibility();
        },
        child: Icon(
          isTabBarVisible ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          color:
              isTabBarVisible ? Color.fromARGB(255, 15, 17, 42) : Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
