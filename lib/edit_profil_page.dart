import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'package:flutter/services.dart';

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
    String saldoMentah = widget.currentBalance.toInt().toString();
    _balanceController = TextEditingController(text: formatTitikManual(saldoMentah));
  }

  String formatTitikManual(String value) {
    if (value.isEmpty) return "";
    String text = value.replaceAll(RegExp(r'[^0-9]'), '');
    final chars = text.split('');
    String newString = '';
    for (int i = 0; i < chars.length; i++) {
      if (i > 0 && (chars.length - i) % 3 == 0) {
        newString += '.';
      }
      newString += chars[i];
    }
    return newString;
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
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                ThousandSeparatorFormatter(), 
                ],
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
                String cleanSaldo = _balanceController.text.replaceAll('.', '');
                double saldoInput = double.tryParse(cleanSaldo) ?? 0.0;
                
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

class ThousandSeparatorFormatter extends TextInputFormatter {
  @override 
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
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