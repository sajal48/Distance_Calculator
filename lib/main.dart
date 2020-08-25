import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:battery/battery.dart';
import 'package:lpucab/Booked.dart';


void main() {
  runApp(MyApp());
}
String Name,Source,Destination,Distance,Fare;
final _formKey = GlobalKey<FormState>();
final _t2 = new TextEditingController();
final _t1 = new TextEditingController();
final _t3 = new TextEditingController();
final _t4 = new TextEditingController();

Location _location;
LocationData _mylocation;
bool loading=false;
String fare ="0";
var battery = Battery();

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: <String,WidgetBuilder>{
        '/':(context)=> HomePage(),
        '/book': (context)=>Book(Name: Name, Src: Source, Des: Destination, Dis: Distance, Fare: Fare),

      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    _location = new Location();
    return Scaffold(
      appBar: AppBar(
        title: Text("LPUCAB"),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Stack(
        children:[ Container(
          child: SingleChildScrollView(
            child: Column(children: [
              new Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 10, 40, 5),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _t1,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter Name';
                          }
                          return null;
                        },
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          icon: Icon(Icons.portrait),
                          hintText: "Name",
                        ),
                      ),
                      TextFormField(
                        controller: _t2,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          icon: Icon(Icons.my_location),
                          hintText: "Source",
                        ),
                      ),
                      TextFormField(
                        controller: _t3,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter destination';
                          }
                          return null;
                        },
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          icon: Icon(Icons.location_searching),
                          hintText: "Destinatino",
                        ),
                      ),
                      TextFormField(
                        controller: _t4,

                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                            icon: Icon(Icons.directions_transit),
                            hintText: "No. of KM"),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child: RaisedButton(
                      child: Text("Calculate fare"),
                      onPressed: () async {
                        setState(() {
                          loading=true;
                        });
                        if (_formKey.currentState.validate()) {
                          // Process data.
                        }
                        print("validating");
                        _mylocation = await _location.getLocation();
                        try {
                          List<Placemark> placemark = await Geolocator()
                              .placemarkFromCoordinates(
                                  _mylocation.latitude, _mylocation.longitude);
                          var ld = await Geocoder.local.findAddressesFromQuery(_t3.text);
                          var first = ld.first;
                          double distance = await Geolocator().distanceBetween(_mylocation.latitude, _mylocation.longitude, first.coordinates.latitude, first.coordinates.longitude);
                          int km = (distance/1000).round();
                          int b= await battery.batteryLevel;
                          int cost = 8*km*(7.061-.06*b).round();





                          setState(() {
                            _t2.text = placemark[0].locality;
                            _t4.text= km.toString();
                            fare= cost.toString();
                            loading=false;
                            Source=placemark[0].locality;
                            Destination=_t3.text;
                            Distance= km.toString();
                            Fare=cost.toString();


                          });
                        } catch (e) {
                          print(e);
                        }
                      })),
              Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: RaisedButton(child: Text("Book"), onPressed: () {
                    Name = _t1.text;
                    Navigator.pushNamed(context, '/book');


                  })),


              Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child:Text("Fare = $fare",style: TextStyle(fontSize: 20),),),

            ]),
          ),
        ),

          loading?
          Container(

            color: Colors.orangeAccent,
            height: double.infinity,
            width: double.infinity,
            child: Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            ),
          ):
              Container()
        ],



      ),
    );
  }
}
