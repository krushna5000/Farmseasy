import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  final List<Map<String, String>> _farms = [];
  bool _showContent = false;
  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 400), () {
      setState(() {
        _showContent = true;
      });
    });
    _buttonAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _buttonScaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _buttonAnimationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _buttonAnimationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  void _showAddFarmSheet() {
    final nameController = TextEditingController();
    final areaController = TextEditingController();
    final locationController = TextEditingController();

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.6,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 25,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 4,
                    width: 50,
                    color: Colors.grey[300],
                  ),
                ),
                const SizedBox(height: 16),
                Text("Add Farm",
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),
                TextField(
                    controller: nameController,
                    decoration:
                    const InputDecoration(labelText: "Farm Name")),
                TextField(
                    controller: areaController,
                    decoration:
                    const InputDecoration(labelText: "Area (m²)")),
                TextField(
                    controller: locationController,
                    decoration:
                    const InputDecoration(labelText: "Location")),
                const SizedBox(height: 25),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    setState(() {
                      _farms.add({
                        'name': nameController.text,
                        'area': areaController.text,
                        'location': locationController.text,
                      });
                    });
                    Navigator.pop(context);
                  },
                  child: Text("Save Farm",
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHomePage(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    final List<Map<String, dynamic>> dummyStats = [
      {"title": "Soil Moisture", "value": "45%", "icon": Icons.water_drop},
      {"title": "Temperature", "value": "29°C", "icon": Icons.thermostat},
      {"title": "Humidity", "value": "61%", "icon": Icons.cloud},
      {"title": "Fertilizer Used", "value": "Urea", "icon": Icons.grass},
    ];

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // ----- HEADER -----
            Stack(
              children: [
                ClipPath(
                  clipper: _HeaderClipper(),
                  child: Container(
                    height: 250,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Hi, Sakshi 👋",
                            style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white)),
                        Text("Welcome to Farmeasy",
                            style: GoogleFonts.poppins(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ----- DUMMY STAT CARDS -----
            AnimatedOpacity(
              opacity: _showContent ? 1 : 0,
              duration: const Duration(milliseconds: 800),
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 800),
                offset: _showContent ? Offset.zero : const Offset(0, 0.2),
                child: SizedBox(
                  height: 130,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: dummyStats.length,
                    itemBuilder: (context, index) {
                      final stat = dummyStats[index];
                      return Container(
                        margin: const EdgeInsets.only(right: 16),
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(stat["icon"], color: Colors.green, size: 30),
                              const SizedBox(height: 8),
                              Text(stat["value"],
                                  style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green)),
                              Text(stat["title"],
                                  style: GoogleFonts.poppins(
                                      fontSize: 13, color: Colors.grey[700])),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ----- ADD FARM SECTION -----
            Container(
              width: double.infinity,
              color: const Color(0xFFEAF7E8),
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Center(
                child: ScaleTransition(
                  scale: _buttonScaleAnimation,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _buttonAnimationController.forward().then((_) {
                        _buttonAnimationController.reverse();
                      });
                      _showAddFarmSheet();
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: Text("Add Farm",
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 14),
                      backgroundColor: Colors.green,
                      elevation: 6,
                      shadowColor: Colors.black26,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
              ),
            ),

            // ----- MY FARMS SECTION -----
            Padding(
              padding:
              EdgeInsets.symmetric(horizontal: width * 0.06, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("My Farms",
                      style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.green)),
                  const SizedBox(height: 10),
                  Container(
                      height: 2,
                      width: 50,
                      color: Colors.green.withOpacity(0.7)),
                  const SizedBox(height: 20),
                  if (_farms.isEmpty)
                    Center(
                        child: Text("No farms added yet.",
                            style: GoogleFonts.poppins(color: Colors.grey)))
                  else
                    AnimatedOpacity(
                      opacity: _showContent ? 1 : 0,
                      duration: const Duration(milliseconds: 800),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.95,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _farms.length,
                        itemBuilder: (context, index) {
                          final farm = _farms[index];
                          return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                    child: Image.asset(
                                      'assets/images/farm_bg.jpg',
                                      height: 90,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(farm['name'] ?? '',
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16)),
                                        const SizedBox(height: 4),
                                        Text("${farm['area']} m²",
                                            style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                color: Colors.grey[700])),
                                        Text(farm['location'] ?? '',
                                            style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                color: Colors.grey[700])),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosePage() => Center(
      child: Text("Crop Disease Prediction Coming Soon...",
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey)));

  Widget _buildCropCarePage(BuildContext context) => Center(
      child: Text("Crop Care Tips Coming Soon...",
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey)));

  Widget _buildProfilePage() => Center(
      child: Text("Profile Settings Coming Soon...",
          style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey)));

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomePage(context),
      _buildDiagnosePage(),
      Container(),
      _buildCropCarePage(context),
      _buildProfilePage(),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Camera feature coming soon...")));
        },
        child: Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, blurRadius: 8, offset: const Offset(0, 4))
            ],
          ),
          child: const Icon(Icons.camera_alt, color: Colors.white, size: 32),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: const Icon(Icons.home), onPressed: () => _onItemTapped(0)),
            IconButton(icon: const Icon(Icons.favorite), onPressed: () => _onItemTapped(1)),
            const SizedBox(width: 56),
            IconButton(icon: const Icon(Icons.local_florist), onPressed: () => _onItemTapped(3)),
            IconButton(icon: const Icon(Icons.person), onPressed: () => _onItemTapped(4)),
          ],
        ),
      ),
    );
  }
}

// Custom clipper for curved header
class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 60);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
