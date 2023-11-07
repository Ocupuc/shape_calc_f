import 'package:flutter/material.dart';
import 'api_service.dart';

class RectangleForm extends StatefulWidget {
  final ApiService apiService;

  const RectangleForm({Key? key, required this.apiService}) : super(key: key);

  @override
  _RectangleFormState createState() => _RectangleFormState();
}

class _RectangleFormState extends State<RectangleForm> {
  final _sideAController = TextEditingController();
  final _sideBController = TextEditingController();
  Map<String, dynamic> _calculationResult = {};

  Future<void> _calculateRectangle() async {
    final sideA = double.tryParse(_sideAController.text);
    final sideB = double.tryParse(_sideBController.text);
    if (sideA != null && sideB != null) {
      try {
        var result = await widget.apiService.calculateRectangle(sideA, sideB);
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
