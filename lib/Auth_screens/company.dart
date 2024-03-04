import 'package:flutter/material.dart';
import 'package:letsmeet/Screens/Auth/login_screen.dart';

class CompanyNamePage extends StatefulWidget {
  const CompanyNamePage({Key? key}) : super(key: key);

  @override
  _CompanyNamePageState createState() => _CompanyNamePageState();
}

class _CompanyNamePageState extends State<CompanyNamePage> {
  final TextEditingController _companyNameController = TextEditingController();
  bool _isLoading = false;

  void _submitForm() {
    setState(() {
      _isLoading = true;
    });

    String companyName = _companyNameController.text.trim();

    // Simulate company name verification process
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });

      if (companyName.toLowerCase() == 'wosul') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid company name'),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Company Name'),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            _isLoading
                ? const CircularProgressIndicator.adaptive() // Show progress indicator while processing
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
    super.dispose();
  }
}
