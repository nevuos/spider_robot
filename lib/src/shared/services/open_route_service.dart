import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../utils/exceptions.dart';


class OpenRouteService {
  final apiKey = dotenv.env['API_KEY']!;

  Future<List<LatLng>> getRouteCoordinates(LatLng l1, LatLng l2) async {
    final url =
        'https://api.openrouteservice.org/v2/directions/driving-car?start=${l1.longitude},${l1.latitude}&end=${l2.longitude},${l2.latitude}';
    final headers = {"Authorization": apiKey};
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final coords = data['features'][0]['geometry']['coordinates'] as List;
      return coords.map((c) => LatLng(c[1], c[0])).toList();
    } else {
      throw APIException('Error fetching directions: ${response.body}');
    }
  }
}
