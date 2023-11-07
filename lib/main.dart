import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shape_calc_f/parallelogram_form.dart';
import 'package:shape_calc_f/rhombus_form.dart';
import 'package:shape_calc_f/square_form.dart';
import 'package:shape_calc_f/trapezoid_form.dart';
import 'package:shape_calc_f/triangle_form.dart';
import 'circle_form.dart';
import 'rectangle_form.dart';
import 'api_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<String> _figureTypes = [];
  String? _selectedFigure;
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _getFigureTypes();
  }

  Future<void> _getFigureTypes() async {
    try {
      var types = await _apiService.getFigureTypes();
      setState(() {
        _figureTypes = types;
      });
    } catch (e) {
      // Обработка исключения
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
          child: SingleChildScrollView(
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
                      });
                    },
                    items: _figureTypes.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  if (_selectedFigure == 'Круг')
                    CircleForm(apiService: _apiService),
                  if (_selectedFigure == 'Прямоугольник')
                    RectangleForm(apiService: _apiService),
                  if (_selectedFigure == 'Квадрат')
                    SquareForm(apiService: _apiService),
                  if (_selectedFigure == 'Параллелограмм')
                    ParallelogramForm(apiService: _apiService),
                  if (_selectedFigure == 'Ромб')
                    RhombusForm(apiService: _apiService),
                  if (_selectedFigure == 'Трапеция')
                    TrapezoidForm(apiService: _apiService),
                  if (_selectedFigure == 'Треугольник')
                    TriangleForm(apiService: _apiService),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
