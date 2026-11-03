import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LPGCalculatorPage extends StatefulWidget {
  const LPGCalculatorPage({super.key});

  @override
  _LPGCalculatorPageState createState() => _LPGCalculatorPageState();
}

class _LPGCalculatorPageState extends State<LPGCalculatorPage> {
  final TextEditingController _butaneDensityController = TextEditingController(text: '0.58410');
  final TextEditingController _propaneDensityController = TextEditingController(text: '0.50500');

  List<Tank> _tanks = [Tank(name: '1P', gasType: 'Butane', qtyVac: 0.0)];

  double _totalButaneVac = 0.0;
  double _totalButaneAir = 0.0;
  double _totalPropaneVac = 0.0;
  double _totalPropaneAir = 0.0;
  double _grandTotalVac = 0.0;
  double _grandTotalAir = 0.0;

  @override
  void initState() {
    super.initState();
    _calculateTotals();
  }

  void _addTank() {
    int nextNumber = (_tanks.length ~/ 2) + 1;
    String suffix = _tanks.length % 2 == 0 ? 'P' : 'S';
    _tanks.add(Tank(name: '$nextNumber$suffix', gasType: 'Butane', qtyVac: 0.0));
    _calculateTotals();
  }

  void _removeTank(int index) {
    if (_tanks.length > 1) {
      _tanks.removeAt(index);
      _calculateTotals();
    }
  }

  void _updateTank(int index, {String? gasType, double? qtyVac}) {
    if (gasType != null) _tanks[index].gasType = gasType;
    if (qtyVac != null) {
      _tanks[index].qtyVac = qtyVac;
    }
    _calculateTotals();
  }

  void _calculateTotals() {
    _totalButaneVac = 0.0;
    _totalButaneAir = 0.0;
    _totalPropaneVac = 0.0;
    _totalPropaneAir = 0.0;

    double butaneDensity = double.tryParse(_butaneDensityController.text) ?? 0.58410;
    double propaneDensity = double.tryParse(_propaneDensityController.text) ?? 0.50500;

    for (var tank in _tanks) {
      tank.qtyVac = double.tryParse(tank.qtyController.text) ?? 0.0;
      double density = tank.gasType == 'Butane' ? butaneDensity : propaneDensity;
      double qtyAir = (tank.qtyVac / density) * (density - 0.0011);
      tank.qtyAir = qtyAir;

      if (tank.gasType == 'Butane') {
        _totalButaneVac += tank.qtyVac;
        _totalButaneAir += qtyAir;
      } else {
        _totalPropaneVac += tank.qtyVac;
        _totalPropaneAir += qtyAir;
      }
    }

    _grandTotalVac = _totalButaneVac + _totalPropaneVac;
    _grandTotalAir = _totalButaneAir + _totalPropaneAir;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حاسبة كمية الغازات (LPG)'),
        backgroundColor: const Color(0xFF0F766E), // Teal
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF0FDFA), // خلفية تيل فاتحة جداً
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F766E).withValues(alpha: 0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'إدارة الخزانات',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  ElevatedButton(
                    onPressed: _addTank,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    child: const Text('+ إضافة خزان', style: TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: const Color(0xFFD1FAE5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF6EE7B7), width: 1),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _butaneDensityController,
                      decoration: InputDecoration(
                        labelText: 'كثافة البوتان',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                      onChanged: (value) => _calculateTotals(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _propaneDensityController,
                      decoration: InputDecoration(
                        labelText: 'كثافة البروبان',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                      onChanged: (value) => _calculateTotals(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('اسم الخزان')),
                  DataColumn(label: Text('نوع الغاز')),
                  DataColumn(label: Text('الكمية (MT VAC)')),
                  DataColumn(label: Text('الكمية (MT AIR)')),
                  DataColumn(label: Text('حذف')),
                ],
                rows: _tanks.asMap().entries.map((entry) {
                  int index = entry.key;
                  Tank tank = entry.value;
                  return DataRow(cells: [
                    DataCell(Text(tank.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                    DataCell(DropdownButton<String>(
                      value: tank.gasType,
                      items: ['Butane', 'Propane'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) => _updateTank(index, gasType: value),
                    )),
                    DataCell(TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                      onTap: () {
                        tank.qtyController.selection = TextSelection(
                          baseOffset: 0,
                          extentOffset: tank.qtyController.text.length,
                        );
                      },
                      onChanged: (value) {
                        double? qty = double.tryParse(value);
                        if (qty != null) _updateTank(index, qtyVac: qty);
                      },
                      controller: tank.qtyController,
                    )),
                    DataCell(Text(tank.qtyAir.toStringAsFixed(2), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F766E)))),
                    DataCell(IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: _tanks.length > 1 ? () => _removeTank(index) : null,
                    )),
                  ]);
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFCCFBF1), Color(0xFFD1FAE5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF14B8A6), width: 2),
                    ),
                    child: Column(
                      children: [
                        const Text('إجمالي البوتان', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
                        Text('VAC: ${_totalButaneVac.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        Text('AIR: ${_totalButaneAir.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFCCFBF1), Color(0xFFD1FAE5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF14B8A6), width: 2),
                    ),
                    child: Column(
                      children: [
                        const Text('إجمالي البروبان', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
                        Text('VAC: ${_totalPropaneVac.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        Text('AIR: ${_totalPropaneAir.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFCCFBF1), Color(0xFFD1FAE5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF14B8A6), width: 2),
                    ),
                    child: Column(
                      children: [
                        const Text('الغازات الكلية', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF0F766E))),
                        Text('VAC: ${_grandTotalVac.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                        Text('AIR: ${_grandTotalAir.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Tank {
  String name;
  String gasType;
  double qtyVac;
  double qtyAir;
  TextEditingController qtyController;

  Tank({required this.name, required this.gasType, required this.qtyVac, this.qtyAir = 0.0})
      : qtyController = TextEditingController(text: qtyVac.toString());
}

