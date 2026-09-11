// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:async'; 
import 'dart:html' as html; 
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../shared/custom_appbar.dart';
import '../../shared/footer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818), 
      appBar: const CustomAppBar(),
      endDrawer: _buildMobileDrawer(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeroBannerSection(),         
            _buildBrandFeatureCards(context), // Context pass kiya gaya hai       
            _buildValueProps(context),        // Context pass kiya gaya hai      
            const SizedBox(height: 40),
            
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF1A1A1A), 
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, -5))
                ]
              ),
              child: Column(
                children: [
                  const ShopByCategorySection(), 
                  const SoftwareDownloadSection(),
                  const CustomerReviewsSection(), 
                  _buildB2BBanner(context),        
                  const Footer(),                        
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('fab_contact'),
        backgroundColor: const Color(0xFF25D366),
        foregroundColor: Colors.white,
        onPressed: () async {
          final Uri phoneUri = Uri.parse('tel:+9779851122595');
          if (await canLaunchUrl(phoneUri)) {
            await launchUrl(phoneUri);
          } else {
            debugPrint('Call feature not supported on this device.');
          }
        },
        child: const Icon(Icons.phone_in_talk, size: 28),
      ),
    );
  }

  // --- MOBILE DRAWER WIDGET ---
  Widget _buildMobileDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1E1E1E),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF121212)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/videos/images/web_logo.png', 
                  height: 40, 
                  errorBuilder: (context, error, stackTrace) => const Text('COPYSTAR', style: TextStyle(color: Color(0xFF4A90E2), fontSize: 28, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 10),
                const Text('Navigation Menu', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          ListTile(leading: const Icon(Icons.home, color: Colors.white), title: const Text('Home', style: TextStyle(color: Colors.white)), onTap: () { Navigator.pop(context); context.go('/'); }),
          ListTile(leading: const Icon(Icons.build, color: Colors.white), title: const Text('Services', style: TextStyle(color: Colors.white)), onTap: () { Navigator.pop(context); context.go('/services'); }),
          ListTile(leading: const Icon(Icons.settings, color: Colors.white), title: const Text('Spare Parts', style: TextStyle(color: Colors.white)), onTap: () { Navigator.pop(context); context.go('/parts'); }),
          ListTile(leading: const Icon(Icons.contact_mail, color: Colors.white), title: const Text('Contact', style: TextStyle(color: Colors.white)), onTap: () { Navigator.pop(context); context.go('/contact'); }),
          const Divider(color: Colors.white24),
          ListTile(leading: const Icon(Icons.shopping_cart, color: Color(0xFF63D392)), title: const Text('View Cart', style: TextStyle(color: Color(0xFF63D392), fontWeight: FontWeight.bold)), onTap: () { Navigator.pop(context); context.go('/cart'); }),
        ],
      ),
    );
  }

  // --- FEATURE CARDS ---
  Widget _buildBrandFeatureCards(BuildContext context) {
    // Check screen width
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      // Mobile par kam overlap (-30), Desktop par zyada overlap (-120)
      transform: Matrix4.translationValues(0.0, isMobile ? -30.0 : -120.0, 0.0), 
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 25, runSpacing: 25, alignment: WrapAlignment.center,
        children: [
          _buildPremiumDarkCard(imagePath: 'assets/videos/images/parts.png', title: 'Machine Parts for Major Brands', desc: 'Rollers, Drums, Gears, Grease & More.', keyName: 'feature_parts'),
          _buildPremiumDarkCard(imagePath: 'assets/videos/images/gears.png', title: 'All Gear Types Available', desc: 'High-quality printer gears for smooth performance.', keyName: 'feature_gears'),
          _buildPremiumDarkCard(imagePath: 'assets/videos/images/machine.png', title: 'All Major Brand Machines', desc: 'A3/A4 | Duplex | Print, Scan, Copy, Fax.', keyName: 'feature_machines'),
          _buildPremiumDarkCard(imagePath: 'assets/videos/images/toner.png', title: 'Best Quality Toners', desc: 'Black & Color | High Yield | Best Print Quality.', keyName: 'feature_toner'),
        ],
      ),
    );
  }

  Widget _buildPremiumDarkCard({required String imagePath, required String title, required String desc, required String keyName}) {
    return Container(
      width: 280, 
      height: 320, 
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A), 
        borderRadius: BorderRadius.circular(16), 
        border: Border.all(color: Colors.white.withOpacity(0.12), width: 1.5), 
        boxShadow: [ BoxShadow(color: Colors.black.withOpacity(0.8), blurRadius: 25, offset: const Offset(0, 15)) ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)), 
            child: Image.asset(
              imagePath, 
              width: double.infinity, 
              height: 180, 
              fit: BoxFit.cover, 
              errorBuilder: (context, error, stackTrace) => Container(height: 180, color: Colors.white10, child: const Icon(Icons.print, size: 80, color: Colors.grey))
            )
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                Text(
                  title, 
                  maxLines: 2, 
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white, height: 1.3)
                ),
                const SizedBox(height: 8),
                Text(
                  desc, 
                  maxLines: 2, 
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade400, height: 1.5)
                ),
              ]
            ),
          ),
        ],
      ),
    );
  }

  // --- VALUE PROPS ---
  Widget _buildValueProps(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      // Mobile par gap theek karne ke liye overlap update
      transform: Matrix4.translationValues(0.0, isMobile ? -10.0 : -60.0, 0.0), 
      child: Wrap(
        spacing: 40, runSpacing: 40, alignment: WrapAlignment.center,
        children: [
          _buildDarkValueItem(Icons.verified_user_outlined, 'Quality Guarantee', 'Verified by Copystar'),
          _buildDarkValueItem(Icons.local_shipping_outlined, 'Fast Worldwide Delivery', 'Seamless Logistics'),
          _buildDarkValueItem(Icons.headset_mic_outlined, '24/7 Expert Support', 'Real-time Assistance'),
          _buildDarkValueItem(Icons.contact_phone_outlined, 'Easy Contact Channels', 'Connect Instantly'),
        ],
      ),
    );
  }

  Widget _buildDarkValueItem(IconData icon, String title, String subtitle) {
    return SizedBox(
      width: 220,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF2A2A2A), border: Border.all(color: Colors.white.withOpacity(0.15))), child: Icon(icon, size: 36, color: const Color(0xFFE0E0E0))), 
          const SizedBox(height: 15),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 5),
          Text(subtitle, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  // --- B2B BANNER ---
  Widget _buildB2BBanner(BuildContext context) {
    return Container(
      width: double.infinity, margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 60), padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(color: const Color(0xFF2A2A2A), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.white10)),
      child: Column(
        children: [
          const Text('Are you a Service Center or Wholesaler?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Text('Contact us for exclusive B2B pricing and bulk order management.', style: TextStyle(color: Colors.grey.shade400)),
          const SizedBox(height: 20),
          ElevatedButton(style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15), backgroundColor: const Color(0xFF63D392), foregroundColor: Colors.black), onPressed: () => context.go('/contact'), child: const Text('Contact Sales', style: TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}

// =========================================================
// HERO BANNER SECTION (IMAGE WALA) - FIXED FOR MOBILE
// =========================================================
class HeroBannerSection extends StatelessWidget {
  const HeroBannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;

    return Container(
      width: double.infinity,
      // Mobile par "null" dene se height apne aap image ke aspect ratio se set ho jayegi
      height: isMobile ? null : 550.0, 
      color: Colors.black, 
      child: InkWell(
        onTap: () {
          context.go('/parts'); 
        },
        child: Image.asset(
          'assets/videos/images/web_backgoud.png', 
          // fitWidth lagane se image width ke hisab se scale hogi bina kate
          fit: isMobile ? BoxFit.fitWidth : BoxFit.cover,
          width: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Text(
                'Banner Image Not Found\nCheck Path: assets/videos/images/web_backgoud.png',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red.shade300),
              ),
            );
          },
        ),
      ),
    );
  }
}

