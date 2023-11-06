import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> _figureTypes = [];
  String? _selectedFigure;
  final _radiusController = TextEditingController();
  Map<String, String> _calculationResult = {};

  @override
  void initState() {
    super.initState();
    _getFigureTypes();
  }

  Future<void> _getFigureTypes() async {
    final response = await http.get(
      Uri.parse('http://192.168.31.5:8080/api/figure-types'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'}, // Указание кодировки
    );

    if (response.statusCode == 200) {
      setState(() {
        _figureTypes = List<String>.from(json.decode(utf8.decode(response.bodyBytes))); // Декодирование тела ответа с правильной кодировкой
      });
    } else {
      throw Exception('Failed to load figure types');
    }
  }

  Future<void> _calculateCircle() async {
    final response = await http.post(
      Uri.parse('http://192.168.31.5:8080/api/figures/circle'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'}, // Указание кодировки
      body: json.encode({'radius': double.tryParse(_radiusController.text)}),
    );

    if (response.statusCode == 200) {
      setState(() {
        _calculationResult = Map<String, String>.from(json.decode(utf8.decode(response.bodyBytes))); // Декодирование тела ответа с правильной кодировкой
      });
    } else {
      throw Exception('Failed to calculate circle parameters');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru', 'RU'), // Русский язык
        // Другие поддерживаемые языки
      ],
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Calculator of Geometric Figures'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              DropdownButton<String>(
                value: _selectedFigure,
                hint: const Text('Выберите тип фигуры'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFigure = newValue;
                  });
                },
                items: _figureTypes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              if (_selectedFigure == 'Круг') ...[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _radiusController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Введите радиус круга',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _calculateCircle,
                  child: const Text('Рассчитать'),
                ),
                if (_calculationResult.isNotEmpty) ...[
                  Text('Периметр: ${_calculationResult['perimeter']}'),
                  Text('Площадь: ${_calculationResult['area']}'),
                  Text(_calculationResult['description'] ?? ''),
                ]
              ],
              //
            ],
          ),
        ),
      ),
    );
  }
}
