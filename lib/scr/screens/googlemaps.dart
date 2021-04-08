import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:food_course/scr/providers/user.dart';
import 'package:food_course/scr/screens/home.dart';
import 'package:google_map_location_picker/generated/l10n.dart' as location_picker;
import 'package:google_map_location_picker/generated/l10n.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';





class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {



  LocationResult _pickedLocation;
  Future getlocation()async{
    LocationResult result = await showLocationPicker(
      context,
      "AIzaSyArXRbJUUGeEqiIofoIIfafr8vJR_nENvs",
      initialCenter: LatLng(31.1975844, 29.9598339),
//                      automaticallyAnimateToCurrentLocation: true,
//                      mapStylePath: 'assets/mapStyle.json',
      myLocationButtonEnabled: true,
      // requiredGPS: true,
      layersButtonEnabled: true,
      // countries: ['AE', 'NG']

//                      resultCardAlignment: Alignment.bottomCenter,
      desiredAccuracy: LocationAccuracy.best,
    );
    // print("result = $result");
    print(_pickedLocation.toString());
    setState(() => _pickedLocation = result);

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return(MaterialApp(
      //theme: ThemeData.dark(),
        title: 'location picker',
        localizationsDelegates: const [
          location_picker.S.delegate,
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const <Locale>[
          Locale('en', ''),
          Locale('ar', ''),
          Locale('pt', ''),
          Locale('tr', ''),
          Locale('es', ''),
          Locale('it', ''),
          Locale('ru', ''),
        ],
        home:Scaffold(
          appBar: AppBar(
            title: const Text('location picker'),
          ),
          body: Builder(builder: (context) {
            final provider = Provider.of<UserProvider>(context);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () async {
                      LocationResult result = await showLocationPicker(
                        context,
                        "AIzaSyArXRbJUUGeEqiIofoIIfafr8vJR_nENvs",
                        initialCenter: LatLng(31.1975844, 29.9598339),
//                      automaticallyAnimateToCurrentLocation: true,
//                      mapStylePath: 'assets/mapStyle.json',
                        myLocationButtonEnabled: true,
                        // requiredGPS: true,
                        layersButtonEnabled: true,
                        // countries: ['AE', 'NG']

//                      resultCardAlignment: Alignment.bottomCenter,
                        desiredAccuracy: LocationAccuracy.best,
                      );
                      // print("result = $result");
                      print(_pickedLocation.toString());
                      setState(() => _pickedLocation = result);
                    },
                    child: Text('Pick location'),
                  ),
                  Text(_pickedLocation.toString()),
                  FloatingActionButton(
                    onPressed: (){

                      provider.addLocation(userid: provider.user.uid,location: _pickedLocation.address.toString().substring(0,15));
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>Home(
                        location: _pickedLocation.address.toString().substring(0,9),

                      )));
                    },
                  )
                ],
              ),
            );
          }),

        )));
  }
}
