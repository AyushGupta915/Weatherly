import 'package:flutter/material.dart';

class WeatherDataTile extends StatelessWidget {
  final String index1, index2, value1, value2;

  const WeatherDataTile({
    super.key,
    required this.index1,
    required this.index2,
    required this.value1,
    required this.value2,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                index1,
                style: const TextStyle(
                    fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                value1,
                style: const TextStyle(
                    fontSize: 18, color: Colors.white, fontWeight: FontWeight.w300),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                index2,
                style: const TextStyle(
                    fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                value2,
                style: const TextStyle(
                    fontSize: 18, color: Colors.white, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
