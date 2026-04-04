import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const SarjInadiApp());
}

class SarjInadiApp extends StatelessWidget {
  const SarjInadiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Şarj İnadı',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const OyunEkrani(),
    );
  }
}

class OyunEkrani extends StatefulWidget {
  const OyunEkrani({super.key});

  @override
  State<OyunEkrani> createState() => _OyunEkraniState();
}

// ===== MATEMATİK MİNİGAME =====
class MatematikMinigame extends StatefulWidget {
  final Function(bool basarili) onBitis;
  const MatematikMinigame({super.key, required this.onBitis});

  @override
  State<MatematikMinigame> createState() => _MatematikMinigameState();
}

class _MatematikMinigameState extends State<MatematikMinigame> {
  late int sayi1, sayi2, dogruCevap;
  late List<int> secenekler;
  bool bitti = false;

  @override
  void initState() {
    super.initState();
    sayi1 = Random().nextInt(20) + 1;
    sayi2 = Random().nextInt(20) + 1;
    dogruCevap = sayi1 + sayi2;
    secenekler = [dogruCevap];
    while (secenekler.length < 4) {
      int yanlis = dogruCevap + Random().nextInt(10) - 5;
      if (!secenekler.contains(yanlis) && yanlis != dogruCevap) {
        secenekler.add(yanlis);
      }
    }
    secenekler.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Container(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  decoration: BoxDecoration(
    color: Colors.yellow.withValues(alpha: 0.15),
    borderRadius: BorderRadius.circular(20),
  ),
  child: const Text('⚡ MİNİGAME', style: TextStyle(color: Colors.yellow, fontSize: 13, letterSpacing: 3)),
),
            const SizedBox(height: 20),
            Text('$sayi1 + $sayi2 = ?',
                style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              children: secenekler.map((s) {
                return GestureDetector(
                  onTap: bitti ? null : () {
                    setState(() => bitti = true);
                    Future.delayed(const Duration(milliseconds: 600), () {
                      widget.onBitis(s == dogruCevap);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.blue.withValues(alpha: 0.5)),
                    ),
                    child: Center(
                      child: Text('$s',
                          style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
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
}

// ===== DÜŞEN PİL MİNİGAME =====
class DusenPilMinigame extends StatefulWidget {
  final Function(bool basarili) onBitis;
  const DusenPilMinigame({super.key, required this.onBitis});

  @override
  State<DusenPilMinigame> createState() => _DusenPilMinigameState();
}

class _DusenPilMinigameState extends State<DusenPilMinigame> {
  List<Map<String, dynamic>> piller = [];
  int yakalanan = 0;
  int kacirilan = 0;
  Timer? pilTimer;
  bool bitti = false;

  @override
  void initState() {
    super.initState();
    pilTimer = Timer.periodic(const Duration(milliseconds: 800), (t) {
      if (bitti) return;
      setState(() {
        piller.add({
          'x': Random().nextDouble() * 0.8 + 0.1,
          'y': 0.0,
          'id': DateTime.now().millisecondsSinceEpoch,
        });
      });

      // Piller aşağı düşer
      Future.delayed(const Duration(seconds: 3), () {
        if (!bitti) {
          setState(() {
            kacirilan++;
            if (kacirilan >= 3) {
              bitti = true;
              pilTimer?.cancel();
              widget.onBitis(yakalanan >= 5);
            }
          });
        }
      });
    });
  }

  @override
  void dispose() {
    pilTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Column(
        children: [
          const SizedBox(height: 60),
          Container(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  decoration: BoxDecoration(
    color: Colors.yellow.withValues(alpha: 0.15),
    borderRadius: BorderRadius.circular(20),
  ),
  child: const Text('⚡ MİNİGAME', style: TextStyle(color: Colors.yellow, fontSize: 13, letterSpacing: 3)),
),
          const SizedBox(height: 8),
         Container(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  decoration: BoxDecoration(
    color: Colors.yellow.withValues(alpha: 0.15),
    borderRadius: BorderRadius.circular(20),
  ),
  child: const Text('⚡ MİNİGAME', style: TextStyle(color: Colors.yellow, fontSize: 13, letterSpacing: 3)),
),
          Text('Yakalanan: $yakalanan | Kaçırılan: $kacirilan/3',
              style: const TextStyle(color: Colors.white54, fontSize: 16)),
          const SizedBox(height: 8),
          Text('Hedef: 5 pil yakala!', style: TextStyle(color: Colors.green.shade300, fontSize: 14)),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: piller.map((pil) {
                    return TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: constraints.maxHeight),
                      duration: const Duration(seconds: 3),
                      builder: (context, double y, child) {
                        return Positioned(
                          left: pil['x'] * constraints.maxWidth - 25,
                          top: y,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                piller.removeWhere((p) => p['id'] == pil['id']);
                                yakalanan++;
                              });
                            },
                            child: const Text('🔋', style: TextStyle(fontSize: 40)),
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ===== SİMON SAYS MİNİGAME =====
class SimonSaysMinigame extends StatefulWidget {
  final Function(bool basarili) onBitis;
  const SimonSaysMinigame({super.key, required this.onBitis});

  @override
  State<SimonSaysMinigame> createState() => _SimonSaysMinigameState();
}

class _SimonSaysMinigameState extends State<SimonSaysMinigame> {
  final List<Color> renkler = [Colors.red, Colors.blue, Colors.green, Colors.yellow];
  List<int> dizi = [];
  List<int> kullaniciDizisi = [];
  bool gosteriliyor = false;
  int gosterilenIndex = -1;

  @override
  void initState() {
    super.initState();
    diziOlustur();
  }

  void diziOlustur() {
    dizi = List.generate(4, (_) => Random().nextInt(4));
    Future.delayed(const Duration(milliseconds: 500), () => diziGoster(0));
  }

  void diziGoster(int index) {
    if (index >= dizi.length) {
      setState(() => gosteriliyor = false);
      return;
    }
    setState(() {
      gosteriliyor = true;
      gosterilenIndex = dizi[index];
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() => gosterilenIndex = -1);
      Future.delayed(const Duration(milliseconds: 300), () => diziGoster(index + 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Container(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  decoration: BoxDecoration(
    color: Colors.yellow.withValues(alpha: 0.15),
    borderRadius: BorderRadius.circular(20),
  ),
  child: const Text('⚡ MİNİGAME', style: TextStyle(color: Colors.yellow, fontSize: 13, letterSpacing: 3)),
),
            const SizedBox(height: 12),
            const Text('Sırayı Taklit Et!', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            Text(
  gosteriliyor ? '👁 İzle ve ezberle...' : '👆 Şimdi sırayla bas! (${kullaniciDizisi.length}/${dizi.length})',
  style: TextStyle(color: gosteriliyor ? Colors.orange : Colors.green, fontSize: 16),
),
            const SizedBox(height: 40),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              padding: const EdgeInsets.symmetric(horizontal: 60),
              children: List.generate(4, (i) {
                return GestureDetector(
                  onTap: gosteriliyor ? null : () {
                    kullaniciDizisi.add(i);
                    int idx = kullaniciDizisi.length - 1;
                    if (kullaniciDizisi[idx] != dizi[idx]) {
                      widget.onBitis(false);
                      return;
                    }
                    if (kullaniciDizisi.length == dizi.length) {
                      widget.onBitis(true);
                    }
                  },
                  child: AnimatedContainer(
  duration: const Duration(milliseconds: 150),
  decoration: BoxDecoration(
    color: gosterilenIndex == i
        ? renkler[i]
        : kullaniciDizisi.isNotEmpty && kullaniciDizisi.last == i && !gosteriliyor
            ? renkler[i].withValues(alpha: 0.8)
            : renkler[i].withValues(alpha: 0.25),
    borderRadius: BorderRadius.circular(16),
    boxShadow: gosterilenIndex == i ? [
      BoxShadow(color: renkler[i].withValues(alpha: 0.8), blurRadius: 20, spreadRadius: 5)
    ] : [],
  ),
),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== ŞİFRE KIRMA MİNİGAME =====
class SifreKirmaMinigame extends StatefulWidget {
  final Function(bool basarili) onBitis;
  const SifreKirmaMinigame({super.key, required this.onBitis});

  @override
  State<SifreKirmaMinigame> createState() => _SifreKirmaMinigameState();
}

class _SifreKirmaMinigameState extends State<SifreKirmaMinigame> {
  final List<Color> renkler = [Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.purple];
  late List<int> dogruSira;
  List<int> secilen = [];
  bool bitti = false;

  @override
  void initState() {
    super.initState();
    dogruSira = [0, 1, 2, 3, 4]..shuffle();
    dogruSira = dogruSira.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  decoration: BoxDecoration(
    color: Colors.yellow.withValues(alpha: 0.15),
    borderRadius: BorderRadius.circular(20),
  ),
  child: const Text('⚡ MİNİGAME', style: TextStyle(color: Colors.yellow, fontSize: 13, letterSpacing: 3)),
),
            const SizedBox(height: 12),
            const Text('Renk Şifresini Kır!', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: dogruSira.map((i) =>
                Container(
                  width: 40, height: 40,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: renkler[i],
                    shape: BoxShape.circle,
                  ),
                )
              ).toList(),
            ),
            const SizedBox(height: 8),
            const Text('Bu sırayla bas!', style: TextStyle(color: Colors.white54)),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (i) {
                bool secildi = secilen.contains(i);
                return GestureDetector(
                  onTap: bitti ? null : () {
                    setState(() => secilen.add(i));
                    int idx = secilen.length - 1;
                    if (secilen[idx] != dogruSira[idx]) {
                      setState(() => bitti = true);
                      Future.delayed(const Duration(milliseconds: 500), () => widget.onBitis(false));
                      return;
                    }
                    if (secilen.length == dogruSira.length) {
                      setState(() => bitti = true);
                      Future.delayed(const Duration(milliseconds: 500), () => widget.onBitis(true));
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 50, height: 50,
                    decoration: BoxDecoration(
                      color: secildi ? renkler[i] : renkler[i].withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                      border: Border.all(color: renkler[i], width: 2),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== TELEFON DENGEDE TUT MİNİGAME =====
class Dengeminigame extends StatefulWidget {
  final Function(bool basarili) onBitis;
  const Dengeminigame({super.key, required this.onBitis});

  @override
  State<Dengeminigame> createState() => _DengeMinigameState();
}

class _DengeMinigameState extends State<Dengeminigame> {
  double topX = 0.5;
  double topY = 0.5;
  Timer? dengeTimer;
  int sure = 5;
  bool bitti = false;

  @override
  void initState() {
    super.initState();
    dengeTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => sure--);
      if (sure <= 0) {
        bitti = true;
        dengeTimer?.cancel();
        widget.onBitis(topX > 0.3 && topX < 0.7 && topY > 0.3 && topY < 0.7);
      }
    });
  }

  @override
  void dispose() {
    dengeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Column(
        children: [
          const SizedBox(height: 60),
          Container(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  decoration: BoxDecoration(
    color: Colors.yellow.withValues(alpha: 0.15),
    borderRadius: BorderRadius.circular(20),
  ),
  child: const Text('⚡ MİNİGAME', style: TextStyle(color: Colors.yellow, fontSize: 13, letterSpacing: 3)),
),
          const SizedBox(height: 12),
          const Text('Telefonu Dengede Tut!', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
          Text('$sure saniye kaldı', style: TextStyle(color: Colors.orange, fontSize: 20)),
          const SizedBox(height: 8),
          const Text('Topu ortada tut!', style: TextStyle(color: Colors.white54)),
          Expanded(
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  topX = (topX + details.delta.dx / 300).clamp(0.0, 1.0);
                  topY = (topY + details.delta.dy / 300).clamp(0.0, 1.0);
                });
              },
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white24),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      // Hedef bölge
                      Center(
                        child: Container(
                          width: 120, height: 120,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.green.withValues(alpha: 0.5), width: 2),
                            borderRadius: BorderRadius.circular(60),
                          ),
                        ),
                      ),
                      // Top
                      Positioned(
                        left: topX * constraints.maxWidth - 20,
                        top: topY * constraints.maxHeight - 20,
                        child: Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: topX > 0.3 && topX < 0.7 && topY > 0.3 && topY < 0.7
                                ? Colors.green
                                : Colors.red,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.white.withValues(alpha: 0.3), blurRadius: 10)],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ===== PIL KAÇAĞI MİNİGAME =====
class PilKacagiMinigame extends StatefulWidget {
  final Function(bool basarili) onBitis;
  const PilKacagiMinigame({super.key, required this.onBitis});

  @override
  State<PilKacagiMinigame> createState() => _PilKacagiMinigameState();
}

// ===== HIZLI YAZ MİNİGAME =====
class HizliYazMinigame extends StatefulWidget {
  final Function(bool basarili) onBitis;
  const HizliYazMinigame({super.key, required this.onBitis});

  @override
  State<HizliYazMinigame> createState() => _HizliYazMinigameState();
}

class _HizliYazMinigameState extends State<HizliYazMinigame> {
  final List<String> kelimeler = ['ŞARJ', 'KABLO', 'PİL', 'BATARYA', 'VOLTAJ', 'AKIM', 'GÜÇ', 'ENERJİ'];
  late String hedefKelime;
  final TextEditingController kontrolcu = TextEditingController();
  bool bitti = false;
  int sure = 10;
  Timer? sureTimer;

  @override
  void initState() {
    super.initState();
    hedefKelime = kelimeler[Random().nextInt(kelimeler.length)];
    sureTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => sure--);
      if (sure <= 0) {
        bitti = true;
        sureTimer?.cancel();
        widget.onBitis(false);
      }
    });
  }

  @override
  void dispose() {
    sureTimer?.cancel();
    kontrolcu.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Container(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  decoration: BoxDecoration(
    color: Colors.yellow.withValues(alpha: 0.15),
    borderRadius: BorderRadius.circular(20),
  ),
  child: const Text('⚡ MİNİGAME', style: TextStyle(color: Colors.yellow, fontSize: 13, letterSpacing: 3)),
),
              const SizedBox(height: 20),
              const Text('Hızlı Yaz!', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('$sure saniye', style: TextStyle(color: sure <= 3 ? Colors.red : Colors.orange, fontSize: 20)),
              const SizedBox(height: 30),
              Text(hedefKelime,
                  style: const TextStyle(color: Colors.cyan, fontSize: 48, fontWeight: FontWeight.bold, letterSpacing: 8)),
              const SizedBox(height: 30),
              TextField(
                controller: kontrolcu,
                autofocus: true,
                textCapitalization: TextCapitalization.characters,
                style: const TextStyle(color: Colors.white, fontSize: 24),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.white24),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.cyan),
                  ),
                  hintText: 'Buraya yaz...',
                  hintStyle: const TextStyle(color: Colors.white24),
                ),
                onChanged: (v) {
                  if (v.toUpperCase() == hedefKelime && !bitti) {
                    setState(() => bitti = true);
                    sureTimer?.cancel();
                    widget.onBitis(true);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===== KELİME BUL MİNİGAME =====
class KelimeBulMinigame extends StatefulWidget {
  final Function(bool basarili) onBitis;
  const KelimeBulMinigame({super.key, required this.onBitis});

  @override
  State<KelimeBulMinigame> createState() => _KelimeBulMinigameState();
}

class _KelimeBulMinigameState extends State<KelimeBulMinigame> {
  final List<String> kelimeler = ['ŞARJ', 'KABLO', 'PİL', 'GÜÇ', 'AKIM'];
  late String hedef;
  late List<String> karisik;
  List<String> secilen = [];
  bool bitti = false;

  @override
  void initState() {
    super.initState();
    hedef = kelimeler[Random().nextInt(kelimeler.length)];
    karisik = hedef.split('')..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  decoration: BoxDecoration(
    color: Colors.yellow.withValues(alpha: 0.15),
    borderRadius: BorderRadius.circular(20),
  ),
  child: const Text('⚡ MİNİGAME', style: TextStyle(color: Colors.yellow, fontSize: 13, letterSpacing: 3)),
),
            const Text('Kelimeyi Bul!', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('${hedef.length} harfli kelime',
                style: const TextStyle(color: Colors.white54, fontSize: 16)),
            const SizedBox(height: 30),
            // Seçilen harfler
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(hedef.length, (i) {
                return Container(
                  width: 50, height: 50,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.cyan),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      i < secilen.length ? secilen[i] : '',
                      style: const TextStyle(color: Colors.cyan, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 30),
            // Karışık harfler
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: List.generate(karisik.length, (i) {
                bool kullanildi = secilen.length > i && secilen.isNotEmpty;
                return GestureDetector(
                  onTap: bitti ? null : () {
                    setState(() {
                      if (secilen.length < hedef.length) {
                        secilen.add(karisik[i]);
                        if (secilen.length == hedef.length) {
                          bitti = true;
                          bool dogru = secilen.join() == hedef;
                          Future.delayed(const Duration(milliseconds: 600), () => widget.onBitis(dogru));
                        }
                      }
                    });
                  },
                  child: Container(
                    width: 50, height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Center(
                      child: Text(karisik[i],
                          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => setState(() => secilen = []),
              child: const Text('Temizle', style: TextStyle(color: Colors.white38)),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== SAYI SIRALA MİNİGAME =====
class SayiSiralaMinigame extends StatefulWidget {
  final Function(bool basarili) onBitis;
  const SayiSiralaMinigame({super.key, required this.onBitis});

  @override
  State<SayiSiralaMinigame> createState() => _SayiSiralaMinigameState();
}

class _SayiSiralaMinigameState extends State<SayiSiralaMinigame> {
  late List<int> sayilar;
  List<int> siralanan = [];
  bool bitti = false;

  @override
  void initState() {
    super.initState();
    sayilar = List.generate(5, (_) => Random().nextInt(90) + 10)..shuffle();
  }

  @override
  Widget build(BuildContext context) {
    List<int> dogruSira = [...sayilar]..sort();

    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  decoration: BoxDecoration(
    color: Colors.yellow.withValues(alpha: 0.15),
    borderRadius: BorderRadius.circular(20),
  ),
  child: const Text('⚡ MİNİGAME', style: TextStyle(color: Colors.yellow, fontSize: 13, letterSpacing: 3)),
),
            const SizedBox(height: 20),
            const Text('Küçükten Büyüğe!', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Sayıları sırayla seç', style: TextStyle(color: Colors.white54)),
            const SizedBox(height: 20),
            // Seçilen sıra
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(sayilar.length, (i) {
                return Container(
                  width: 55, height: 55,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.cyan.withValues(alpha: 0.5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      i < siralanan.length ? '${siralanan[i]}' : '',
                      style: const TextStyle(color: Colors.cyan, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 30),
            // Sayılar
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: sayilar.map((s) {
                bool secildi = siralanan.contains(s);
                return GestureDetector(
                  onTap: (bitti || secildi) ? null : () {
                    setState(() {
                      siralanan.add(s);
                      if (siralanan.length == sayilar.length) {
                        bitti = true;
                        bool dogru = siralanan.toString() == dogruSira.toString();
                        Future.delayed(const Duration(milliseconds: 600), () => widget.onBitis(dogru));
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 65, height: 65,
                    decoration: BoxDecoration(
                      color: secildi ? Colors.white12 : const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: secildi ? Colors.white12 : Colors.purple),
                    ),
                    child: Center(
                      child: Text('$s',
                          style: TextStyle(
                              color: secildi ? Colors.white24 : Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => setState(() => siralanan = []),
              child: const Text('Temizle', style: TextStyle(color: Colors.white38)),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== HAFIZA OYUNU MİNİGAME =====
class HafizaMinigame extends StatefulWidget {
  final Function(bool basarili) onBitis;
  const HafizaMinigame({super.key, required this.onBitis});

  @override
  State<HafizaMinigame> createState() => _HafizaMinigameState();
}

class _HafizaMinigameState extends State<HafizaMinigame> {
  final List<String> emojiler = ['🔋', '⚡', '🔌', '💡'];
  late List<String> kartlar;
  List<bool> acik = List.filled(8, false);
  List<bool> eslesti = List.filled(8, false);
  int? ilkSecilen;
  bool kontrol = false;
  int eslesenCift = 0;

  @override
  void initState() {
    super.initState();
    kartlar = [...emojiler, ...emojiler]..shuffle();
  }

  void kartaTikla(int i) async {
    if (kontrol || acik[i] || eslesti[i]) return;

    setState(() => acik[i] = true);

    if (ilkSecilen == null) {
      ilkSecilen = i;
    } else {
      kontrol = true;
      await Future.delayed(const Duration(milliseconds: 700));

      if (kartlar[ilkSecilen!] == kartlar[i]) {
        setState(() {
          eslesti[ilkSecilen!] = true;
          eslesti[i] = true;
          eslesenCift++;
        });
        if (eslesenCift == 4) widget.onBitis(true);
      } else {
        setState(() {
          acik[ilkSecilen!] = false;
          acik[i] = false;
        });
      }
      ilkSecilen = null;
      kontrol = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  decoration: BoxDecoration(
    color: Colors.yellow.withValues(alpha: 0.15),
    borderRadius: BorderRadius.circular(20),
  ),
  child: const Text('⚡ MİNİGAME', style: TextStyle(color: Colors.yellow, fontSize: 13, letterSpacing: 3)),
),
            const SizedBox(height: 20),
            const Text('Kartları Eşleştir!', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            Text('$eslesenCift/4 eşleşti', style: const TextStyle(color: Colors.white54, fontSize: 16)),
            const SizedBox(height: 30),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              children: List.generate(8, (i) {
                return GestureDetector(
                  onTap: () => kartaTikla(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: eslesti[i]
                          ? Colors.green.withValues(alpha: 0.3)
                          : acik[i]
                              ? const Color(0xFF1A1A2E)
                              : Colors.blue.shade900,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: eslesti[i] ? Colors.green : Colors.white24),
                    ),
                    child: Center(
                      child: Text(
                        acik[i] || eslesti[i] ? kartlar[i] : '❓',
                        style: const TextStyle(fontSize: 28),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== BOMBA İMHA MİNİGAME =====
class BombaImhaMinigame extends StatefulWidget {
  final Function(bool basarili) onBitis;
  const BombaImhaMinigame({super.key, required this.onBitis});

  @override
  State<BombaImhaMinigame> createState() => _BombaImhaMinigameState();
}

class _BombaImhaMinigameState extends State<BombaImhaMinigame> {
  final List<Color> kablolar = [Colors.red, Colors.blue, Colors.green, Colors.yellow, Colors.purple];
  late int dogruKablo;
  late String ipucu;
  bool bitti = false;
  int sure = 10;
  Timer? sureTimer;

  @override
  void initState() {
    super.initState();
    dogruKablo = Random().nextInt(5);
    final isimler = ['KIRMIZI', 'MAVİ', 'YEŞİL', 'SARI', 'MOR'];
    ipucu = isimler[dogruKablo];

    sureTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() => sure--);
      if (sure <= 0) {
        bitti = true;
        sureTimer?.cancel();
        widget.onBitis(false);
      }
    });
  }

  @override
  void dispose() {
    sureTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  decoration: BoxDecoration(
    color: Colors.yellow.withValues(alpha: 0.15),
    borderRadius: BorderRadius.circular(20),
  ),
  child: const Text('⚡ MİNİGAME', style: TextStyle(color: Colors.yellow, fontSize: 13, letterSpacing: 3)),
),
            const SizedBox(height: 12),
            const Text('💣 Bomba İmha!', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('$sure saniye',
                style: TextStyle(
                    color: sure <= 3 ? Colors.red : Colors.orange,
                    fontSize: 32,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('$ipucu kabloyu kes!',
                style: TextStyle(
                    color: kablolar[dogruKablo],
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    shadows: [const Shadow(color: Colors.black, blurRadius: 10)])),
            const SizedBox(height: 40),
            ...List.generate(5, (i) {
              return GestureDetector(
                onTap: bitti ? null : () {
                  setState(() => bitti = true);
                  sureTimer?.cancel();
                  Future.delayed(const Duration(milliseconds: 500), () => widget.onBitis(i == dogruKablo));
                },
                child: Container(
                  width: 200,
                  height: 20,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: kablolar[i],
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(color: kablolar[i].withValues(alpha: 0.6), blurRadius: 10, spreadRadius: 2)
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _PilKacagiMinigameState extends State<PilKacagiMinigame> {
  late int dogruIndex;
  List<bool> tiklanmis = List.filled(9, false);
  bool bitti = false;

  @override
  void initState() {
    super.initState();
    dogruIndex = Random().nextInt(9);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  decoration: BoxDecoration(
    color: Colors.yellow.withValues(alpha: 0.15),
    borderRadius: BorderRadius.circular(20),
  ),
  child: const Text('⚡ MİNİGAME', style: TextStyle(color: Colors.yellow, fontSize: 13, letterSpacing: 3)),
),
            const SizedBox(height: 12),
            const Text('Pil Kaçağını Bul!', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Hangi pil şarj kaybettiriyor?', style: TextStyle(color: Colors.white54)),
            const SizedBox(height: 40),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              children: List.generate(9, (i) {
                return GestureDetector(
                  onTap: bitti ? null : () {
                    setState(() {
                      tiklanmis[i] = true;
                      bitti = true;
                    });
                    Future.delayed(const Duration(milliseconds: 800), () {
                      widget.onBitis(i == dogruIndex);
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: tiklanmis[i]
                          ? (i == dogruIndex ? Colors.red : Colors.green)
                          : const Color(0xFF1A1A2E),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: tiklanmis[i] && i == dogruIndex
                              ? Colors.red
                              : Colors.white24),
                    ),
                    child: Center(
                      child: Text(
                        tiklanmis[i] && i == dogruIndex ? '💥' : '🔋',
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

// Minigame ekranı
class KabloPrizMinigame extends StatefulWidget {
  final Function(bool basarili) onBitis;
  const KabloPrizMinigame({super.key, required this.onBitis});

  @override
  State<KabloPrizMinigame> createState() => _KabloPrizMinigameState();
}

class _KabloPrizMinigameState extends State<KabloPrizMinigame> {
  // 4 kablo rengi, biri doğru
  final List<Color> renkler = [Colors.red, Colors.blue, Colors.yellow, Colors.green];
  late int dogruIndex;
  int? secilenIndex;
  bool bitti = false;

  @override
  void initState() {
    super.initState();
    dogruIndex = Random().nextInt(4);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           Container(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  decoration: BoxDecoration(
    color: Colors.yellow.withValues(alpha: 0.15),
    borderRadius: BorderRadius.circular(20),
  ),
  child: const Text('⚡ MİNİGAME', style: TextStyle(color: Colors.yellow, fontSize: 13, letterSpacing: 3)),
),
            const SizedBox(height: 12),
            const Text('Doğru kabloyu tak!',
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
  dogruIndex == 0 ? "KIRMIZI" : dogruIndex == 1 ? "MAVİ" : dogruIndex == 2 ? "SARI" : "YEŞİL",
  style: TextStyle(
    color: renkler[dogruIndex],
    fontSize: 24,
    fontWeight: FontWeight.bold,
    shadows: [
      Shadow(color: Colors.black, blurRadius: 10, offset: Offset(2, 2))
    ],
  ),
),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (i) {
                return GestureDetector(
                  onTap: bitti ? null : () {
                    setState(() {
                      secilenIndex = i;
                      bitti = true;
                    });
                    Future.delayed(const Duration(milliseconds: 800), () {
                      widget.onBitis(i == dogruIndex);
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 60,
                    height: 120,
                    decoration: BoxDecoration(
                      color: secilenIndex == i
                          ? (i == dogruIndex ? Colors.green : Colors.red)
                          : renkler[i],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: renkler[i].withValues(alpha: 0.6),
                          blurRadius: 15,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _OyunEkraniState extends State<OyunEkrani> {
  double sarj = 100.0;
  bool cooldownAktif = false;
  int skor = 0;
  bool oyunBitti = false;
  bool kabloAnimasyonAktif = false;
  Set<int> gonderilmisBildirimler = {};
  bool minigameAktif = false; int aktifMinigame = 0;
  Timer? minigameTimer;

  Timer? sarjTimer;
  Timer? skorTimer;

  @override
  void initState() {
    super.initState();
    oyunuBaslat();
  }

  void minigameBitis(bool basarili) {
  setState(() {
    minigameAktif = false;
    if (basarili) {
      sarj += 20;
      if (sarj > 100) sarj = 100;
    } else {
      sarj -= 10;
      if (sarj < 0) sarj = 0;
    }
  });
}

  void oyunuBaslat() {
    sarjTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {
        setState(() {
          sarj -= 0.1;

          if (sarj <= 0) {
            sarj = 0;
            oyunBitti = true;
            sarjTimer?.cancel();
            skorTimer?.cancel();
          }
        });
      },
    );

    skorTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() => skor++);
      },
    );

    // Şarj %50 altındayken rastgele minigame çıkar
  minigameTimer = Timer.periodic(
  const Duration(seconds: 1),
  (timer) {
    if (sarj < 50 && !minigameAktif && !oyunBitti) {
      // %5 ihtimalle her saniye minigame açılır
      // Skor arttıkça ihtimal artar
// Başta 1/20, 60 skorda 1/10, 120 skorda 1/5
int aralik = (20 - (skor / 10).floor()).clamp(5, 20);
if (Random().nextInt(aralik) == 0) {
        setState(() {
  minigameAktif = true;
  aktifMinigame = Random().nextInt(11);
});
      }
    }
  },
);
  }

  void kabloIttir() {
  if (oyunBitti || cooldownAktif) return;
  setState(() {
    cooldownAktif = true;
    kabloAnimasyonAktif = true;
    sarj += 1.5;
    if (sarj > 100.0) sarj = 100.0;
  });
  Future.delayed(const Duration(milliseconds: 500), () {
    if (mounted) setState(() {
      kabloAnimasyonAktif = false;
      cooldownAktif = false;
    });
  });
}

  void oyunuYenile() {
    sarjTimer?.cancel();
    skorTimer?.cancel();
    setState(() {
      sarj = 100.0;
      skor = 0;
      oyunBitti = false;
      kabloAnimasyonAktif = false;
      gonderilmisBildirimler = {};
      minigameAktif = false;
    });
    oyunuBaslat();
  }

  @override
  void dispose() {
    sarjTimer?.cancel();
    skorTimer?.cancel();
    super.dispose();
    minigameTimer?.cancel();
  }

  Color sarjRengi() {
    if (sarj > 50) return Colors.green;
    if (sarj > 20) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xFF0D0D0D),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text('SKOR: $skor',
                      style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2)),
                ),

                const Spacer(),

                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 160,
                      height: 300,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A1A1A),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            color: sarjRengi().withValues(alpha: 0.5), width: 3),
                        boxShadow: [
                          BoxShadow(
                              color: sarjRengi().withValues(alpha: 0.3),
                              blurRadius: 30,
                              spreadRadius: 5),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            sarj > 20
                                ? Icons.battery_charging_full
                                : Icons.battery_alert,
                            color: sarjRengi(),
                            size: 60,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            oyunBitti ? '💀' : '%${sarj.toStringAsFixed(0)}',
                            style: TextStyle(
                                color: sarjRengi(),
                                fontSize: 36,
                                fontWeight: FontWeight.bold),
                          ),
                          if (oyunBitti)
                            const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text('TELEFON\nKAPANDI',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                            ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: -40,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: kabloAnimasyonAktif ? 12 : 8,
                        height: 50,
                        decoration: BoxDecoration(
                          color: kabloAnimasyonAktif
                              ? Colors.white
                              : Colors.grey.shade600,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: kabloAnimasyonAktif
                              ? [
                                  BoxShadow(
                                      color: Colors.white.withValues(alpha: 0.8),
                                      blurRadius: 10,
                                      spreadRadius: 2)
                                ]
                              : [],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: sarj / 100,
                          minHeight: 16,
                          backgroundColor: Colors.white12,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(sarjRengi()),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('Şarj Seviyesi',
                          style: TextStyle(
                              color: Colors.white38,
                              fontSize: 12,
                              letterSpacing: 2)),
                    ],
                  ),
                ),

                const Spacer(),

                if (!oyunBitti)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                    child: GestureDetector(
                      onTap: kabloIttir,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          color: kabloAnimasyonAktif
                              ? Colors.green.shade300
                              : Colors.green.shade700,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withValues(
                                  alpha: kabloAnimasyonAktif ? 0.6 : 0.3),
                              blurRadius: kabloAnimasyonAktif ? 30 : 10,
                              spreadRadius: kabloAnimasyonAktif ? 5 : 2,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text('⚡ Kabloyu İttir!',
                              style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      ),
                    ),
                  ),

                if (oyunBitti)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                    child: Column(
                      children: [
                        const Text('OYUN BİTTİ',
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 4)),
                        const SizedBox(height: 8),
                        Text('Skorun: $skor saniye',
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 18)),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: oyunuYenile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white12,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Tekrar Oyna',
                              style: TextStyle(fontSize: 18)),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),

        // Minigame üste açılır
        if (minigameAktif)
  [
    KabloPrizMinigame(onBitis: minigameBitis),
    MatematikMinigame(onBitis: minigameBitis),
    DusenPilMinigame(onBitis: minigameBitis),
    SimonSaysMinigame(onBitis: minigameBitis),
    SifreKirmaMinigame(onBitis: minigameBitis),
    Dengeminigame(onBitis: minigameBitis),
    PilKacagiMinigame(onBitis: minigameBitis),
    HizliYazMinigame(onBitis: minigameBitis),
    KelimeBulMinigame(onBitis: minigameBitis),
    SayiSiralaMinigame(onBitis: minigameBitis),
    HafizaMinigame(onBitis: minigameBitis),
    BombaImhaMinigame(onBitis: minigameBitis),
  ][aktifMinigame],
      ],
    );
  }
}