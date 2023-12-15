import 'package:flutter/material.dart';
import 'package:lib_panda/screens/profile_page.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:lib_panda/models/Biodata.dart';
import 'dart:convert';

class EditBiodataPage extends StatefulWidget {
  final Biodata biodata;

  // Constructor to receive the parameter
  EditBiodataPage({required this.biodata});

  @override
  _EditBiodataPageState createState() => _EditBiodataPageState();
}

class _EditBiodataPageState extends State<EditBiodataPage> {

  DateTime birthdayOriginal = DateTime.now();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool initialized = false;
  void initialize() {
    if (!initialized) {
      nameController.text = widget.biodata.fields.name;
      emailController.text = widget.biodata.fields.email;
      genderController.text = widget.biodata.fields.gender;
      birthdayController.text = widget.biodata.fields.birthday.toString().split(' ')[0];
      phoneNumberController.text = widget.biodata.fields.phoneNumber;
      birthdayOriginal = widget.biodata.fields.birthday;

      initialized = true;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != birthdayOriginal) {
      setState(() {
        birthdayOriginal = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    initialize();
    return Theme (
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text('Edit Biodata'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                ListTile(
                  title: Text('Gender'),
                  contentPadding: EdgeInsets.all(0),
                  subtitle: Row(
                    children: [
                      Radio(
                        value: 'male',
                        groupValue: genderController.text,
                        onChanged: (value) {
                          setState(() {
                            genderController.text = value.toString();
                          });
                        },
                      ),
                      Text('Male'),
                      Radio(
                        value: 'female',
                        groupValue: genderController.text,
                        onChanged: (value) {
                          setState(() {
                            genderController.text = value.toString();
                          });
                        },
                      ),
                      Text('Female'),
                    ],
                  ),
                ),
                TextFormField(
                  controller: birthdayController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Birthday',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () async {
                        // Show date picker and wait for user to pick a date
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: birthdayOriginal,
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        // Update the controller's text if a date is picked
                        if (pickedDate != null) {
                          setState(() {
                            widget.biodata.fields.birthday = pickedDate;
                            birthdayController.text = pickedDate.toLocal().toString().split(' ')[0];
                          });
                        }
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Birthday is required';
                    }
                    return null; // Return null if the input is valid
                  },
                ),
                TextFormField(
                  controller: phoneNumberController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone Number is required';
                    } else if (!RegExp(r'^\+?[0-9]+$').hasMatch(value)) {
                      return 'Enter a valid phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:MaterialStateProperty.all<Color>(Colors.black45),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:MaterialStateProperty.all<Color>(Colors.black45),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // Kirim ke Django dan tunggu respons
                          // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                          final response = await request.postJson(
                              "https://libpanda-e15-tk.pbp.cs.ui.ac.id/edit-biodata-flutter/${widget.biodata.pk}",
                              jsonEncode(<String, String>{
                                'name': nameController.text,
                                'email': emailController.text,
                                'gender': genderController.text,
                                'birthday': birthdayOriginal.toString().split(' ')[0],
                                'phone_number': phoneNumberController.text,

                                // TODO: Sesuaikan field data sesuai dengan aplikasimu
                              }));

                          if (nameController.text.compareTo(widget.biodata.fields.name) == 0 &&
                              emailController.text.compareTo(widget.biodata.fields.email) == 0 &&
                              genderController.text.compareTo(widget.biodata.fields.gender) == 0 &&
                              birthdayController.text.compareTo(widget.biodata.fields.birthday.toString().split(' ')[0]) == 0 &&
                              phoneNumberController.text.compareTo(widget.biodata.fields.phoneNumber) == 0 &&
                              birthdayOriginal.compareTo(widget.biodata.fields.birthday) == 0) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content:
                              Text("You haven't made any changes."),
                            ));
                          }
                          else if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Edit Succesful!"),
                            ));
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => ProfilePage()),
                            );
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content:
                              Text("Edit failed, please try again."),
                            ));
                          }
                        }
                      },
                      child: Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
