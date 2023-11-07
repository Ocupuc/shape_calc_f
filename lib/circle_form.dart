
import 'package:flutter/material.dart';
import 'api_service.dart';

class CircleForm extends StatefulWidget {
  final ApiService apiService;

  const CircleForm({Key? key, required this.apiService}) : super(key: key);

  @override
  _CircleFormState createState() => _CircleFormState();
}

class _CircleFormState extends State<CircleForm> {
  final _radiusController = TextEditingController();
  Map<String, dynamic> _calculationResult = {};

  Future<void> _calculateCircle() async {
    final radius = double.tryParse(_radiusController.text);
    if (radius != null) {
      try {
        var result = await widget.apiService.calculateCircle(radius);
        setState(() {
          _calculationResult = result;
        });
      } catch (e) {
        // Обработка исключения
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
        // Вывод результатов расчета
        if (_calculationResult.isNotEmpty) ...[
          Text('Периметр: ${_calculationResult['perimeter']}'),
          Text('Площадь: ${_calculationResult['area']}'),
          Text(_calculationResult['description'] ?? ''),
        ]
      ],
    );
  }
}
