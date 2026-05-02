import 'package:flutter/material.dart';

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

class DashboardPremium extends StatelessWidget{
  const DashboardPremium({super.key});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Selamat Datang", style: TextStyle(color: Colors.white, fontSize: 16)),
                        Text("Iin Rosmala", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.person, color: Colors.white),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  gradient: LinearGradient(
                    colors: [Colors.white.withOpacity(0.2), Colors.white.withOpacity(0.05)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 20,
                      right: 20,
                      child: Icon(Icons.contactless,
                      color: Colors.white.withOpacity(0.5), size: 40),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text("TOTAL SALDO", style: TextStyle(color: Colors.white70, letterSpacing: 2)),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              _infoTab("Masuk", "Rp 5jt"),
                              const SizedBox(width: 30),
                              _infoTab("Keluar", "Rp 1.2jt"),
                            ],
                          )
                        ],
                      ), 
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 30, left: 25, right: 25 ),
                  decoration: const BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Transaksi Terakhir", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text("Lihat Semua", style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: ListView(
                          children: [
                            _transactionItem("Makan Siang", "27 Apr", "Rp 50.000", Icons.fastfood, Colors.orange),
                            _transactionItem("Gaji Project", "25 Apr", "+ Rp 2.000.000", Icons.work, Colors.green),
                            _transactionItem("Nonton Bioskop", "21 Apr", "Rp 45.000", Icons.movie, Colors.red),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddTransactionPage()),
          );
        },
        backgroundColor: const Color(0xFF2C5364),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _infoTab(String label,String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _transactionItem(String title, String date, String amount, IconData icon, Color color) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15)),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(date),
      trailing: Text(amount, style: TextStyle(fontWeight: FontWeight.bold, color: amount.contains('+') ? Colors.green : Colors.black)),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Transaksi", style: TextStyle(color: Colors.white)),
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
            const Text("Nominal Pengeluaran", style: TextStyle(color: Colors.white70)),
            const TextField(
              autofocus: true,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: "Rp 0",
                hintStyle: TextStyle(color: Colors.white24),
                border: InputBorder.none,
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(15)),
                ),
                onPressed:() { Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Mantap! Transaksi $selectedCategory berhasil dicatat"),
                    backgroundColor: Colors.green,
                  ),
                );
              }, 
              child: const Text("SIMPAN TRANSAKSI", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    ),
  );
}
Widget _categoryIcon (IconData icon, String label) {
    bool isSelected = selectedCategory == label;

    return GestureDetector(
      onTap: () {
        setState((){
          selectedCategory = label;
        });
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
            color: isSelected ? Colors.blueAccent : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
            ),
          child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white60,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
            )
          ),
        ],
      ),
    );
  }
}

 