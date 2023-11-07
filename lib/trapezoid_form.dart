import 'package:flutter/material.dart';
import 'api_service.dart';

class TrapezoidForm extends StatefulWidget {
  final ApiService apiService;

  const TrapezoidForm({Key? key, required this.apiService}) : super(key: key);

  @override
  _TrapezoidFormState createState() => _TrapezoidFormState();
}

class _TrapezoidFormState extends State<TrapezoidForm> {
  final _formKey = GlobalKey<FormState>();
  final _sideBController = TextEditingController();
  final _sideDController = TextEditingController();
  final _heightController = TextEditingController();
  Map<String, dynamic> _calculationResult = {};

  Future<void> _calculateTrapezoid() async {
    if (_formKey.currentState!.validate()) {
      final sideB = double.tryParse(_sideBController.text);
      final sideD = double.tryParse(_sideDController.text);
      final height = double.tryParse(_heightController.text);

      if (sideB != null && sideD != null && height != null) {
        try {
          var result = await widget.apiService.calculateTrapezoid(sideB, sideD, height);
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
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _sideBController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Введите длину верхнего основания',
              ),
              validator: _validateSide,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _sideDController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Введите длину нижнего основания',
              ),
              validator: _validateSide,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _heightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Введите высоту трапеции',
              ),
              validator: _validateHeight,
            ),
          ),
          ElevatedButton(
            onPressed: _calculateTrapezoid,
            child: const Text('Рассчитать'),
          ),
          if (_calculationResult.isNotEmpty) ...[
            Text('Площадь: ${_calculationResult['area']}'),
            Text('Периметр: ${_calculationResult['perimeter']}'),
            Text(_calculationResult['description'] ?? ''),
            Text('Длина боковой стороны: ${_calculationResult['side']}'),
          ],
        ],
      ),
    );
  }

  String? _validateSide(String? value) {
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
  }

  String? _validateHeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Пожалуйста, введите высоту трапеции';
    }
    final number = double.tryParse(value);
    if (number == null) {
      return 'Введите корректное числовое значение';
    }
    if (number <= 0) {
      return 'Высота должна быть больше 0';
    }
    return null;
  }
}
