import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DischargingRatePage extends StatefulWidget {
  const DischargingRatePage({super.key});

  @override
  _DischargingRatePageState createState() => _DischargingRatePageState();
}

class _DischargingRatePageState extends State<DischargingRatePage> {
  DateTime? _startDateTime;
  DateTime? _endDateTime;
  final TextEditingController _dischargedQtyController = TextEditingController();
  String _duration = '';
  String _rate = '';
  String _errorMessage = '';
  List<Stoppage> _stoppages = [];
  String _netDuration = '';

  void _calculateDischarging() {
    if (_startDateTime != null && _endDateTime != null) {
      if (_endDateTime!.isBefore(_startDateTime!)) {
        setState(() {
          _errorMessage = 'وقت النهاية قبل وقت البداية';
          _duration = '';
          _rate = '';
          _netDuration = '';
        });
        return;
      }

      Duration diff = _endDateTime!.difference(_startDateTime!);

      // حساب إجمالي التوقفات
      int totalStoppageMinutes = 0;
      for (var stoppage in _stoppages) {
        int stoppageMinutes = stoppage.calculateDuration();
        totalStoppageMinutes += stoppageMinutes;
      }

      // الوقت الصافي = الوقت الكلي - التوقفات
      int netMinutes = diff.inMinutes - totalStoppageMinutes;
      int netHours = netMinutes ~/ 60;
      int netMins = netMinutes % 60;

      int hours = diff.inHours;
      int minutes = diff.inMinutes % 60;
      _duration = '$hours ساعات و $minutes دقائق';
      _netDuration = '$netHours ساعات و $netMins دقائق';

      double qty = double.tryParse(_dischargedQtyController.text) ?? 0.0;
      double totalHours = netMinutes / 60.0;
      double rate = totalHours > 0 ? qty / totalHours : 0;
      _rate = '${rate.toStringAsFixed(2)} MT/ساعة';

      setState(() {
        _errorMessage = '';
      });
    }
  }

