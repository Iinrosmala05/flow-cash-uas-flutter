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
      home: const DashboardPremium(),
    );
  }
}

class DashboardPremium extends StatefulWidget {
  const DashboardPremium({super.key});

  @override
  State<DashboardPremium> createState() => _DashboardPremiumState();
}

class _DashboardPremiumState extends State<DashboardPremium> {
  int totalSaldo = 10500000;
  List<Map<String, dynamic>> transactions = [
    {
      "title": "Makan Siang",
      "amount": "Rp 25.000",
      "icon": Icons.fastfood,
      "color": Colors.orange,
    },
    {
      "title": "Beli Bensin",
      "amount": "Rp 50.000",
      "icon": Icons.directions_car,
      "color": Colors.blue,
    },
  ];

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
                            "Iin Rosmala",
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
                    children:[
                      Text(
                        "Rp ${totalSaldo.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),(Match m) => '${m[1]}.')}",
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
                      return Card(
                        color: Colors.white.withOpacity(0.05),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: transactions[index]['color']
                                .withOpacity(0.2),
                            child: Icon(
                              transactions[index]['icon'],
                              color: transactions[index]['color'],
                            ),
                          ),
                          title: Text(
                            transactions[index]['title'],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: const Text(
                            "Hari Ini",
                            style: TextStyle(color: Colors.white54),
                          ),
                          trailing: Text(
                            transactions[index]['amount'],
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
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
              String hanyaAngka= nominalString.replaceAll(RegExp(r'[^[0-9]'),'');
              int angkaTransaksi = int.tryParse(hanyaAngka) ?? 0;
              totalSaldo = totalSaldo - angkaTransaksi;
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
            const Text(
              "Nominal Pengeluaran",
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 10),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _categoryIcon(Icons.fastfood, "makan"),
                _categoryIcon(Icons.directions_car, "Transport"),
                _categoryIcon(Icons.shopping_bag, "Belanja"),
              ],
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
                    Navigator.pop(context, {
                      "title": selectedCategory,
                      "amount": "Rp ${_amountController.text}",
                      "icon": selectedCategory == "makan" ? Icons.fastfood: (selectedCategory == "Transport" ?Icons.directions_car: Icons.shopping_bag),
                      "color": selectedCategory== "makan" ? Colors.orange: (selectedCategory == "Transport" ? Colors.blue: Colors.pink),
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Mantap! Transaksi $selectedCategory berhasil dicatat"),
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
