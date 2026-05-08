import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const FlowCashApp());

class FlowCashApp extends StatelessWidget {
  const FlowCashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends
State<SplashScreen> {
  @override
  void initState(){
  super.initState();
    Future.delayed(const Duration(seconds: 6), () {
      Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const InitialSetupPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.account_balance_wallet, size: 100, color: Colors.blueAccent),
            SizedBox(height: 20),
            Text("FLOWCASH", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 4)),
            SizedBox(height: 10),
            CircularProgressIndicator(color: Colors.blueAccent),
          ],
        ),
      ),
    );
  }
}

class InitialSetupPage extends StatefulWidget{
  const InitialSetupPage({super.key});

  @override
  State<InitialSetupPage> createState() => _InitialSetupPageState();
}

class _InitialSetupPageState extends State<InitialSetupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: AlignmentGeometry.bottomCenter,
            colors: [Color(0xFF0F2027), Color(0xFF203A43)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Halo! Kenalan Yuk", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),),
            const SizedBox(height: 30),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Nama Kamu",
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 20) ,
            TextField(
              controller: _balanceController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Saldo Awal (Rp )",
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  if (_nameController.text.isNotEmpty && _balanceController.text.isNotEmpty) {
                    Navigator.pushReplacement(
                      context, MaterialPageRoute(
                        builder: (context) =>
                        DashboardPremium(
                          userNama: _nameController.text,
                          saldoAwal: int.parse(_balanceController.text),
                        ),
                      ),
                    );
                  }
                },
                child: const Text("MULAI APLIKASI", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 

class DashboardPremium extends StatefulWidget {
  final String userNama;
  final int saldoAwal;
  
  const DashboardPremium({super.key, required this.userNama, required this.saldoAwal});

  @override
  State<DashboardPremium> createState() => _DashboardPremiumState();
}

class _DashboardPremiumState extends State<DashboardPremium> {
  late int totalSaldo;
  List<Map<String, dynamic>> transactions = [];

  @override
  void initState(){
    super.initState();
    totalSaldo = widget.saldoAwal;
  }
  
  String formatWaktu(dynamic waktu) {
    if (waktu == null || waktu is String) return "Baru Saja";

    DateTime waktuData = waktu as DateTime;
    DateTime sekarang = DateTime.now();
    Duration selisih = sekarang.difference(waktuData);

    if (selisih.inMinutes < 1) return "Baru Saja";
    if (selisih.inHours < 24 && waktuData.day == sekarang.day) return "Hari Ini";
    if (selisih.inHours < 48 && waktuData.day == sekarang.day -1) return "Kemaren";

    return "${waktuData.day}/${waktuData.month}/${waktuData.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: AlignmentGeometry.bottomRight,
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Selamat Datang",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Text(widget.userNama,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25),
                  padding: const EdgeInsets.all(25),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00B4DB), Color(0xFF0083B0)],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Rp ${totalSaldo.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    "Riwayat Transaksi",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) {
                          setState(() {
                            String nominalString = transactions[index]['amount']
                                .toString();
                            String hanyaAngka = nominalString.replaceAll(
                              RegExp(r'[^0-9]'),'',
                            );
                            int angkaTransaksi = int.tryParse(hanyaAngka) ?? 0;

                            totalSaldo = totalSaldo + angkaTransaksi;
                            transactions.removeAt(index);
                          });
                        },
                        child: Card(
                          color: Colors.white.withOpacity(0.05),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  (transactions[index]['color'] as Color)
                                      .withOpacity(0.2),
                              child: Icon(
                                transactions[index]['icon'] as IconData,
                                color: transactions[index]['color'] as Color,
                              ),
                            ),
                            title: Text(
                              transactions[index]['title'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              formatWaktu(transactions[index]['time']),
                              style: const TextStyle(color: Colors.white54, fontSize: 12),
                            ),
                            trailing: Text(
                              transactions[index]['amount'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(d{3})+(?!d))'), (Match m) => '${m[1]}.'),
                              style: const TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTransactionPage()),
          );
          if (result != null) {
            setState(() {
              transactions.insert(0, result);

              String nominalString = result['amount'].toString();
              String hanyaAngka = nominalString.replaceAll(
                RegExp(r'[^0-9]'),'',
              );
              int angka = int.tryParse(hanyaAngka) ?? 0;

              if (result['type'] == "Masuk") {
                totalSaldo += angka;
              } else {
                totalSaldo -= angka;
              }
            });
          }
        },
        backgroundColor: const Color(0xFF2C5364),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  String selectedCategory = "";
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _otherController = TextEditingController();
  bool isOtherSelected = false;

  String type = "Keluar";

  Widget _typeButton(String label, Color color) {
    bool isSelected = type == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          type = label;
          isOtherSelected = false;
          selectedCategory = "";
          _otherController.clear();
        }),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color: Colors.white10,
            borderRadius: BorderRadius.circular(12),
            border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
          ),
            child: Center(
              child: Text(label, style: const TextStyle(color: Colors.white)),
            ), 
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tambah Transaksi",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0F2027),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: const EdgeInsets.all(25),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F2027), Color(0xFF203A43)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _typeButton("Masuk", Colors.green), const SizedBox(width: 10),
                _typeButton("Keluar", Colors.redAccent),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Nominal", style: TextStyle(color: Colors.white54),
            ),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 45,
                fontWeight: FontWeight.bold,
              ),
              cursorColor: Colors.white,
              decoration: const InputDecoration(
                prefixText: "Rp ",
                prefixStyle: TextStyle(color: Colors.white, fontSize: 45),
                border: InputBorder.none,
                hintText: "0",
                hintStyle: TextStyle(color: Colors.white24),
              ),
            ),
            const SizedBox(height: 30),
            const Text("Kategori", style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 15),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                if (type == "Keluar")...[
                  _categoryIcon(Icons.fastfood, "Makan"),
                  _categoryIcon(Icons.directions_car, "Transport"),
                  _categoryIcon(Icons.shopping_bag, "Belanja"),
                ] else ...[
                  _categoryIcon(Icons.payments, "Gaji"),
                  _categoryIcon(Icons.account_balance_wallet, "Saku"),
                  _categoryIcon(Icons.savings, "Tabungan"),
                ],
                _categoryIcon(Icons.add_circle_outline, "Lainnya"),
              ],
            ),
            if (isOtherSelected)
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _otherController,
                autofocus: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Ketik Keperluan disini...",
                  hintStyle: TextStyle(color: Colors.white24),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C5364),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  String isiNominal = _amountController.text;

                  if (isiNominal.isEmpty || selectedCategory.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Isi nominal dan pilih kategori dulu ya!",
                        ),
                      ),
                    );
                  } else {
                    String finalTitle = (isOtherSelected && _otherController.text.isNotEmpty) ? _otherController.text: selectedCategory;
                    Navigator.pop(context, {
                      "title": finalTitle,
                      "amount": (type == "Masuk" ? "+ " : "- ") + "Rp ${_amountController.text}",
                      "type": type,
                      "icon": isOtherSelected ?
                              Icons.edit_note: (selectedCategory == "Makan" ?
                              Icons.fastfood: selectedCategory == "Transport" ?
                              Icons.directions_car: selectedCategory == "Belanja" ?
                              Icons.shopping_bag: selectedCategory == "Saku" ?
                              Icons.account_balance_wallet: selectedCategory == "Gaji" ?
                              Icons.payments: selectedCategory == "Tabungan" ? 
                              Icons.savings: Icons.category),
                      "color": type == "Masuk" ? Colors.green: Colors.redAccent,
                      "time": DateTime.now(),
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Mantap! Transaksi $finalTitle berhasil dicatat",
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: const Text(
                  "SIMPAN TRANSAKSI",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryIcon(IconData icon, String label) {
    bool isSelected = selectedCategory == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = label;
          if (label == "Lainnya") {
            isOtherSelected = true;
          } else {
            isOtherSelected = false;
          }
        });
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.blueAccent
                  : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: isSelected
                  ? Border.all(color: Colors.white, width: 2)
                  : null,
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white60,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
