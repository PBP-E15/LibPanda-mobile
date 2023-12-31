import 'package:flutter/material.dart';
import 'package:lib_panda/screens/biodata_edit_form.dart';
import 'package:lib_panda/models/Biodata.dart';
import 'package:lib_panda/screens/home_page.dart';
import 'package:lib_panda/screens/login.dart';
import 'package:lib_panda/screens/request_books.dart';
import 'package:lib_panda/screens/search_page.dart';
import 'package:lib_panda/screens/shopping_cart.dart';
import 'package:lib_panda/screens/wishlist.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:lib_panda/models/Wallet.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:lib_panda/widgets/navbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? selectedGender = '';
  List<Biodata> listBiodata = <Biodata>[];
  List<Wallet> listWallet = <Wallet>[];
  int _currentIndex = 5;

  void _onNavbarItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BookHomePage()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BookListPage()),
        );
        break;
      case 2:
          Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeRequest()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProductPage()),
        );
        break;
      case 4:
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ShoppingCart()),
          );
        break;
      case 5:
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          );
      
        break;
    }
  }

 
  Future<List<Biodata>> fetchBiodataAndWallet() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    final request = context.watch<CookieRequest>();
    // await request.login("https://libpanda-e15-tk.pbp.cs.ui.ac.id/auth/login/", {
    //   'username': 'coba8',
    //   'password': 'libpanda123',
    // });

    var url = Uri.parse(
        'https://libpanda-e15-tk.pbp.cs.ui.ac.id/get-biodata-flutter/${request.jsonData['biodata_pk']}');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    listBiodata = [];

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    for (var d in data) {
      listBiodata.add(Biodata.fromJson(d));
    }

    url = Uri.parse(
        'https://libpanda-e15-tk.pbp.cs.ui.ac.id/get-wallet-flutter/${request.jsonData['wallet_pk']}');
    response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    listWallet = [];

    data = jsonDecode(utf8.decode(response.bodyBytes));
    for (var d in data) {
      listWallet.add(Wallet.fromJson(d));
    }
    return listBiodata;
  }


  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    if (!request.loggedIn) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginPage()));
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile Page'),
          backgroundColor: Colors.green.shade800,
          foregroundColor: Colors.white,
          actions: [
            GestureDetector(
              onTap: () {
                setState(() {
                  request.logout("https://libpanda-e15-tk.pbp.cs.ui.ac.id/auth/logout/");
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Logout successful!'),
                      duration: Duration(seconds: 2), // Adjust the duration as needed
                    ),
                  );
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const LoginPage()));
                });
              },
              child: const Row(
                children: [
                  Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8,),
                  Icon(
                    Icons.logout,
                    size: 28.0,
                    color: Colors.white,
                  ),
                  SizedBox(width: 5),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Navbar(
          currentIndex: _currentIndex,
          onTap: _onNavbarItemTapped,
        ),
        body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'images/bglogin.jpg', // Replace with your image path
            fit: BoxFit.cover,
            color: Colors.black87,
            colorBlendMode: BlendMode.darken,
          ),
          FutureBuilder(
            future: fetchBiodataAndWallet(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (!snapshot.hasData) {
                  return const Column(
                    children: [
                      Text(
                        "Not Login yet...",
                        style:
                        TextStyle(color: Color(0xff59A5D8), fontSize: 20),
                      ),
                      SizedBox(height: 8),
                    ],
                  );
                } else {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Row(
                            children: [
                              Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Account Information',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Card(
                            color: Colors.grey[800],
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    listBiodata[0].fields.name,
                                    style: const TextStyle(fontSize: 16,
                                        fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(listBiodata[0].fields.phoneNumber,
                                      style: const TextStyle(color: Colors.white)),
                                  const SizedBox(height: 4),
                                  Text(listBiodata[0].fields.email,
                                      style: const TextStyle(color: Colors.white)),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.center,
                                    child: FractionallySizedBox(
                                      widthFactor: 1.0,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:MaterialStateProperty.all<Color>(Colors.black45),
                                        ),
                                        onPressed: () {
                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(builder: (context) => EditBiodataPage(biodata: listBiodata[0])));
                                        },
                                        child: const Text('Edit Biodata'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          const Row(
                            children: [
                              Icon(
                                Icons.account_balance_wallet,
                                size: 30,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Balance',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Card(
                            color: Colors.grey[800],
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: <Widget>[
                                  Text(
                                    NumberFormat.currency(locale: 'id_ID', symbol: 'Rp').format(listWallet[0].fields.balance),
                                    style: const TextStyle(fontSize: 28,
                                        fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.center,
                                    child: FractionallySizedBox(
                                      widthFactor: 1.0, //
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:MaterialStateProperty.all<Color>(Colors.black45),
                                        ),
                                        onPressed: () {
                                          // Aksi yang dijalankan saat tombol ditekan
                                          // Contoh: Menampilkan dialog untuk top-up saldo
                                          _showTopUpDialog(context);
                                        },
                                        child: const Text('Top-Up Wallet'),
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
                );
              }
            }
          },
        ),
      ],
    ),
  );
}

  Future<void> _showTopUpDialog(BuildContext context) async {
    // List of available payment methods
    List<String> paymentMethods = ['Pulsa', 'Gopay', 'OVO', 'DANA'];

    // Selected payment method (initialize with the first method)
    String selectedPaymentMethod = paymentMethods[0];

    // Controller for the amount input
    TextEditingController amountController = TextEditingController();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final request = context.watch<CookieRequest>();
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Top-Up Wallet',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text('Enter the amount of balance you want to top up:',
                  style: TextStyle(
                    color: Colors.white70,
                  ),),
                const SizedBox(height: 10),
                Theme(
                  data: ThemeData.dark(),
                  child: TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    cursorColor: Colors.white,
                    decoration: const InputDecoration(labelText: 'Balance Amount',
                      labelStyle: TextStyle(
                        color: Colors.white24,
                      ),),
                    onChanged: (value) {
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Payment Method',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: Theme(
                    data: ThemeData.dark(),
                    child: FractionallySizedBox(
                      widthFactor: 0.5,
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
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                int? amount = int.tryParse(amountController.text);

                if (amount == null || amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid positive amount.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else {
                  // Valid input, proceed with the top-up
                  // Example: _topUpWallet(selectedPaymentMethod, amount);
                  // Kirim ke Django dan tunggu respons
                  // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                  final response = await request.postJson(
                      "https://libpanda-e15-tk.pbp.cs.ui.ac.id/topup-wallet-flutter/${listWallet[0].pk}",
                      jsonEncode(<String, String>{
                        'balance': amount.toString(),

                        // TODO: Sesuaikan field data sesuai dengan aplikasimu
                      }));

                  if (response['status'] == 'success') {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(
                      content: Text("TopUp Successful!"),
                    ));
                    setState(() {
                      Navigator.of(context).pop();
                    });
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(
                      content:
                      Text("TopUp failed, please try again."),
                    ));
                  }
                }
              },
              child: const Text('Top-Up'),
            ),
          ],
        );
      },
    );
  }

}