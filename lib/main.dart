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
  final _formKey = GlobalKey<FormState>(); // Ключ для Form
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
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
    );

    if (response.statusCode == 200) {
      setState(() {
        _figureTypes = List<String>.from(json.decode(utf8.decode(response.bodyBytes)));
      });
    } else {
      throw Exception('Failed to load figure types');
    }
  }

  Future<void> _calculateCircle() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Если форма валидна, отправляем запрос
      final response = await http.post(
        Uri.parse('http://192.168.31.5:8080/api/figures/circle'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({'radius': double.tryParse(_radiusController.text)}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _calculationResult = Map<String, String>.from(json.decode(utf8.decode(response.bodyBytes)));
        });
      } else {
        throw Exception('Failed to calculate circle parameters');
      }
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
        Locale('ru', 'RU'),
      ],
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Calculator of Geometric Figures'),
        ),
        body: Center(
          child: Form(
            key: _formKey, // Присваиваем ключ Form
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
                    child: TextFormField(
                      controller: _radiusController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Введите радиус круга',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста, введите радиус';
                        }
                        final number = double.tryParse(value);
                        if (number == null) {
                          return 'Введите корректное числовое значение';
                        }
                        if (number <= 0.01) { // Минимальное значение
                          return 'Радиус должен быть больше 0.01';
                        }
                        if (number > 10000) { // Максимальное значение
                          return 'Радиус должен быть меньше или равен 10000';
                        }
                        return null;
                      },

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
                // Добавьте виджеты для других фигур здесь
              ],
            ),
          ),
        ),
      ),
    );
  }
}
