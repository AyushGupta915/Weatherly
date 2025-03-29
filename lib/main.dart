import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:Weatherly/services/weather_services.dart';
import 'package:Weatherly/widget/weather_data_tile.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _controller = TextEditingController();
  final WeatherService _weatherService = WeatherService();
  
  String _bgImg = 'assets/images/clear.jpg';
  String _iconImg = 'assets/icons/Clear.png';
  String _cityName = 'Loading...';
  String _temperature = '--';
  String _tempMax = '--';
  String _tempMin = '--';
  String _sunrise = '--';
  String _sunset = '--';
  String _main = '--';
  String _pressure = '--';
  String _humidity = '--';
  String _visibility = '--';
  String _windSpeed = '--';
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData({String cityName = ''}) async {
    setState(() => _errorMessage = '');

    try {
      Map<String, dynamic> weatherData = cityName.isEmpty
          ? await _weatherService.fetchWeather()
          : await _weatherService.getWeather(cityName);

      if (weatherData.containsKey("error")) {
        setState(() => _errorMessage = weatherData["error"]);
        return;
      }

      setState(() {
        _cityName = weatherData['name'];
        _temperature = weatherData['main']['temp'].toStringAsFixed(1);
        _main = weatherData['weather'][0]['main'];
        _tempMax = weatherData['main']['temp_max'].toStringAsFixed(1);
        _tempMin = weatherData['main']['temp_min'].toStringAsFixed(1);
        _sunrise = DateFormat('hh:mm a').format(
            DateTime.fromMillisecondsSinceEpoch(
                weatherData['sys']['sunrise'] * 1000));
        _sunset = DateFormat('hh:mm a').format(
            DateTime.fromMillisecondsSinceEpoch(
                weatherData['sys']['sunset'] * 1000));
        _pressure = weatherData['main']['pressure'].toString();
        _humidity = weatherData['main']['humidity'].toString();
        _visibility = (weatherData['visibility'] / 1000).toStringAsFixed(1) + ' km';
        _windSpeed = weatherData['wind']['speed'].toString() + ' m/s';

        _updateWeatherTheme();
      });
    } catch (e) {
      setState(() => _errorMessage = "Failed to fetch weather data.");
    }
  }

  void _updateWeatherTheme() {
    final Map<String, String> weatherImages = {
      'Clear': 'clear.jpg',
      'Clouds': 'clouds.jpg',
      'Rain': 'rain.jpg',
      'Fog': 'fog.jpg',
      'Thunderstorm': 'thunderstorm.jpg',
      'Haze': 'haze.jpg'
    };

    final Map<String, String> weatherIcons = {
      'Clear': 'Clear.png',
      'Clouds': 'Clouds.png',
      'Rain': 'Rain.png',
      'Fog': 'Haze 2.png',
      'Thunderstorm': 'Thunderstorm.png',
      'Haze': 'Haze.png'
    };

    _bgImg = 'assets/images/${weatherImages[_main] ?? 'clear.jpg'}';
    _iconImg = 'assets/icons/${weatherIcons[_main] ?? 'Clear.png'}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            _bgImg,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  TextField(
                    controller: _controller,
                    onSubmitted: (value) {
                      if (value.isNotEmpty) _fetchWeatherData(cityName: value);
                    },
                    decoration: const InputDecoration(
                      suffixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.black26,
                      hintText: 'Enter city name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on, color: Colors.white),
                      Text(
                        _cityName,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  Center(
                    child: Text(
                      '$_temperature°c',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 90,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _main,
                        style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w500, color: Colors.black),
                      ),
                      const SizedBox(width: 10),
                      Image.asset(_iconImg, height: 80),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.arrow_upward, color: Colors.white),
                      Text('$_tempMax°c',
                          style: const TextStyle(fontSize: 22, fontStyle: FontStyle.italic, color: Colors.black)),
                      const SizedBox(width: 10),
                      const Icon(Icons.arrow_downward, color: Colors.white),
                      Text('$_tempMin°c',
                          style: const TextStyle(fontSize: 22, fontStyle: FontStyle.italic, color: Colors.black),
                  ),],
                  ),
                  const SizedBox(height: 25),
                  if (_errorMessage.isNotEmpty)
                    Center(
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                    ),
                  if (_errorMessage.isEmpty)
                    const SizedBox(
                  height: 25,
                ),
                Card(
                  elevation: 5,
                  color: Colors.transparent,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        WeatherDataTile(
                            index1: "Sunrise",
                            index2: "Sunset",
                            value1: _sunrise,
                            value2: _sunset),
                        SizedBox(
                          height: 15,
                        ),
                        WeatherDataTile(
                            index1: "Humidity",
                            index2: "Visibility",
                            value1: _humidity,
                            value2: _visibility),
                        SizedBox(
                          height: 15,
                        ),
                        WeatherDataTile(
                            index1: "Presure",
                            index2: "Wind speed",
                            value1: _pressure,
                            value2: _windSpeed),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
