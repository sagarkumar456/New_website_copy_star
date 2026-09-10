import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/custom_appbar.dart'; 
import '../../shared/footer.dart';        

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      appBar: const CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. HERO SECTION
            _buildHeroSection(),
            
            // 2. SERVICES GRID
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Wrap(
                  spacing: 30,
                  runSpacing: 40,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildServiceCard(
                      icon: Icons.build_circle_outlined,
                      title: 'Maintenance & Repair',
                      desc: 'Fast and reliable on-site repair services for all major photocopy machine brands to minimize your downtime.',
                      color: const Color(0xFF4A90E2),
                    ),
                    _buildServiceCard(
                      icon: Icons.handshake_outlined,
                      title: 'Annual Maintenance (AMC)',
                      desc: 'Comprehensive AMC plans covering regular checkups, emergency repairs, and priority support for your business.',
                      color: const Color(0xFF63D392),
                    ),
                    _buildServiceCard(
                      icon: Icons.settings_suggest_outlined,
                      title: 'Parts Replacement',
                      desc: 'Genuine spare parts replacement including fuser rollers, drums, and toners with assured warranty.',
                      color: const Color(0xFFF5A623),
                    ),
                    _buildServiceCard(
                      icon: Icons.router_outlined,
                      title: 'Network & Software Setup',
                      desc: 'Complete software installation, firmware upgrades, and network printer setup for seamless office workflow.',
                      color: const Color(0xFF9013FE),
                    ),
                  ],
                ),
              ),
            ),

            // 3. AMC SPECIAL BANNER
            _buildAMCBanner(context),

            // 4. FOOTER
            const Footer(),
          ],
        ),
      ),
     floatingActionButton: FloatingActionButton(
        key: const Key('fab_contact_services'),
        backgroundColor: const Color(0xFF25D366),
        foregroundColor: Colors.white,
        onPressed: () => context.go('/contact'),
        // Icons.whatsapp ki jagah Icons.chat ya Icons.support_agent use kiya hai
        child: const Icon(Icons.chat, size: 28), 
      ),
    );
  }

  // ==========================================
  // HERO SECTION
  // ==========================================
  Widget _buildHeroSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
        image: DecorationImage(
          image: const NetworkImage('https://images.unsplash.com/photo-1620288627223-53302f4e8c74?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.85), BlendMode.darken),
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Our Professional Services',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5),
          ),
          const SizedBox(height: 20),
          Container(width: 80, height: 4, decoration: BoxDecoration(color: const Color(0xFF4A90E2), borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 30),
          const Text(
            'Expert solutions to keep your printing operations running smoothly.\nFrom instant repairs to long-term maintenance contracts.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white70, height: 1.6),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // SERVICE CARD COMPONENT
  // ==========================================
  Widget _buildServiceCard({required IconData icon, required String title, required String desc, required Color color}) {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: const Color(0xFF222222),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 10))
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 40, color: color),
          ),
          const SizedBox(height: 30),
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 15),
          Text(
            desc,
            style: const TextStyle(fontSize: 15, color: Colors.white60, height: 1.6),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // AMC BANNER
  // ==========================================
  Widget _buildAMCBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 80, left: 20, right: 20),
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
      constraints: const BoxConstraints(maxWidth: 1000),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A2A6C), Color(0xFF112D4E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: const Color(0xFF4A90E2).withOpacity(0.3), blurRadius: 30, offset: const Offset(0, 10))
        ]
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        runSpacing: 30,
        children: [
          const SizedBox(
            width: 600,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Get Peace of Mind with AMC', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 15),
                Text(
                  'Protect your machines with our Annual Maintenance Contracts. Zero visiting charges, priority support, and regular servicing.',
                  style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              backgroundColor: const Color(0xFF63D392),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => context.go('/contact'),
            child: const Text('REQUEST A QUOTE', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.0)),
          ),
        ],
      ),
    );
  }
}