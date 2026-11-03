import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'cargo_calculator_page.dart';
import 'lpg_calculator_page.dart';
import 'discharging_rate_page.dart';
import 'petroleum_converter_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MaterialApp(
        title: 'Loading Master',
        theme: ThemeData(
          primaryColor: const Color(0xFF0B1B2E), // Navy Blue
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF0B1B2E),
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF58634), // Orange
              foregroundColor: Colors.white,
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFF58634)),
            ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1B2E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFF58634), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFF58634).withValues(alpha: 0.5),
                    spreadRadius: 5,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/logo.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.directions_boat,
                      size: 60,
                      color: Color(0xFFF58634),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'حاسبة ناقلات البترول',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'LOADING MASTER',
              style: TextStyle(
                color: Color(0xFFF58634),
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF58634)),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تطبيق حاسبة الشحن'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              'مرحباً بك في تطبيق حاسبة الشحن',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'اختر القسم المطلوب:',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            // LPG Calculator Card
            _buildSectionCard(
              title: '1. حاسبة كمية الغازات',
              subtitle: 'LPG Cargo Calculator',
              description: 'حساب كميات البوتان والبروبان في الخزانات',
              icon: Icons.local_gas_station,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LPGCalculatorPage()),
                );
              },
            ),
            const SizedBox(height: 16),
            // Discharging Rate Card
            _buildSectionCard(
              title: '2. حاسبة معدل التفريغ',
              subtitle: 'Discharging Rate Calculator',
              description: 'حساب وقت ومعدل التفريغ مع إدارة التوقفات',
              icon: Icons.timer,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DischargingRatePage()),
                );
              },
            ),
            const SizedBox(height: 16),
            // Petroleum Converter Card
            _buildSectionCard(
              title: '3. محول المنتجات البترولية',
              subtitle: 'Petroleum Products Converter',
              description: 'تحويل الكميات من VAC إلى AIR',
              icon: Icons.oil_barrel,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PetroleumConverterPage()),
                );
              },
            ),
            const SizedBox(height: 16),
            // Cargo Calculator Card
            _buildSectionCard(
              title: '4. حاسبة الشحن البترولية',
              subtitle: 'Petroleum Cargo Calculator',
              description: 'حسابات شحن المواد البترولية (المازوت والوقود)',
              icon: Icons.calculate,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CargoCalculatorPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String subtitle,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 32, color: Colors.blue[900]),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 20, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}


