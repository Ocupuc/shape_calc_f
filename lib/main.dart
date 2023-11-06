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
  final _sideAController = TextEditingController(); // Для стороны A прямоугольника
  final _sideBController = TextEditingController(); // Для стороны B прямоугольника
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

  // Метод для расчета параметров прямоугольника
  Future<void> _calculateRectangle() async {
    if (_formKey.currentState?.validate() ?? false) {
      final response = await http.post(
        Uri.parse('http://192.168.31.5:8080/api/figures/rectangle'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode({
          'sideA': double.tryParse(_sideAController.text),
          'sideB': double.tryParse(_sideBController.text),
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _calculationResult = Map<String, String>.from(json.decode(utf8.decode(response.bodyBytes)));
        });
      } else {
        throw Exception('Failed to calculate rectangle parameters');
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
        Locale('ru', 'RU'), // Русский язык
      ],
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Calculator of Geometric Figures'),
        ),
        body: Center(
          child: SingleChildScrollView( // Обернуть в SingleChildScrollView для скроллинга
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  DropdownButton<String>(
                    value: _selectedFigure,
                    hint: const Text('Выберите тип фигуры'),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedFigure = newValue;
                        _calculationResult.clear(); // Очистить результаты при смене фигуры
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
                          if (number <= 0.01) {
                            return 'Радиус должен быть больше 0.01';
                          }
                          if (number > 10000) {
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
                  ],
                  if (_selectedFigure == 'Прямоугольник') ...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _sideAController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Введите сторону A',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Пожалуйста, введите сторону A';
                          }
                          final number = double.tryParse(value);
                          if (number == null) {
                            return 'Введите корректное числовое значение';
                          }
                          if (number <= 0.01) {
                            return 'Сторона A должна быть больше 0.01';
                          }
                          if (number > 10000) {
                            return 'Сторона A должна быть меньше или равен 10000';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: _sideBController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Введите сторону B',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Пожалуйста, введите сторону B';
                          }
                          final number = double.tryParse(value);
                          if (number == null) {
                            return 'Введите корректное числовое значение';
                          }
                          if (number <= 0.01) {
                            return 'Сторона B должна быть больше 0.01';
                          }
                          if (number > 10000) {
                            return 'Сторона B должна быть меньше или равен 10000';
                          }
                          return null;
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _calculateRectangle,
                      child: const Text('Рассчитать'),
                    ),
                  ],
                  // Вывод результатов расчета
                  if (_calculationResult.isNotEmpty) ...[
                    Text('Периметр: ${_calculationResult['perimeter']}'),
                    Text('Площадь: ${_calculationResult['area']}'),
                    Text(_calculationResult['description'] ?? ''),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
