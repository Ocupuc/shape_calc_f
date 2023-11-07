import 'package:flutter/material.dart';
import 'api_service.dart';

class ParallelogramForm extends StatefulWidget {
  final ApiService apiService;

  const ParallelogramForm({Key? key, required this.apiService}) : super(key: key);

  @override
  _ParallelogramFormState createState() => _ParallelogramFormState();
}

class _ParallelogramFormState extends State<ParallelogramForm> {
  final _sideAController = TextEditingController();
  final _sideBController = TextEditingController();
  final _heightController = TextEditingController();
  Map<String, dynamic> _calculationResult = {};

  Future<void> _calculateParallelogram() async {
    final sideA = double.tryParse(_sideAController.text);
    final sideB = double.tryParse(_sideBController.text);
    final height = double.tryParse(_heightController.text);
    if (sideA != null && sideB != null && height != null) {
      try {
        var result = await widget.apiService.calculateParallelogram(sideA, sideB, height);
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
              if (number <= 0) {
                return 'Сторона A должна быть больше 0';
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
              if (number <= 0) {
                return 'Сторона B должна быть больше 0';
              }
              return null;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _heightController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Введите высоту',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Пожалуйста, введите высоту';
              }
              final number = double.tryParse(value);
              if (number == null) {
                return 'Введите корректное числовое значение';
              }
              if (number <= 0) {
                return 'Высота должна быть больше 0';
              }
              return null;
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (Form.of(context)?.validate() ?? false) {
              _calculateParallelogram();
            }
          },
          child: const Text('Рассчитать'),
        ),
        if (_calculationResult.isNotEmpty) ...[
          Text('Периметр: ${_calculationResult['perimeter']}'),
          Text('Площадь: ${_calculationResult['area']}'),
          Text(_calculationResult['description'] ?? ''),
        ],
      ],
    );
  }
}
