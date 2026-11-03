import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PetroleumConverterPage extends StatefulWidget {
  const PetroleumConverterPage({super.key});

  @override
  _PetroleumConverterPageState createState() => _PetroleumConverterPageState();
}

class _PetroleumConverterPageState extends State<PetroleumConverterPage> {
  String _selectedProduct = 'Propane';
  final TextEditingController _densityController = TextEditingController(text: '0.50500');
  final TextEditingController _qtyVacController = TextEditingController();
  double _qtyAir = 0.0;

  final Map<String, double> _productDensities = {
    'Propane': 0.50500,
    'Butane': 0.58410,
    'Naphtha': 0.7000,
    'Gasoline': 0.7400,
    'Turbine': 0.8200,
    'Gasoil': 0.8400,
    'Crude Oil': 0.8500,
    'Fuel Oil': 0.9500,
    'Asphalt': 1.0400,
  };

  void _calculatePetroleum() {
    double density = double.tryParse(_densityController.text) ?? 0.0;
    double qtyVac = double.tryParse(_qtyVacController.text) ?? 0.0;
    _qtyAir = (qtyVac / density) * (density - 0.0011);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('محول المنتجات البترولية'),
        backgroundColor: const Color(0xFF7C3AED), // بنفسجي
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFFAF5FF), // خلفية بنفسجية فاتحة
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xA78BFA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                  )
                ],
              ),
              child: const Text(
                'تحويل الكمية من VAC إلى AIR',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E8FF),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFC4B5FD), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('اختر المنتج:', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7C3AED))),
                  const SizedBox(height: 8),
                  DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedProduct,
                    items: _productDensities.keys.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedProduct = value!;
                        _densityController.text = _productDensities[value]!.toString();
                      });
                      _calculatePetroleum();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _densityController,
              decoration: InputDecoration(
                labelText: 'الكثافة @ 15°C',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.water_drop, color: Color(0xFF7C3AED)),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
              onChanged: (value) => _calculatePetroleum(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _qtyVacController,
              decoration: InputDecoration(
                labelText: 'الكمية (MT VAC)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.scale, color: Color(0xFF7C3AED)),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
              onChanged: (value) => _calculatePetroleum(),
            ),
            const SizedBox(height: 24),
            // Result Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF7C3AED), Color(0xFFA78BFA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7C3AED).withValues(alpha: 0.4),
                    spreadRadius: 2,
                    blurRadius: 8,
                  )
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'الكمية (MT AIR)',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _qtyAir.toStringAsFixed(4),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Information Cards
            const Text('معلومات المنتج المختار:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF7C3AED))),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF3E8FF), Color(0xFFF5F3FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFC4B5FD), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('المنتج: $_selectedProduct', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF7C3AED))),
                  const SizedBox(height: 8),
                  Text('الكثافة: ${_densityController.text}', style: const TextStyle(fontSize: 15, color: Color(0xFF7C3AED))),
                  const SizedBox(height: 8),
                  Text('الكمية VAC: ${_qtyVacController.text.isEmpty ? '0.0' : _qtyVacController.text}',
                    style: const TextStyle(fontSize: 15, color: Color(0xFF7C3AED))),
                  const SizedBox(height: 8),
                  Text('الكمية AIR: ${_qtyAir.toStringAsFixed(4)}',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF7C3AED))),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFEF3C7), Color(0xFFFEF9E7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFCD34D), width: 1),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ملاحظات:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFFD97706))),
                  SizedBox(height: 8),
                  Text(
                    '• VAC: الوزن بالفراغ (Vacuum Weight)\n'
                    '• AIR: الوزن بالهواء (Air Weight)\n'
                    '• الحسابات تتبع معايير الشحن الدولية',
                    style: TextStyle(fontSize: 13, color: Color(0xFFB45309)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

