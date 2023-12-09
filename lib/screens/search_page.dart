import 'package:flutter/material.dart';

class Biodata {
  int id;
  String name;
  String email;
  String gender;
  DateTime birthday;
  String phoneNumber;

  Biodata({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.birthday,
    required this.phoneNumber,
  });
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Contoh data biodata (Anda dapat menggantinya dengan data aktual dari pengguna)
  Biodata biodata = Biodata(
    id: 1,
    name: "John Doe",
    email: "john.doe@example.com",
    gender: "Male",
    birthday: DateTime(1990, 1, 1),
    phoneNumber: "1234567890",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.black,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Account Information',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Card(
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${biodata.name}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text('${biodata.phoneNumber}'),
                      Text('${biodata.email}'),
                      SizedBox(height: 8),
                      Align(
                        alignment: Alignment.center,
                        child: FractionallySizedBox(
                          widthFactor: 1.0, // Set to 1.0 to make it fill the available width
                          child: ElevatedButton(
                            onPressed: () {
                              _showEditBiodataDialog(context);
                            },
                            child: Text('Edit Biodata'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40),
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet,
                    size: 30,
                    color: Colors.black,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Balance',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Card(
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Rp100.00',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Align(
                        alignment: Alignment.center,
                        child: FractionallySizedBox(
                          widthFactor: 1.0, //
                          child: ElevatedButton(
                            onPressed: () {
                              // Aksi yang dijalankan saat tombol ditekan
                              // Contoh: Menampilkan dialog untuk top-up saldo
                              _showTopUpDialog(context);
                            },
                            child: Text('Top-Up Wallet'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showTopUpDialog(BuildContext context) async {
    // List of available payment methods
    List<String> paymentMethods = ['Credit Card', 'Bank Transfer', 'e-Wallet'];

    // Selected payment method (initialize with the first method)
    String selectedPaymentMethod = paymentMethods[0];

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
                  'Top-Up Wallet',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Masukkan jumlah saldo yang ingin di-top up:'),
                SizedBox(height: 10),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Jumlah Saldo'),
                  onChanged: (value) {
                    // Update saldoWallet sesuai input pengguna
                    // saldoWallet = double.tryParse(value) ?? saldoWallet;
                  },
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Payment Method',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: FractionallySizedBox(
                    widthFactor: 0.78, // Sesuaikan faktor lebar sesuai kebutuhan
                    child: DropdownMenu<String>(
                      initialSelection: selectedPaymentMethod,
                      onSelected: (String? newValue) {
                        setState(() {
                          selectedPaymentMethod = newValue!;
                        });
                      },
                      dropdownMenuEntries: paymentMethods.map<DropdownMenuEntry<String>>((String value) {
                        return DropdownMenuEntry<String>(value: value, label: value);
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                // Lakukan proses top-up atau panggil fungsi top-up sesuai kebutuhan
                // Contoh: _topUpWallet(selectedPaymentMethod);
                print(selectedPaymentMethod);
                Navigator.of(context).pop();
              },
              child: Text('Top-Up'),
            ),
          ],
        );
      },
    );
  }


  // Fungsi untuk menampilkan dialog edit biodata
  Future<void> _showEditBiodataDialog(BuildContext context) async {
    // Contoh controller untuk menerima input dari pengguna
    TextEditingController nameController = TextEditingController(text: biodata.name);
    TextEditingController emailController = TextEditingController(text: biodata.email);
    TextEditingController genderController = TextEditingController(text: biodata.gender);
    TextEditingController birthdayController = TextEditingController(text: biodata.birthday.toString());
    TextEditingController phoneNumberController = TextEditingController(text: biodata.phoneNumber);

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Biodata'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: genderController,
                  decoration: InputDecoration(labelText: 'Gender'),
                ),
                TextField(
                  controller: birthdayController,
                  decoration: InputDecoration(labelText: 'Birthday'),
                ),
                TextField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                // Lakukan proses penyimpanan biodata sesuai input pengguna
                setState(() {
                  biodata.name = nameController.text;
                  biodata.email = emailController.text;
                  biodata.gender = genderController.text;
                  biodata.birthday = DateTime.parse(birthdayController.text);
                  biodata.phoneNumber = phoneNumberController.text;
                });
                Navigator.of(context).pop();
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}
