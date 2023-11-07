import 'package:flutter/material.dart';
import 'api_service.dart';

class RhombusForm extends StatefulWidget {
  final ApiService apiService;

  const RhombusForm({Key? key, required this.apiService}) : super(key: key);

  @override
  _RhombusFormState createState() => _RhombusFormState();
}

class _RhombusFormState extends State<RhombusForm> {
  final _formKey = GlobalKey<FormState>(); // Добавляем ключ для Form
  final _sideController = TextEditingController();
  final _heightController = TextEditingController();
  Map<String, dynamic> _calculationResult = {};

  Future<void> _calculateRhombus() async {
    // Добавляем проверку валидации
    if (_formKey.currentState!.validate()) {
      final side = double.tryParse(_sideController.text);
      final height = double.tryParse(_heightController.text);
      if (side != null && height != null) {
        try {
          var result = await widget.apiService.calculateRhombus(side, height);
          setState(() {
            _calculationResult = result;
          });
        } catch (e) {
          // Обработка исключения
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form( // Используем виджет Form
      key: _formKey, // Применяем ключ к Form
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _sideController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Введите длину стороны',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите длину стороны';
                }
                final number = double.tryParse(value);
                if (number == null) {
                  return 'Введите корректное числовое значение';
                }
                if (number <= 0) {
                  return 'Длина стороны должна быть больше 0';
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
                labelText: 'Введите высоту ромба',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите высоту ромба';
                }
                final number = double.tryParse(value);
                if (number == null) {
                  return 'Введите корректное числовое значение';
                }
                if (number <= 0) {
                  return 'Высота должна быть больше 0';
                }
                if (_sideController.text.isNotEmpty) {
                  final side = double.tryParse(_sideController.text);
                  if (side != null && number >= side) {
                    return 'Высота должна быть меньше стороны ромба';
                  }
                }
                return null;
              },
            ),
          ),
          ElevatedButton(
            onPressed: _calculateRhombus,
            child: const Text('Рассчитать'),
          ),
          if (_calculationResult.isNotEmpty) ...[
            Text('Периметр: ${_calculationResult['perimeter']}'),
            Text('Площадь: ${_calculationResult['area']}'),
            Text(_calculationResult['description'] ?? ''),
          ],
        ],
      ),
    );
  }
}