  Future<void> _selectDateTime(BuildContext context, bool isStart) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time != null) {
        DateTime dateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        setState(() {
          if (isStart) {
            _startDateTime = dateTime;
          } else {
            _endDateTime = dateTime;
          }
        });
        _calculateDischarging();
      }
    }
  }

  void _addStoppage() {
    setState(() {
      _stoppages.add(Stoppage(
        startHour: 0,
        startMinute: 0,
        endHour: 0,
        endMinute: 0,
        day: 'اليوم الأول',
      ));
      _calculateDischarging();
    });
  }

  void _removeStoppage(int index) {
    setState(() {
      _stoppages.removeAt(index);
      _calculateDischarging();
    });
  }

  void _updateStoppage(
    int index, {
    int? startHour,
    int? startMinute,
    int? endHour,
    int? endMinute,
    String? day,
  }) {
    if (startHour != null) _stoppages[index].startHour = startHour;
    if (startMinute != null) _stoppages[index].startMinute = startMinute;
    if (endHour != null) _stoppages[index].endHour = endHour;
    if (endMinute != null) _stoppages[index].endMinute = endMinute;
    if (day != null) _stoppages[index].day = day;
    _calculateDischarging();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حاسبة معدل التفريغ'),
        backgroundColor: const Color(0xFF1E40AF), // رازي غامق
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF0F9FF), // خلفية زرقاء فاتحة
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time Period Section
            Container(
              padding: const EdgeInsets.all(14.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1E40AF).withValues(alpha: 0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                  )
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'فترة التفريغ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDateTime(context, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      padding: const EdgeInsets.all(12),
                    ),
                    label: Text(
                      _startDateTime == null
                          ? 'البداية'
                          : _startDateTime!.toString().substring(0, 16),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDateTime(context, false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF59E0B),
                      padding: const EdgeInsets.all(12),
                    ),
                    label: Text(
                      _endDateTime == null
                          ? 'النهاية'
                          : _endDateTime!.toString().substring(0, 16),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              controller: _dischargedQtyController,
              decoration: InputDecoration(
                labelText: 'الكمية المفرغة (MT)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                prefixIcon: const Icon(Icons.calculate, color: Color(0xFF3B82F6)),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
              onChanged: (value) => _calculateDischarging(),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(height: 16),
            // Results Section
            Container(
              padding: const EdgeInsets.all(14.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF34D399)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF10B981).withValues(alpha: 0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                  )
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'المدة الكلية: $_duration',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_netDuration.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'المدة الصافية: $_netDuration',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'المعدل: $_rate',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Stoppages Section
            Container(
              padding: const EdgeInsets.all(14.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFDC2626), Color(0xFFF87171)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFDC2626).withValues(alpha: 0.3),
                    spreadRadius: 2,
                    blurRadius: 8,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'التوقفات',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add, color: Color(0xFFDC2626)),
                    onPressed: _addStoppage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    label: const Text(
                      'إضافة توقف',
                      style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (_stoppages.isEmpty)
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFCA5A5), width: 2),
                  color: const Color(0xFFFEE2E2),
                ),
                child: const Text(
                  'لا توجد توقفات مسجلة',
                  style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              )
            else
              Column(
                children: _stoppages.asMap().entries.map((entry) {
                  int index = entry.key;
                  Stoppage stoppage = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFEE2E2), Color(0xFFFFECEB)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFFCA5A5), width: 1),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: stoppage.day,
                                  items: [
                                    'اليوم الأول',
                                    'اليوم الثاني',
                                    'اليوم الثالث',
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: const TextStyle(color: Color(0xFFDC2626)),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      _updateStoppage(index, day: value);
                                      setState(() {});
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Color(0xFFDC2626)),
                                onPressed: () => _removeStoppage(index),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Divider(color: Color(0xFFFCA5A5)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'بداية التوقف',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFDC2626),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: _buildTimeInput(
                                            'ساعة',
                                            stoppage.startHour,
                                            (value) {
                                              int? h = int.tryParse(value);
                                              if (h != null && h >= 0 && h < 24) {
                                                _updateStoppage(index, startHour: h);
                                              }
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          flex: 1,
                                          child: _buildTimeInput(
                                            'دقيقة',
                                            stoppage.startMinute,
                                            (value) {
                                              int? m = int.tryParse(value);
                                              if (m != null && m >= 0 && m < 60) {
                                                _updateStoppage(index, startMinute: m);
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'نهاية التوقف',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFDC2626),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: _buildTimeInput(
                                            'ساعة',
                                            stoppage.endHour,
                                            (value) {
                                              int? h = int.tryParse(value);
                                              if (h != null && h >= 0 && h < 24) {
                                                _updateStoppage(index, endHour: h);
                                              }
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          flex: 1,
                                          child: _buildTimeInput(
                                            'دقيقة',
                                            stoppage.endMinute,
                                            (value) {
                                              int? m = int.tryParse(value);
                                              if (m != null && m >= 0 && m < 60) {
                                                _updateStoppage(index, endMinute: m);
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDC2626),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'مدة التوقف:',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${stoppage.getDurationHours()}:${stoppage.getDurationMinutes().toString().padLeft(2, '0')} ساعة',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeInput(String label, int value, Function(String) onChanged) {
    return TextField(
      controller: TextEditingController(text: value.toString().padLeft(2, '0')),
      decoration: InputDecoration(
        hintText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*'))],
      onChanged: onChanged,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
    );
  }
}


class Stoppage {
  int startHour;
  int startMinute;
  int endHour;
  int endMinute;
  String day;

  Stoppage({
    required this.startHour,
    required this.startMinute,
    required this.endHour,
    required this.endMinute,
    required this.day,
  });

  int calculateDuration() {
    int startTotalMinutes = (startHour * 60) + startMinute;
    int endTotalMinutes = (endHour * 60) + endMinute;

    if (endTotalMinutes >= startTotalMinutes) {
      return endTotalMinutes - startTotalMinutes;
    } else {
      // إذا كانت النهاية في اليوم التالي
      return (24 * 60) - startTotalMinutes + endTotalMinutes;
    }
  }

  int getDurationHours() {
    return calculateDuration() ~/ 60;
  }

  int getDurationMinutes() {
    return calculateDuration() % 60;
  }
}