// =============================================================
// SHOP BY CATEGORY SECTION (IMAGE GRID)
// =============================================================
class ShopByCategorySection extends StatelessWidget {
  const ShopByCategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> categories = [
      {
        'title': 'UPPER FUSER ROLLERS',
        'image': 'assets/videos/images/UPPER FUSER ROLLERS.png', 
      },
      {
        'title': 'THERMISTORS/\nTHERMOSWITCHS/ SENSORS',
        'image': 'assets/videos/images/parts.png', 
      },
      {
        'title': 'TONERS & DEVELOPERS',
        'image': 'assets/videos/images/toner.png', 
      },
      {
        'title': 'CHIPS',
        'image': 'assets/videos/images/chip.png', 
      },
      {
        'title': 'PAPER FEED RUBBERS\nAND ROLLERS',
        'image': 'assets/videos/images/Rubber.png', 
      },
      {
        'title': 'LOWER PRESSURE ROLLERS',
        'image': 'assets/videos/images/roller.png', 
      },
    ];

    return Container(
      padding: const EdgeInsets.only(top: 80, bottom: 60, left: 20, right: 20),
      width: double.infinity,
      color: Colors.transparent, 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Shop by Category',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Explore our wide range of premium spare parts',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 50),
          
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Wrap(
              spacing: 25,
              runSpacing: 25,
              alignment: WrapAlignment.center,
              children: categories.map((category) {
                return _buildCategoryCard(
                  context: context,
                  title: category['title']!,
                  imageUrl: category['image']!,
                  onTap: () {
                    context.go('/parts');
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({required BuildContext context, required String title, required String imageUrl, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 350,  
        height: 250, 
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF2A2A2A),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))
          ]
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.image, size: 50, color: Colors.grey)),
              ),
              
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.2),
                      Colors.black.withOpacity(0.9),
                    ],
                    stops: const [0.0, 0.5, 1.0], 
                  ),
                ),
              ),

              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              Positioned(
                top: 15,
                right: 15,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFF63D392), 
                  child: const Icon(Icons.arrow_forward_outlined, color: Colors.black, size: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================
// SOFTWARE DOWNLOAD SECTION 
// =============================================================
class SoftwareDownloadSection extends StatefulWidget {
  const SoftwareDownloadSection({super.key});

  @override
  State<SoftwareDownloadSection> createState() => _SoftwareDownloadSectionState();
}

class _SoftwareDownloadSectionState extends State<SoftwareDownloadSection> {
  final TextEditingController _emailController = TextEditingController();
  int _downloadCount = 0;
  bool _isLoading = false;
  bool _isSuccess = false;
  String? _selectedBrand; 

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  final List<String> _brands = ['Xerox', 'Canon', 'Konica Minolta', 'Ricoh'];
  final Map<String, String> _driveLinks = {
    'Xerox': 'https://drive.google.com/file/d/1i1SajozCXLvtG7hLyHvNWINBkqjy197L/view?usp=sharing', 
    'Canon': 'https://drive.google.com/', 
    'Konica Minolta': 'https://drive.google.com/', 
    'Ricoh': 'https://drive.google.com/', 
  };

  @override
  void initState() {
    super.initState();
    _fetchDownloadCount();
  }

  Future<void> _fetchDownloadCount() async {
    try {
      final snapshot = await _dbRef.child('software_downloads').get();
      if (snapshot.exists) { 
        setState(() { 
          _downloadCount = int.tryParse(snapshot.value.toString()) ?? 0; 
        }); 
      }
    } catch (e) { 
      debugPrint("Error fetching count: $e"); 
    }
  }

  Future<void> _handleDownload() async {
    final email = _emailController.text.trim();
    if (!email.contains('@') || !email.contains('.')) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a valid email!'), backgroundColor: Colors.red));
      return;
    }

    setState(() { _isLoading = true; _isSuccess = false; });

    try {
      final countSnapshot = await _dbRef.child('software_downloads').get();
      int currentCount = 0;
      if (countSnapshot.exists) {
        currentCount = int.tryParse(countSnapshot.value.toString()) ?? 0;
      }
      await _dbRef.child('software_downloads').set(currentCount + 1);

      final newEmailRef = _dbRef.child('software_emails').push();
      await newEmailRef.set({
        'email': email,
        'brand': _selectedBrand,
        'timestamp': DateTime.now().toIso8601String(),
      });

      setState(() { 
        _downloadCount = currentCount + 1; 
        _isSuccess = true; 
        _isLoading = false; 
        _emailController.clear(); 
      });
      html.window.open(_driveLinks[_selectedBrand] ?? 'https://drive.google.com/', '_blank'); 

    } catch (e) {
      setState(() { _isLoading = false; });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Network error. Try again!'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20), padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(color: const Color(0xFF181818), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF4A90E2).withOpacity(0.3), width: 2)),
      child: Column(
        children: [
          const Icon(Icons.cloud_download_outlined, size: 50, color: Color(0xFF4A90E2)), 
          const SizedBox(height: 15),
          const Text('Download Machine Software', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Text('Select your machine brand and get the latest drivers completely free.', style: TextStyle(color: Colors.grey.shade400, fontSize: 15), textAlign: TextAlign.center),
          const SizedBox(height: 25),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(color: const Color(0xFF4A90E2).withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.people, color: Color(0xFF4A90E2), size: 18),
                const SizedBox(width: 8),
                Text('$_downloadCount People Downloaded', style: const TextStyle(color: Color(0xFF4A90E2), fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          
          const SizedBox(height: 35),
          Wrap(
            spacing: 15, runSpacing: 15, alignment: WrapAlignment.center,
            children: _brands.map((brand) {
              bool isSelected = _selectedBrand == brand;
              return InkWell(
                onTap: () { setState(() { _selectedBrand = brand; _isSuccess = false; }); },
                borderRadius: BorderRadius.circular(8),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200), padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12), 
                  decoration: BoxDecoration(color: isSelected ? const Color(0xFF4A90E2) : const Color(0xFF2A2A2A), borderRadius: BorderRadius.circular(8), border: Border.all(color: isSelected ? const Color(0xFF4A90E2) : Colors.grey.shade700)),
                  child: Text(brand, style: TextStyle(color: isSelected ? Colors.white : Colors.grey.shade300, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 35),
          if (_selectedBrand != null) ...[
            Text('Get $_selectedBrand Drivers', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            if (_isSuccess)
              Container(
                padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.green)),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.check_circle, color: Colors.green), SizedBox(width: 10), Text('Opening Google Drive in new tab...', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16))]),
              )
            else
              Wrap(
                alignment: WrapAlignment.center, crossAxisAlignment: WrapCrossAlignment.center, spacing: 15, runSpacing: 15,
                children: [
                  SizedBox(
                    width: 300, 
                    child: TextField(
                      controller: _emailController, style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(hintText: 'Enter your email id...', hintStyle: TextStyle(color: Colors.grey.shade600), filled: true, fillColor: const Color(0xFF2A2A2A), prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none)),
                    ),
                  ),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF63D392), foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                      onPressed: _isLoading ? null : _handleDownload,
                      icon: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2)) : const Icon(Icons.download),
                      label: Text(_isLoading ? 'Processing...' : 'Download Now', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
          ] else ...[
            Text('Please select a brand above to download drivers.', style: TextStyle(color: Colors.grey.shade500, fontStyle: FontStyle.italic)),
          ]
        ],
      ),
    );
  }
}

