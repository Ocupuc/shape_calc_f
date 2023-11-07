import 'package:flutter/material.dart';
import 'api_service.dart';

class SquareForm extends StatefulWidget {
  final ApiService apiService;

  const SquareForm({Key? key, required this.apiService}) : super(key: key);

  @override
  _SquareFormState createState() => _SquareFormState();
}

class _SquareFormState extends State<SquareForm> {
  final _sideController = TextEditingController();
  Map<String, dynamic> _calculationResult = {};

  Future<void> _calculateSquare() async {
    final side = double.tryParse(_sideController.text);
    if (side != null) {
      try {
        var result = await widget.apiService.calculateSquare(side);
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
            controller: _sideController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Введите длину стороны квадрата',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Пожалуйста, введите длину стороны';
              }
              final number = double.tryParse(value);
              if (number == null) {
                return 'Введите корректное числовое значение';
              }
              if (number <= 0.01) {
                return 'Длина стороны должна быть больше 0.01';
              }
              return null;
            },
          ),
        ),
        ElevatedButton(
          onPressed: _calculateSquare,
          child: const Text('Рассчитать'),
        ),
        // Вывод результатов расчета
        if (_calculationResult.isNotEmpty) ...[
          Text('Площадь: ${_calculationResult['area']}'),
          Text('Периметр: ${_calculationResult['perimeter']}'),
          Text('Площадь вписанного круга: ${_calculationResult['inscribedCircleArea']}'),
          Text('Площадь описанного круга: ${_calculationResult['circumscribedCircleArea']}'),
          Text(_calculationResult['description'] ?? ''),
        ]
      ],
    );
  }
}
