import 'package:flutter/material.dart';
import '../../shared/custom_appbar.dart';
import '../../shared/footer.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF181818),
      appBar: CustomAppBar(),
      // Yeh page open hote hi direct aapka 'Send a Message' wala form (Footer) dikhayega
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50),
            Text(
              'Get In Touch',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 20),
            Footer(), 
          ],
        ),
      ),
    );
  }
}



