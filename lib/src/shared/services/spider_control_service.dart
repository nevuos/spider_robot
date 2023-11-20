import 'dart:async';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../utils/exceptions.dart';

class SpiderControlService {
  final String baseUrl;

  SpiderControlService()
      : baseUrl = dotenv.env['BASE_URL'] ?? 'http://192.168.17.118';

Future<http.Response> sendCommand(String commandPath) async {
  final url = Uri.parse('$baseUrl/$commandPath');
  try {
    var response = await http.get(url).timeout(const Duration(seconds: 5));
    
    if (response.statusCode == 200) {
      return response;
    } else {
      throw SpiderServiceException('Erro ao enviar comando: ${response.body}');
    }
  } on SocketException catch (e) {
    throw SpiderServiceException('Erro de conexão: $e');
  } on TimeoutException catch (e) {
    throw SpiderServiceException('Tempo limite de requisição excedido: $e');
  } catch (e) {
    throw SpiderServiceException('Erro desconhecido: $e');
  }
}


  Future<void> sendJoystickData(double x, double y) async {
    String commandPath = "joystick/x/$x/y/$y";
    try {
      await sendCommand(commandPath);
    } catch (e) {
      throw SpiderServiceException('Erro ao enviar dados do joystick: $e');
    }
  }

  Future<void> sendButtonCommand(String name) async {
    String commandPath = "button/$name";
    try {
      await sendCommand(commandPath);
    } catch (e) {
      throw SpiderServiceException('Erro ao enviar comando do botão: $e');
    }
  }
  
}
