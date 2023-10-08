import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'constants.dart' as k;
import 'dart:convert';

class Weather extends StatefulWidget {
  const Weather({super.key});

  @override
  State<Weather> createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  final TextEditingController _city = TextEditingController();
  bool isLoaded = false;
  num temp = 0;
  num press = 0;
  num hum = 0;
  num cover = 0;
  String cityname = '';

  updateUI(var decodedData) {
    setState(
      () {
        if (decodedData == null) {
          temp = 0;
          press = 0;
          hum = 0;
          cover = 0;
          cityname = 'Not available';
        } else {
          temp = decodedData['main']['temp'] - 273;
          press = decodedData['main']['pressure'];
          hum = decodedData['main']['humidity'];
          cover = decodedData['clouds']['all'];
          cityname = decodedData['name'];
        }
      },
    );
  }

  Future<void> getCityWeather(String cityname) async {
    var client = http.Client();
    var uri = '${k.domain}q=$cityname&appid=${k.apiKey}';
    var url = Uri.parse(uri);
    var response = await client.get(url);
    if (response.statusCode == 200) {
      var data = response.body;
      var decodeData = json.decode(data);
      updateUI(decodeData);
      setState(() {
        isLoaded = true;
      });
      debugPrint(data);
    } else {
      debugPrint(response.statusCode.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Weather App'),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _city,
                  decoration: InputDecoration(
                      icon: const Icon(
                        Icons.map,
                        color: Colors.deepOrangeAccent,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      labelText: 'Search city'),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              ElevatedButton(
                onPressed: () async {
                  await getCityWeather(_city.text);
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.deepOrangeAccent),
                ),
                child: const Text('Get Weather'),
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.pin_drop,
                      color: Colors.redAccent,
                      size: 40,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Text(
                      cityname,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.thermostat,
                      color: Colors.redAccent,
                      size: 30,
                    ),
                    Text(
                      '    Temperature: ${temp.toInt()}C',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, top: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.arrow_downward,
                      color: Colors.redAccent,
                      size: 30,
                    ),
                    Text(
                      '    Pressure: ${press.toInt()}hPa',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, top: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.water,
                      color: Colors.redAccent,
                      size: 30,
                    ),
                    Text(
                      '    Humidity: ${hum.toInt()}%',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, top: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.cloud,
                      color: Colors.redAccent,
                      size: 30,
                    ),
                    Text(
                      '    Cloud cover: ${cover.toInt()}%',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
