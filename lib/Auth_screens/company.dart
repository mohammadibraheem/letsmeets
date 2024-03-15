import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:letsmeet/Screens/Auth/login_screen.dart';

class CompanyNamePage extends StatefulWidget {
  const CompanyNamePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CompanyNamePageState createState() => _CompanyNamePageState();
}

class _CompanyNamePageState extends State<CompanyNamePage> {
  final TextEditingController _companyNameController =
      TextEditingController(text: "wosul");
  final TextEditingController _companyCodeController =
      TextEditingController(text: "512");
  bool _isLoading = false;

  void _submitForm() {
    setState(() {
      _isLoading = true;
    });

    String companyName = _companyNameController.text.trim();
    // ignore: non_constant_identifier_names
    String CompanyCode = _companyCodeController.text.trim();

    // Simulate company name verification process
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isLoading = false;
      });

      if (companyName.toLowerCase() == 'wosul' && CompanyCode == '512') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Invalid company name',
              style: TextStyle(color: Colors.black),
            ),
            backgroundColor:
                Colors.red, // Changing the color to red for the SnackBar
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120.0),
        child: AppBar(
          backgroundColor: Colors.blueGrey,
          elevation: 0,
          flexibleSpace: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue,
                      Colors.lightBlueAccent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              const Positioned(
                bottom: 10.0,
                left: 20.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'Your Company',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _companyNameController,
              decoration: InputDecoration(
                labelText: 'Company Name',
                labelStyle: const TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              controller: _companyCodeController,
              decoration: InputDecoration(
                labelText: 'Company Code',
                labelStyle: const TextStyle(color: Colors.black),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], // Ensures only numbers can be entered
            ),
            const SizedBox(height: 20.0),
            _isLoading
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.blue,
                    ),
                  )
                : ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _companyCodeController.dispose();
    super.dispose();
  }
}
