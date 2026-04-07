import 'package:flutter/material.dart';
import 'main.dart';

// Zorluk seviyesi enum — uygulama genelinde kullanacağız
enum Zorluk { kolay, orta, zor }

class AnaMenu extends StatefulWidget {
  final int enYuksekSkor;
  const AnaMenu({super.key, required this.enYuksekSkor});

  @override
  State<AnaMenu> createState() => _AnaMenuState();
}

class _AnaMenuState extends State<AnaMenu> {
  Zorluk seciliZorluk = Zorluk.orta;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Column(
          children: [

            // En yüksek skor
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('EN YÜKSEK SKOR',
                          style: TextStyle(color: Colors.white38, fontSize: 11, letterSpacing: 2)),
                      Text('${widget.enYuksekSkor} sn',
                          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  // Ayarlar butonu
                  IconButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const AyarlarPlaceholder()));
                    },
                    icon: const Icon(Icons.settings, color: Colors.white54, size: 28),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Logo
            const Text('⚡', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 12),
            const Text('ŞARJ İNADI',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 4)),
            const SizedBox(height: 4),
            const Text('ne kadar dayanabilirsin?',
                style: TextStyle(color: Colors.white38, fontSize: 14, letterSpacing: 1)),

            const SizedBox(height: 60),

            // Zorluk seçimi
            const Text('ZORLUK', style: TextStyle(color: Colors.white38, fontSize: 12, letterSpacing: 3)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _zorlukButon('KOLAY', Zorluk.kolay, Colors.green),
                const SizedBox(width: 8),
                _zorlukButon('ORTA', Zorluk.orta, Colors.orange),
                const SizedBox(width: 8),
                _zorlukButon('ZOR', Zorluk.zor, Colors.red),
              ],
            ),

            const SizedBox(height: 40),

            // Oyna butonu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => OyunEkrani(zorluk: seciliZorluk),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.green.shade700,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.green.withValues(alpha: 0.4),
                          blurRadius: 20,
                          spreadRadius: 2),
                    ],
                  ),
                  child: const Center(
                    child: Text('OYNA',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 4)),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Market butonu
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const MarketPlaceholder()));
                },
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Center(
                    child: Text('🛒 MARKET',
                        style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _zorlukButon(String isim, Zorluk zorluk, Color renk) {
    bool secili = seciliZorluk == zorluk;
    return GestureDetector(
      onTap: () => setState(() => seciliZorluk = zorluk),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: secili ? renk.withValues(alpha: 0.2) : Colors.white10,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: secili ? renk : Colors.white24, width: 2),
        ),
        child: Text(isim,
            style: TextStyle(
                color: secili ? renk : Colors.white54,
                fontWeight: FontWeight.bold,
                fontSize: 14)),
      ),
    );
  }
}

// Geçici placeholder'lar — sonra gerçekleriyle değiştireceğiz
class OyunPlaceholder extends StatelessWidget {
  final Zorluk zorluk;
  const OyunPlaceholder({super.key, required this.zorluk});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF0D0D0D),
    body: Center(child: Text('Oyun ekranı buraya gelecek\nZorluk: $zorluk',
        style: const TextStyle(color: Colors.white), textAlign: TextAlign.center)),
  );
}

class MarketPlaceholder extends StatelessWidget {
  const MarketPlaceholder({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF0D0D0D),
    body: const Center(child: Text('Market buraya gelecek',
        style: TextStyle(color: Colors.white))),
  );
}

class AyarlarPlaceholder extends StatelessWidget {
  const AyarlarPlaceholder({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF0D0D0D),
    body: const Center(child: Text('Ayarlar buraya gelecek',
        style: TextStyle(color: Colors.white))),
  );
}