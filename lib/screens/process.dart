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
      final Map<String, dynamic> data = document.data();
      final double latitude = data['latitude'] ?? 0.0;
      final double longitude = data['longitude'] ?? 0.0;
      final String username = data['Username'] ?? '';
      final String mobileNumber = data['Mobile Number'] ?? '';

      if (latitude != 0.0 && longitude != 0.0) {
        setState(() {
          markers.add(
            Marker(
              markerId: MarkerId(document.id),
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

  Future<void> setupUserLocation() async {
    LocationData locationData = await location.getLocation();
    setState(() {
      userLocationMarker = Marker(
        markerId: MarkerId('user_location'),
        position:
            LatLng(locationData.latitude ?? 0.0, locationData.longitude ?? 0.0),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue), // Blue marker
        infoWindow: InfoWindow(
          title: 'Your Location',
        ),
      );
    });
  }

  Future<void> fetchEmployeeInformation(
      String employeeEmail, String username) async {
    // Fetch ratings for the employee using the employee email
    final DocumentSnapshot<Map<String, dynamic>> ratingsSnapshot =
        await FirebaseFirestore.instance
            .collection('ratings')
            .doc(employeeEmail)
            .get();

    if (ratingsSnapshot.exists) {
      final Map<String, dynamic> ratingsData = ratingsSnapshot.data()!;

      // Retrieve the 'Ratings' field from the ratingsData
      final List<dynamic> ratingValues = ratingsData['Ratings'] ?? [];

      if (ratingValues.isNotEmpty) {
        double totalRating = 0;

        // Calculate the total rating
        for (var ratingValue in ratingValues) {
          totalRating += ratingValue.toDouble();
        }

        // Calculate the mean rating
        double meanRating = totalRating / ratingValues.length;

        setState(() {
          this.meanRating = meanRating;
        });

        print('Employee Username: $username');
        print('Mean Rating: $meanRating');
      } else {
        setState(() {
          meanRating = 0.0; // No ratings found
        });

        print('Employee Username: $username');
        print('No Ratings Found');
      }
    } else {
      setState(() {
        meanRating = 0.0; // Employee not found in 'ratings'
      });

      print('Employee Email not found: $employeeEmail');
    }

    print('Username: $username');
    print('Employee Email: $employeeEmail');
  }

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
                      fetchEmployeeInformation(
                          marker.markerId.value, marker.infoWindow.title!);
                      toggleTabBarVisibility();
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
