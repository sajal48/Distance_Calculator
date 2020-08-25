




import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

TextStyle t = new TextStyle(
  fontSize: 20,

);
ScreenshotController ss = ScreenshotController();
File _ScrennShot;


class Book extends StatelessWidget {
  String Name,Src,Des,Dis,Fare;
  Book({
    Key key,
    @required this.Name,
    @required this.Src,
    @required this.Des,
    @required this.Dis,
    @required this.Fare,

  }) : super(key: key);

  Future<String>get localPath async{
    final myDir= await getExternalStorageDirectory();
    return myDir.path;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async=>true,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Booked"),
          centerTitle: true,
          backgroundColor: Colors.deepOrangeAccent,
        ),
        body: Container(
          color: Colors.orangeAccent,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Screenshot(
                  controller:ss ,
                  child: Container(
                    color: Colors.orangeAccent,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                          child: Text("Name: "+"$Name",style: t,),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                          child: Text("From: "+"$Src",style: t,),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                          child: Text("To: "+"$Des",style: t,),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                          child: Text("Total Distance : "+"$Dis "+ "km",style: t,),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                          child: Text("Fare: "+"$Fare",style: t,),
                        ),
                      ],
                    ),
                  ),
                ),

                Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: RaisedButton(child: Text("Save"),
                        onPressed: () async{


                      try
                          {
                            final dir = await localPath;
                            final path = '$dir/'+'${DateTime.now()}.jpg';
                            ss.capture(path: path);
                            Navigator.pop(context);
                          }
                          catch(e)
                          {
                            print(e);
                          }


                    })),





              ],
            ),
          ),
        ),
      ),
    );
  }


}
