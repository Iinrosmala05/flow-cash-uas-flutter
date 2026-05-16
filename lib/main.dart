import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'db_helper.dart';
import 'edit_profil_page.dart';
import 'package:sqflite/sqflite.dart';

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

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 6), () async {
      final prefs = await SharedPreferences.getInstance();
      final String? nama = prefs.getString('userNama');
      final int? saldo = prefs.getInt('totalSaldo');

      if (nama != null && saldo != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                DashboardPremium(userNama: nama, saldoAwal: saldo),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const InitialSetupPage()),
        );
      }
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
            Icon(
              Icons.account_balance_wallet,
              size: 100,
              color: Colors.blueAccent,
            ),
            SizedBox(height: 20),
            Text(
              "FLOWCASH",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(color: Colors.blueAccent),
          ],
        ),
      ),
    );
  }
}

class InitialSetupPage extends StatefulWidget {
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
            const Text(
              "Halo! Kenalan Yuk",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Nama Kamu",
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _balanceController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                ThousandSeparatorFormatter(),
              ],
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Saldo Awal (Rp )",
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () async {
                  if (_nameController.text.isNotEmpty &&
                      _balanceController.text.isNotEmpty) {
                    final prefs = await SharedPreferences.getInstance();
                    String namaInput = _nameController.text;
                    int saldoInput = int.parse(
                      _balanceController.text.replaceAll('.', ''),
                    );

                    await prefs.setString('userNama', namaInput);
                    await prefs.setInt('totalSaldo', saldoInput);

                    final db = await DatabaseHelper.instance.database;
                    await db.insert('user', {
                      'id': 1,
                      'name': namaInput,
                      'balance': saldoInput.toDouble(),
                    }, conflictAlgorithm: ConflictAlgorithm.replace);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DashboardPremium(
                          userNama: namaInput,
                          saldoAwal: saldoInput,
                        ),
                      ),
                    );
                  }
                },
                child: const Text(
                  "MULAI APLIKASI",
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
}

class DashboardPremium extends StatefulWidget {
  final String userNama;
  final int saldoAwal;

  const DashboardPremium({
    super.key,
    required this.userNama,
    required this.saldoAwal,
  });

  @override
  State<DashboardPremium> createState() => _DashboardPremiumState();
}

class _DashboardPremiumState extends State<DashboardPremium> {
  late int totalSaldo;
  String? displayNama;
  List<Map<String, dynamic>> transactions = [];

  double? saldoDatabase;