// =============================================================
// CUSTOMER REVIEWS SECTION 
// =============================================================
class CustomerReviewsSection extends StatefulWidget {
  const CustomerReviewsSection({super.key});

  @override
  State<CustomerReviewsSection> createState() => _CustomerReviewsSectionState();
}

class _CustomerReviewsSectionState extends State<CustomerReviewsSection> {
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;

  final List<Map<String, dynamic>> reviews = [
    {'name': 'Satish Kumar', 'review': '"Excellent service and product quality! Highly recommended."', 'rating': 5},
    {'name': 'Rajan kumar', 'review': '"Fast delivery and the product exceeded my expectations. Fantastic!"', 'rating': 5},
    {'name': 'Shyma kumar', 'review': '"Good product, but delivery was a bit slow. Overall satisfied."', 'rating': 4},
    {'name': 'Mahesh Sabnani', 'review': '"Amazing support! They helped me with all my queries promptly."', 'rating': 5},
    {'name': 'Amit Sharma', 'review': '"Purchased bulk toners for my shop. Excellent wholesale pricing and fast dispatch."', 'rating': 5},
    {'name': 'Priya Singh', 'review': '"The AMC service is a lifesaver. Their technicians are very knowledgeable and polite."', 'rating': 5},
    {'name': 'Vikram Desai', 'review': '"Got a replacement fuser roller for my Canon machine. Works perfectly like original."', 'rating': 4},
    {'name': 'Neha Gupta', 'review': '"Great software support! Downloaded the drivers easily from their portal. Very helpful."', 'rating': 5},
    {'name': 'Rajesh Verma', 'review': '"One of the best B2B suppliers for photocopier parts in Delhi. Trusted partner."', 'rating': 5},
    {'name': 'Anil Kumar', 'review': '"Their quality of chips and gears is top-notch. Highly recommended for service centers."', 'rating': 5},
    {'name': 'Manoj Tiwari', 'review': '"Good customer service, but the courier took an extra day. Products are 100% genuine though."', 'rating': 4},
    {'name': 'Sneha Patel', 'review': '"Very affordable rates for premium drum units. Print quality is superb. Will order again!"', 'rating': 5},
    {'name': 'Rohan Mehra', 'review': '"The technician resolved our Xerox machine issue within 2 hours. Super fast response time!"', 'rating': 5},
    {'name': 'Kavita Reddy', 'review': '"Best place to get compatible toners. The page yield is exactly what they promised."', 'rating': 5},
    {'name': 'Sanjay Joshi', 'review': '"I have been buying from Copystar for 2 years now. Never faced any quality issues."', 'rating': 5},
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_scrollController.hasClients) {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.position.pixels;
        double scrollAmount = 350.0;

        if (currentScroll >= maxScroll - 10) {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 800),
            curve: Curves.fastOutSlowIn,
          );
        } else {
          _scrollController.animateTo(
            currentScroll + scrollAmount,
            duration: const Duration(milliseconds: 800),
            curve: Curves.fastOutSlowIn,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      width: double.infinity,
      child: Column(
        children: [
          const Text('What Our Customers Say', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 10),
          const Text('Trusted by thousands of businesses and service centers.', style: TextStyle(fontSize: 16, color: Colors.grey)),
          const SizedBox(height: 50),
          
          SingleChildScrollView(
            controller: _scrollController, 
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: reviews.map((review) {
                return Container(
                  width: 320, 
                  height: 230, 
                  margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2A2A), 
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8))]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return Icon(index < review['rating'] ? Icons.star : Icons.star_border, color: Colors.amber, size: 26);
                        }),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            review['review'],
                            textAlign: TextAlign.center, maxLines: 4, overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 15, color: Colors.grey.shade300, height: 1.5),
                          ),
                        ),
                      ),
                      Text('- ${review['name']}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}