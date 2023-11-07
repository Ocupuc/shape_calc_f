import 'package:flutter/material.dart';
import 'api_service.dart';

class TriangleForm extends StatefulWidget {
  final ApiService apiService;

  const TriangleForm({Key? key, required this.apiService}) : super(key: key);

  @override
  _TriangleFormState createState() => _TriangleFormState();
}

class _TriangleFormState extends State<TriangleForm> {
  final _formKey = GlobalKey<FormState>();
  final _sideAController = TextEditingController();
  final _sideBController = TextEditingController();
  final _sideCController = TextEditingController();
  Map<String, dynamic> _calculationResult = {};

  Future<void> _calculateTriangle() async {
    if (_formKey.currentState!.validate()) {
      final sideA = double.tryParse(_sideAController.text);
      final sideB = double.tryParse(_sideBController.text);
      final sideC = double.tryParse(_sideCController.text);
      if (sideA != null && sideB != null && sideC != null) {
        try {
          var result = await widget.apiService.calculateTriangle(sideA, sideB, sideC);
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
              controller: _sideAController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Введите длину стороны A',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите длину стороны A';
                }
                if (double.tryParse(value) == null) {
                  return 'Введите числовое значение';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _sideBController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Введите длину стороны B',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите длину стороны B';
                }
                if (double.tryParse(value) == null) {
                  return 'Введите числовое значение';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _sideCController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Введите длину стороны C',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите длину стороны C';
                }
                if (double.tryParse(value) == null) {
                  return 'Введите числовое значение';
                }
                return null;
              },
            ),
          ),
          ElevatedButton(
            onPressed: _calculateTriangle,
            child: const Text('Рассчитать'),
          ),
          ..._buildCalculationResultWidgets(_calculationResult),
        ],
      ),
    );
  }

  List<Widget> _buildCalculationResultWidgets(Map<String, dynamic> result) {
    if (result.isEmpty) {
      return [];
    }

    return [
      Text('Площадь: ${result['area'].toStringAsFixed(4)}'),
      Text('Периметр: ${result['perimeter'].toStringAsFixed(4)}'),
      Text('Тип треугольника: ${result['triangleType']}'),
      Text('Высоты: ${result['heights'].map((x) => x.toStringAsFixed(4)).join(', ')}'),
      Text('Медианы: ${result['medians'].map((x) => x.toStringAsFixed(4)).join(', ')}'),
      Text('Биссектрисы: ${result['bisectors'].map((x) => x.toStringAsFixed(4)).join(', ')}'),
      Text('Площадь вписанной окружности: ${result['inscribedCircleArea'].toStringAsFixed(4)}'),
      Text('Площадь описанной окружности: ${result['circumscribedCircleArea'].toStringAsFixed(4)}'),
      Text(result['definition'] ?? ''),
    ];
  }
}
