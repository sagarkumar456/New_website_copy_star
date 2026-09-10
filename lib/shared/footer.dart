import 'package:flutter/material.dart';
import '../core/email_config.dart'; // Apna email_config import kiya

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1E1E1E),
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      width: double.infinity,
      child: Column(
        children: [
          const ContactSection(), 
          const SizedBox(height: 60),
          const Divider(color: Colors.white24),
          const SizedBox(height: 20),
          Text(
            '© ${DateTime.now().year} Copystar. All rights reserved.',
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  bool _isLoading = false;
  bool _isSuccess = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    descController.dispose();
    super.dispose();
  }

  Future<void> _handleEmailSubmit() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final message = descController.text.trim();

    if (name.isEmpty || email.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name, Email and Description are required!'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _isSuccess = false;
    });

    // EMAILJS helper function ko call kar rahe hain
    bool success = await EmailConfig.sendEmail(
      name: name,
      email: email,
      phoneNumber: phone,
      message: message,
    );

    if (success) {
      setState(() {
        _isSuccess = true;
        _isLoading = false;
      });
      nameController.clear();
      phoneController.clear();
      emailController.clear();
      descController.clear();
    } else {
      setState(() { _isLoading = false; });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send message. Please try again later.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Wrap(
          spacing: 60, 
          runSpacing: 50, 
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // ================================
            // LEFT SIDE: Contact Information
            // ================================
            SizedBox(
              width: 400,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Get in Touch',
                    style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Do you have any questions about our spare parts, need technical support, or want to discuss a bulk B2B order? We are here to help.',
                    style: TextStyle(color: Colors.grey, fontSize: 16, height: 1.6),
                  ),
                  const SizedBox(height: 40),
                  _buildInfoRow(Icons.location_on, 'Head Office', 'kathmandu, Nepal'),
                  const SizedBox(height: 30),
                  _buildInfoRow(Icons.phone, 'Call Us / WhatsApp', '+9779851122595'),
                  const SizedBox(height: 30),
                  _buildInfoRow(Icons.email, 'Email Us', 'support@copystar.com'),
                ],
              ),
            ),
            
            // ================================
            // RIGHT SIDE: Contact Form or Success Message
            // ================================
            SizedBox(
              width: 500,
              child: Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
                  ],
                ),
                child: _isSuccess ? _buildSuccessMessage() : _buildFormContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String detail) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF4A90E2), size: 26),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 5),
              Text(detail, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
            ],
          ),
        )
      ],
    );
  }

  // ==========================================
  // FORM CONTENT (When not submitted yet)
  // ==========================================
  Widget _buildFormContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Send a Message', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 30),
        
        _buildTextField('Name', 'Enter your full name', 'contact_name_field', controller: nameController),
        const SizedBox(height: 20),
        _buildTextField('Phone', 'Enter your phone number', 'contact_phone_field', controller: phoneController),
        const SizedBox(height: 20),
        _buildTextField('Email', 'Enter your email address', 'contact_email_field', controller: emailController),
        const SizedBox(height: 20),
        _buildTextField('Description', 'How can we help you?', 'contact_desc_field', maxLines: 4, controller: descController),
        const SizedBox(height: 30),
        
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            key: const Key('contact_submit_btn'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A90E2),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            onPressed: _isLoading ? null : _handleEmailSubmit,
            child: _isLoading 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Send Message', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // SUCCESS MESSAGE UI
  // ==========================================
  Widget _buildSuccessMessage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.check_circle, color: Color(0xFF63D392), size: 80),
        const SizedBox(height: 20),
        const Text(
          'Message Sent!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 15),
        const Text(
  'Your request has been successfully submitted.\nWe will get back to you within 24 hours.',
  textAlign: TextAlign.center,
  style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
),
        const SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          height: 45,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E1E1E),
              foregroundColor: Colors.white,
              side: BorderSide(color: Colors.white.withOpacity(0.2)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            onPressed: () {
              setState(() {
                _isSuccess = false; // Form wapis laane ke liye
              });
            },
            child: const Text('Send Another Message'),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String hint, String keyName, {int maxLines = 1, TextEditingController? controller}) {
    return TextField(
      key: Key(keyName),
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Colors.grey),
        hintStyle: TextStyle(color: Colors.grey.shade700),
        filled: true,
        fillColor: const Color(0xFF1A1A1A),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: const BorderSide(color: Color(0xFF4A90E2))),
      ),
    );
  }
}