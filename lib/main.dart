import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(const PremiumFitnessApp());
}

class PremiumFitnessApp extends StatelessWidget {
  const PremiumFitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Premium Analiz',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF090E17),
        primaryColor: const Color(0xFF00F2FE),
      ),
      home: const AnaEkran(),
    );
  }
}

class AnaEkran extends StatefulWidget {
  const AnaEkran({super.key});

  @override
  State<AnaEkran> createState() => _AnaEkranState();
}

class _AnaEkranState extends State<AnaEkran> with SingleTickerProviderStateMixin {
  final TextEditingController boyController = TextEditingController();
  final TextEditingController kiloController = TextEditingController();
  // Varsayılan yaş değeri
  final TextEditingController yasController = TextEditingController(text: '21');

  // Varsayılan analiz tercihleri
  String secilenCinsiyet = 'Erkek';
  String secilenHareket = 'Haftada 5 Gün (Aktif Spor)';
  String secilenHedef = 'Kilo Ver (Yağ Yak)';

  bool analizYapildi = false;
  
  double bmi = 0;
  int gunlukKalori = 0;
  int protein = 0;
  int yag = 0;
  int karbonhidrat = 0;

  void sonuclariHesapla() {
    double boy = double.tryParse(boyController.text) ?? 0;
    double kilo = double.tryParse(kiloController.text) ?? 0;
    int yas = int.tryParse(yasController.text) ?? 0;

    if (boy == 0 || kilo == 0 || yas == 0) return;

    // Hesaplama Algoritmaları
    bmi = kilo / ((boy / 100) * (boy / 100));
    
    double bmr = (secilenCinsiyet == 'Erkek') 
        ? (10 * kilo) + (6.25 * boy) - (5 * yas) + 5
        : (10 * kilo) + (6.25 * boy) - (5 * yas) - 161;

    double carpan = 1.2;
    if (secilenHareket == 'Haftada 1-3 Gün') carpan = 1.375;
    if (secilenHareket == 'Haftada 5 Gün (Aktif Spor)') carpan = 1.55;
    if (secilenHareket == 'Hergün Ağır İdman') carpan = 1.725;

    double tdee = bmr * carpan;

    if (secilenHedef == 'Kilo Ver (Yağ Yak)') {
      gunlukKalori = (tdee - 400).round();
    } else if (secilenHedef == 'Kilo Al (Kas Yap)') {
      gunlukKalori = (tdee + 400).round();
    } else {
      gunlukKalori = tdee.round();
    }

    protein = (kilo * 2.0).round();
    yag = ((gunlukKalori * 0.25) / 9).round();
    karbonhidrat = ((gunlukKalori - (protein * 4) - (yag * 9)) / 4).round();

    setState(() {
      analizYapildi = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Arka plan gradient efekti
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.8, -0.6),
            radius: 1.5,
            colors: [Color(0xFF1A2A42), Color(0xFF090E17)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Modern Başlık
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF00F2FE), Color(0xFF4FACFE)],
                  ).createShader(bounds),
                  child: const Text(
                    "FİZİKSEL\nANALİZ",
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, height: 1.1, color: Colors.white, letterSpacing: 1.5),
                  ),
                ),
                const SizedBox(height: 30),

                // Cam Efektli Veri Giriş Kartı
                GlassCard(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _modernTextField(boyController, "Boy (cm)", Icons.height)),
                          const SizedBox(width: 16),
                          Expanded(child: _modernTextField(kiloController, "Kilo (kg)", Icons.monitor_weight_outlined)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _modernTextField(yasController, "Yaş", Icons.cake_outlined),
                      const SizedBox(height: 16),
                      _modernDropdown(
                        "Cinsiyet",
                        secilenCinsiyet,
                        ['Erkek', 'Kadın'],
                        (val) => setState(() => secilenCinsiyet = val!),
                      ),
                      const SizedBox(height: 16),
                      _modernDropdown(
                        "Aktivite Seviyesi",
                        secilenHareket,
                        ['Hareketsiz', 'Haftada 1-3 Gün', 'Haftada 5 Gün (Aktif Spor)', 'Hergün Ağır İdman'],
                        (val) => setState(() => secilenHareket = val!),
                      ),
                      const SizedBox(height: 16),
                      _modernDropdown(
                        "Hedef",
                        secilenHedef,
                        ['Kilo Ver (Yağ Yak)', 'Kilomu Koru', 'Kilo Al (Kas Yap)'],
                        (val) => setState(() => secilenHedef = val!),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Neon Buton
                GestureDetector(
                  onTap: sonuclariHesapla,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF00F2FE), Color(0xFF4FACFE)]),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: const Color(0xFF00F2FE).withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8)),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "GÜCÜNÜ KEŞFET",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Animasyonlu Sonuç Kartı
                AnimatedSize(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutExpo,
                  child: analizYapildi ? _sonucKarti() : const SizedBox.shrink(),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Özel Tasarım TextField
  Widget _modernTextField(TextEditingController controller, String hint, IconData icon) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFF00F2FE), size: 22),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF00F2FE), width: 1.5),
        ),
      ),
    );
  }

  // Özel Tasarım Dropdown
  Widget _modernDropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: const Color(0xFF1A2A42),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF00F2FE)),
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
          items: items.map((String item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // Sonuç Kartı Tasarımı
  Widget _sonucKarti() {
    return GlassCard(
      child: Column(
        children: [
          const Text("GÜNLÜK HEDEF", style: TextStyle(color: Colors.grey, fontSize: 12, letterSpacing: 2)),
          const SizedBox(height: 10),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(colors: [Color(0xFF00F2FE), Color(0xFF4FACFE)]).createShader(bounds),
            child: Text(
              "$gunlukKalori",
              style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w900, color: Colors.white),
            ),
          ),
          const Text("KCAL", style: TextStyle(color: Colors.white54, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _makroHalkasi("Protein", protein, const Color(0xFFFF512F)),
              _makroHalkasi("Karbo", karbonhidrat, const Color(0xFF00F2FE)),
              _makroHalkasi("Yağ", yag, const Color(0xFFF09819)),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("BMI İndeksi", style: TextStyle(color: Colors.white70, fontSize: 16)),
                Text(bmi.toStringAsFixed(1), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Makro Değerleri Göstergesi
  Widget _makroHalkasi(String isim, int gram, Color renk) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: renk.withOpacity(0.3), width: 3),
            boxShadow: [BoxShadow(color: renk.withOpacity(0.2), blurRadius: 10)],
          ),
          child: Center(
            child: Text("${gram}g", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 8),
        Text(isim, style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

// Yeniden Kullanılabilir Buzlu Cam (Glassmorphism) Widget'ı
class GlassCard extends StatelessWidget {
  final Widget child;
  const GlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1.5),
          ),
          child: child,
        ),
      ),
    );
  }
}