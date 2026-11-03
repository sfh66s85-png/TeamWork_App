import 'package:flutter/material.dart';

class CargoCalculatorPage extends StatefulWidget {
  const CargoCalculatorPage({super.key});

  @override
  _CargoCalculatorPageState createState() => _CargoCalculatorPageState();
}

class _CargoCalculatorPageState extends State<CargoCalculatorPage> {
  final TextEditingController _mtController = TextEditingController();
  final TextEditingController _densityController = TextEditingController();

  double? _mt;
  double? _density;
  double? _lt;
  double? _m3;
  int? _bbls;
  double? _gallons;
  double? _liters;

  final Map<String, double> _presets = {
    'مازوت': 0.9530,
    'سولار': 0.8450,
    'بنزين': 0.7400,
    'زيت خام': 0.8500,
  };

  void _calculate() {
    if (_mt != null && _density != null && _density! > 0) {
      setState(() {
        _lt = _mt! / 1.01604691;
        _m3 = _mt! / _density!;
        double bblsDouble = _m3! * 6.28981;
        _bbls = bblsDouble.round();
        _gallons = _bbls! * 42.0;
        _liters = _m3! * 1000;
      });
    }
  }

  void _onMtChanged(String value) {
    _mt = double.tryParse(value);
    _calculate();
  }

  void _onDensityChanged(String value) {
    _density = double.tryParse(value);
    _calculate();
  }

  void _selectPreset(String product, double density) {
    _densityController.text = density.toString();
    _density = density;
    _calculate();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('حاسبة الشحن البترولية'),
          backgroundColor: const Color(0xFFD97706), // برتقالي
          elevation: 0,
        ),
        backgroundColor: const Color(0xFFFFF7ED), // خلفية برتقالية فاتحة جداً
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Input Section
                Container(
                  padding: const EdgeInsets.all(14.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFD97706).withValues(alpha: 0.3),
                        spreadRadius: 2,
                        blurRadius: 8,
                      )
                    ],
                  ),
                  child: const Text(
                    'بيانات الشحن',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                // Inputs
                TextFormField(
                  controller: _mtController,
                  decoration: InputDecoration(
                    labelText: 'الوزن بالطن المتري (MT)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    prefixIcon: const Icon(Icons.scale, color: Color(0xFFD97706)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: _onMtChanged,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _densityController,
                  decoration: InputDecoration(
                    labelText: 'الكثافة النوعية (Density)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    prefixIcon: const Icon(Icons.water_drop, color: Color(0xFFD97706)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: _onDensityChanged,
                ),
                const SizedBox(height: 16),
                // Presets
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFED7AA),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFBBF24), width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('اختيار نوع المنتج:', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD97706))),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        children: _presets.entries.map((entry) {
                          return ChoiceChip(
                            label: Text(entry.key),
                            selected: false,
                            onSelected: (_) => _selectPreset(entry.key, entry.value),
                            backgroundColor: Colors.white,
                            side: const BorderSide(color: Color(0xFFFBBF24), width: 1),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Results
                if (_bbls != null)
                  Center(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFD97706).withValues(alpha: 0.4),
                            spreadRadius: 2,
                            blurRadius: 8,
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'البراميل (BBLS)',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _bbls!.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 56,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                if (_lt != null && _m3 != null)
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14.0),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFED7AA), Color(0xFFFEDBA8)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFFBBF24), width: 2),
                          ),
                          child: Column(
                            children: [
                              const Text('الطن الطولي (LT)', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD97706))),
                              const SizedBox(height: 8),
                              Text(
                                _lt!.toStringAsFixed(2),
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFD97706)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(14.0),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFED7AA), Color(0xFFFEDBA8)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFFBBF24), width: 2),
                          ),
                          child: Column(
                            children: [
                              const Text('المتر المكعب (M³)', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD97706))),
                              const SizedBox(height: 8),
                              Text(
                                _m3!.toStringAsFixed(2),
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFD97706)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                // Other measurements
                if (_gallons != null)
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFCD34D), width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('الجالون الأمريكي', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFB45309))),
                        Text(_gallons!.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFB45309), fontSize: 16)),
                      ],
                    ),
                  ),
                if (_liters != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFFCD34D), width: 1),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('اللترات', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFB45309))),
                          Text(_liters!.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFB45309), fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 24),
                // Note
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE2E2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFDC2626), width: 1),
                  ),
                  child: const Text(
                    'ملاحظة فنية: الحسابات تتبع معايير ASTM وبوالص الشحن الدولية للمواد البترولية.',
                    style: TextStyle(fontStyle: FontStyle.italic, color: Color(0xFF7F1D1D), fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
