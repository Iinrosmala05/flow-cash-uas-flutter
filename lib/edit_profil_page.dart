import 'package:flutter/material.dart';
import 'db_helper.dart';

class EditProfilPage extends StatefulWidget{
  final String currentName;
  final double currentBalance;

  EditProfilPage({required this.currentName, required this.currentBalance});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilPage> {
  late TextEditingController _nameController;
  late TextEditingController _balanceController;

  @override
  void initState(){
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
    _balanceController = TextEditingController(text: widget.currentBalance.toInt().toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profil", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF1D2631),
        elevation: 0,
      ),
      backgroundColor: Color(0xFF121A21), 
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent.withOpacity(0.2),
              child: Icon(Icons.person, size: 50, color: Colors.blueAccent),
            ),
            SizedBox(height: 30),
           
            TextField(
              controller: _nameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Nama Pengguna",
                labelStyle: TextStyle(color: Colors.blueAccent),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
              ),
            ),
            SizedBox(height: 20),
    
            TextField(
              controller: _balanceController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Saldo Awal",
                labelStyle: TextStyle(color: Colors.blueAccent),
                prefixText: "Rp ",
                prefixStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.blueAccent)),
              ),
            ),
            SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  String namaInput = _nameController.text;
                  double saldoInput = double.tryParse(_balanceController.text) ?? 0.0;
                  
                  await DatabaseHelper.instance.updateUser(namaInput, saldoInput);

                  if (mounted) {
                    Navigator.pop(context, true); 
                  } 
                },
                child: Text("Simpan Perubahan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}