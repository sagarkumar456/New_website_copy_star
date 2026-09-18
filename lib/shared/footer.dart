// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'dart:ui_web' as ui_web; 
import 'package:flutter/material.dart';
import '../core/email_config.dart'; // Apna path check kar lein

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
          const YoutubeVideoSection(videoId: 'PuNJvLaljwk'),
          const SizedBox(height: 60),
          const ContactSection(), 
          const SizedBox(height: 60),
          const Divider(color: Colors.white24),
          const SizedBox(height: 20),
          
          // ==========================================
          // ANIMATED FOOTER TEXT & DEVELOPER CREDIT
          // ==========================================
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeOutCubic,
            builder: (context, double value, child) {
              return Opacity(
                opacity: value,
                // Halke se neeche se upar aane wala (slide-up) effect
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)), 
                  child: child,
                ),
              );
            },
            child: Column(
              children: [
                const Text(
                  '© Copystar. All rights reserved.',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 12),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Developer : ',
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A90E2).withOpacity(0.1), // Halka blue background
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF4A90E2).withOpacity(0.3)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.code, size: 14, color: Color(0xFF4A90E2)),
                          SizedBox(width: 5),
                          Text(
                            'Sagar Kumar',
                            style: TextStyle(
                              color: Color(0xFF4A90E2), 
                              fontSize: 13, 
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// YOUTUBE VIDEO SECTION (BLACK SCREEN FIX)
// =============================================================
class YoutubeVideoSection extends StatefulWidget {
  final String videoId; 
  const YoutubeVideoSection({super.key, required this.videoId});

  @override
  State<YoutubeVideoSection> createState() => _YoutubeVideoSectionState();
}

class _YoutubeVideoSectionState extends State<YoutubeVideoSection> {
  late final String _viewId;

  @override
  void initState() {
    super.initState();
    _viewId = 'youtube-iframe-${widget.videoId}';

    ui_web.platformViewRegistry.registerViewFactory(_viewId, (int viewId) {
      final iframe = html.IFrameElement()
        ..src = 'https://www.youtube.com/embed/${widget.videoId}?rel=0&modestbranding=1'
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.borderRadius = '16px' // HTML level par corners round karna
        ..allow = 'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture'
        ..allowFullscreen = true;
      return iframe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          const Text(
            'Watch Our Video',
            style: TextStyle(
              fontSize: 32, 
              fontWeight: FontWeight.bold, 
              color: Colors.white,
              letterSpacing: 1.2
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'See our products and services in action',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 35),
          
          // NAYA CODE: Yahan se ClipRRect aur Decoration HATA diya gaya hai
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 850),
            child: AspectRatio(
              aspectRatio: 16 / 9, 
              child: HtmlElementView(viewType: _viewId), // Direct Video
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// CONTACT SECTION
// =============================================================
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
                  _buildInfoRow(Icons.email, 'Email Us', 'Copystarnepal@hotmail.com'),
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
                _isSuccess = false;
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