  String selectedFilter = "Semua";

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    displayNama = widget.userNama;
    totalSaldo = widget.saldoAwal;
    _refreshTransactions();
  }

  Map<String, double> hitungDataGrafik() {
    Map<String, double> dataMap = {};

    for (var item in transactions) {
      String kategori = item['category'].toString().trim();
      double nominal = (item['amount'] as int).toDouble();

      if (nominal > 0) {
        if (dataMap.containsKey(kategori)) {
          dataMap[kategori] = dataMap[kategori]! + nominal;
        } else {
          dataMap[kategori] = nominal;
        }
      }
    }
    if (dataMap.isEmpty) return {"Belum Ada Data": 0};
    return dataMap;
  }

  void _refreshTransactions() async {
    final data = await DatabaseHelper.instance.queryAllTransactions();
    final db = await DatabaseHelper.instance.database;
    final userData = await db.query('user', where: 'id = ?', whereArgs: [1]);

    setState(() {
      transactions = data.where((t) {
        bool matchType = (selectedFilter == "Semua") || (t['type'] == selectedFilter);
        bool matchSearch = (t['name'] ?? '').toString().toLowerCase().contains(_searchQuery.toLowerCase());
        return matchType && matchSearch;
      }).toList();

      if (userData.isNotEmpty) {
        displayNama = userData.first['name'].toString();
        saldoDatabase = (userData.first['balance'] as double);
      }

      double hitungSaldo = saldoDatabase ?? widget.saldoAwal.toDouble();
      for (var item in data) {
        if (item['type'] == 'Masuk') {
          hitungSaldo += item['amount'] as int;
        } else {
          hitungSaldo -= item['amount'] as int;
        }
      }
      totalSaldo = hitungSaldo.toInt();
    });
  }

  String formatWaktu(String dateString) {
    DateTime date = DateTime.parse(dateString);
    DateTime now = DateTime.now();

    String tanggalAsli = "${date.day}/${date.month}/${date.year}";

    final diff = now
        .difference(DateTime(date.year, date.month, date.day))
        .inDays;

    if (diff == 0) {
      return "Hari ini ($tanggalAsli)";
    } else if (diff == 1) {
      return "Kemarin ($tanggalAsli)";
    } else {
      return tanggalAsli;
    }
  }

  Widget _buildFilterChip(String label) {
    bool isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
        _refreshTransactions();
      },
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center, 
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent : Colors.white10,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: Colors.white, width: 1) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white60,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
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
                          Text(
                            displayNama ?? widget.userNama,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          final refresh = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfilPage(
                                currentName: displayNama ?? widget.userNama,
                                currentBalance:
                                    (saldoDatabase ??
                                            widget.saldoAwal.toDouble())
                                        .toInt()
                                        .toDouble(),
                              ),
                            ),
                          );

                          if (refresh == true) {
                            _refreshTransactions();
                          }
                        },
                        child: const CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white24,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
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
                        "Rp ${totalSaldo.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                        _refreshTransactions();
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Cari riwayat transaksi...",
                        hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
                        prefixIcon: const Icon(Icons.search, color: Colors.white54),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                PieChart(
                  dataMap: hitungDataGrafik(),
                  animationDuration: const Duration(milliseconds: 800),
                  chartRadius: MediaQuery.of(context).size.width / 3.2,
                  colorList: const [
                    Colors.orange,
                    Colors.blue,
                    Colors.purple,
                    Colors.green,
                    Colors.redAccent,
                    Colors.teal,
                  ],
                  chartType: ChartType.ring,
                  legendOptions: const LegendOptions(
                    showLegends: true,
                    legendPosition: LegendPosition.right,
                    legendTextStyle: TextStyle(color: Colors.white),
                  ),
                  chartValuesOptions: const ChartValuesOptions(
                    showChartValuesInPercentage: true,
                    showChartValues: true,
                  ),
                ),
                const SizedBox(height: 40),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      _buildFilterChip("Semua"),
                      const SizedBox(width: 10),
                      _buildFilterChip("Masuk"),
                      const SizedBox(width: 10),
                      _buildFilterChip("Keluar"),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

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
                      IconData itemIcon = Icons.edit_note;
                      Color itemColor = transactions[index]['type'] == 'Masuk'
                          ? Colors.green
                          : Colors.redAccent;

                      if (transactions[index]['category'] == 'Makan') {
                        itemIcon = Icons.fastfood;
                      } else if (transactions[index]['category'] ==
                          'Transport') {
                        itemIcon = Icons.directions_car;
                      } else if (transactions[index]['category'] == 'Belanja') {
                        itemIcon = Icons.shopping_bag;
                      } else if (transactions[index]['category'] == 'Gaji') {
                        itemIcon = Icons.payments;
                      } else if (transactions[index]['category'] == 'Saku') {
                        itemIcon = Icons.account_balance_wallet;
                      } else if (transactions[index]['category'] ==
                          'Tabungan') {
                        itemIcon = Icons.savings;
                      } else if (transactions[index]['category'] == 'Lainnya') {
                        itemIcon = Icons.receipt_long;
                      } else {
                        itemIcon = Icons.category;
                      }
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) async {
                          int id = transactions[index]['id'];
                          await DatabaseHelper.instance.deleteTransaction(id);
                          _refreshTransactions();
                        },
                        child: Card(
                          color: Colors.white.withOpacity(0.05),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: itemColor.withOpacity(0.2),
                              child: Icon(itemIcon, color: itemColor),
                            ),
                            title: Text(
                              transactions[index]['name'] ?? 'Tanpa Nama',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              formatWaktu(transactions[index]['date']),
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),
                            trailing: Text(
                              "Rp ${transactions[index]['amount'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
                              style: TextStyle(
                                color: itemColor,
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
            await DatabaseHelper.instance.insertTransaction({
              'name': result['title'],
              'amount': int.parse(
                result['amount'].toString().replaceAll(RegExp(r'[^0-9]'), ''),
              ),
              'type': result['type'],
              'category': result['icon'] == Icons.edit_note
                  ? "Lainnya"
                  : result['title'],
              'date': DateTime.now().toString(),
            });

            _refreshTransactions();
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
            color: isSelected ? color : Colors.white10,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: Colors.white, width: 2)
                : null,
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
                _typeButton("Masuk", Colors.green),
                const SizedBox(width: 10),
                _typeButton("Keluar", Colors.redAccent),
              ],
            ),
            const SizedBox(height: 20),
            const Text("Nominal", style: TextStyle(color: Colors.white54)),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                ThousandSeparatorFormatter(),
              ],
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
                if (type == "Keluar") ...[
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
                  String cleanNominal = _amountController.text.replaceAll(
                    '.',
                    '',
                  );

                  if (cleanNominal.isEmpty || selectedCategory.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Isi nominal dan pilih kategori dulu ya!",
                        ),
                      ),
                    );
                  } else {
                    String finalTitle =
                        (isOtherSelected && _otherController.text.isNotEmpty)
                        ? _otherController.text
                        : selectedCategory;
                    Navigator.pop(context, {
                      "title": finalTitle,
                      "amount":
                          (type == "Masuk" ? "+ " : "- ") +
                          "Rp ${_amountController.text}",
                      "type": type,
                      "icon": isOtherSelected
                          ? Icons.edit_note
                          : (selectedCategory == "Makan"
                                ? Icons.fastfood
                                : selectedCategory == "Transport"
                                ? Icons.directions_car
                                : selectedCategory == "Belanja"
                                ? Icons.shopping_bag
                                : selectedCategory == "Saku"
                                ? Icons.account_balance_wallet
                                : selectedCategory == "Gaji"
                                ? Icons.payments
                                : selectedCategory == "Tabungan"
                                ? Icons.savings
                                : Icons.category),
                      "color": type == "Masuk"
                          ? Colors.green
                          : Colors.redAccent,
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

class ThousandSeparatorFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.selection.baseOffset == 0) return newValue;
    String text = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final chars = text.split('');
    String newString = '';
    for (int i = 0; i < chars.length; i++) {
      if (i > 0 && (chars.length - i) % 3 == 0) {
        newString += '.';
      }
      newString += chars[i];
    }
    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
}
