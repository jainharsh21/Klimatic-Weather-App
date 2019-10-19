import 'dart:convert';

import 'package:flutter/material.dart';
import '../util/utils.dart' as util;
import 'dart:async';
import 'package:http/http.dart' as http;

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {

  String _cityEntered;

  Future _goToNextScreen(BuildContext context) async{
    Map results= await Navigator.of(context).push(
      new MaterialPageRoute<Map>(builder: (BuildContext context){
        return new ChangeCity();
      }));

      if(results != null && results.containsKey('city'))
      {
        // print(results['city'].toString());
        _cityEntered = results['city'];
      }
  }

  @override
  Widget build(BuildContext context) {

    void showData() async{
      Map data= await getWeather(util.appId, util.defaultCity);
      print(data.toString());
    }
    
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Klimatic"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.menu),
            onPressed : (){_goToNextScreen(context);},
          )
        ],
      ),
    body: new Stack(
      children: <Widget>[
        new Center(
          child: new Image.asset('images/umbrella.png',
          height: 710.0,
          fit: BoxFit.fill,
          ),
        ),

        new Container(
          alignment: Alignment.topRight,
          margin: const EdgeInsets.fromLTRB(0.0, 11.0, 21.0, 0.0),
          child: new Text('${_cityEntered == null ? util.defaultCity : _cityEntered}',
          style: cityStyle()),
        ),

        new Container(
          alignment: Alignment.center,
          child: new Image.asset('images/light_rain.png'),
        ),

        //Container Containing Weather Data

        new Container(
          margin: const EdgeInsets.fromLTRB(30.0, 435.0, 0.0, 0.0),
          child: updateTemp('${_cityEntered == null ? util.defaultCity : _cityEntered}',
        )

        )],
    ),
    );
  }



  Future<Map> getWeather(String appId,String city) async {

    String apiUrl = "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util.appId}&units=metric";

    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);


  }

    Widget updateTemp(String city) {
      
      return new FutureBuilder(
        future: getWeather(util.appId, city == null ? util.defaultCity : city),
        builder: (BuildContext context,AsyncSnapshot<Map> snapshot){
        if(snapshot.hasData){
          Map content = snapshot.data;
          return new Container(
            child: new Column(
              children: <Widget>[
                new ListTile(
                  title: new Text("${content['main']['temp'].toString()}°C",
                  style: weatherTempStyle(),),
                  subtitle: new ListTile(
                    title: new Text(
                      "Humidity: ${content['main']['humidity'].toString()}\n"
                              "Min: ${content['main']['temp_min'].toString()}°C \n"
                              "Max: ${content['main']['temp_max'].toString()}°C ",
                              style: new TextStyle(
                                fontSize: 16.9,
                                color: Colors.white70,
                              ), 
                    ),
                    subtitle: new Text("Description : ${content['weather'][0]['description']}",
                    style: new TextStyle(
                                fontSize: 16.9,
                                color: Colors.white70,
                              ),),
                  ), 
                  
                ),
              ],
            ),
          );
        }
        else
        {
          return new Container();
        }
      });
    }


}

class ChangeCity extends StatelessWidget {

  var _cityFieldController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red,
        title: new Text("Change City"),
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
          child: new Image.asset('images/white_snow.png',
          height: 1200.0,
          width: 490.0,
          fit: BoxFit.fill,
          ),
        ),
        new ListView(
          children: <Widget>[
            new ListTile(
              title: new TextField(
                decoration: new InputDecoration(
                  hintText: 'Enter City'
                ),
                controller: _cityFieldController,
                keyboardType: TextInputType.text,
              ),
            ),
            new ListTile(
              title: new FlatButton(
                onPressed: (){
                  Navigator.pop(context,{
                    'city': _cityFieldController.text,
                  });
                },
                textColor: Colors.white70,
                child: new Text("Get Weather!"),
                color: Colors.redAccent,
              ),
            )
          ],
        )
        ],
      ),
    );
  }
}

TextStyle cityStyle(){
  return new TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontStyle: FontStyle.italic,
  );
}

TextStyle weatherTempStyle(){
  return new TextStyle(
    color: Colors.white,
    fontStyle: FontStyle.normal,
    fontSize: 49.9,
  );
}