import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../components/bottom_bar.dart';
import '../services/api_service.dart';
import '../models/product.dart';
import 'product_list_page.dart';
import 'detail_page.dart';
import '../screens/welcome_screen.dart'; // ✅ TAMBAHAN

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  String userName = '';
  List<Product> latestProducts = [];

  @override
  void initState() {
    super.initState();
    _loadUser();
    _loadLatestProducts();
  }

  Future<void> _loadUser() async {
    final name = await ApiService.getUserName();
    setState(() {
      userName = name?.isNotEmpty == true ? name! : 'User';
    });
  }

  Future<void> _loadLatestProducts() async {
    try {
      final products = await ApiService.getProducts();
      setState(() {
        latestProducts = products.reversed.take(4).toList();
      });
    } catch (e) {
      latestProducts = [];
    }
  }

  // ✅ TAMBAHAN LOGOUT (AMAN, TIDAK PANGGIL API)
  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== HEADER + LOGOUT =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Good Morning",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              userName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(34, 34, 34, 1),
                              ),
                            ),
                          ],
                        ),

                        IconButton(
                          icon: const Icon(Icons.logout, color: Colors.black54),
                          onPressed: _logout,
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      "Promotion",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(34, 34, 34, 1),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 185,
                      child: PageView(
                        controller: PageController(viewportFraction: 0.9),
                        children: [
                          _promoCard(
                            title: "Hot Mocha\nCappuccino Latte",
                            price: "\$5.8",
                            oldPrice: "\$9.9",
                            image: "assets/images/pic1.png",
                          ),
                          _promoCard(
                            title: "Hot Sweet\nIndonesian Tea",
                            price: "\$2.5",
                            oldPrice: "\$5.4",
                            image: "assets/images/pic2.png",
                          ),
                          _promoCard(
                            title: "Mocha Coffee\nCreamy Milky",
                            price: "\$2.5",
                            oldPrice: "\$5.4",
                            image: "assets/images/pic1.png",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Categories",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(34, 34, 34, 1),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const ProductListPage(categoryName: 'All'),
                              ),
                            );
                          },
                          child: const Text(
                            "More",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(74, 55, 73, 1),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),

                    SizedBox(
                      height: 150,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _categoryCard("Beverages", "assets/images/kopi.svg"),
                          _categoryCard("Foods", "assets/images/burger.svg"),
                          _categoryCard("Pizza", "assets/images/pizza.svg"),
                          _categoryCard("Drink", "assets/images/drink.svg"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    if (latestProducts.isNotEmpty) ...[
                      const Text(
                        "Latest Products",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(34, 34, 34, 1),
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: latestProducts.length,
                          itemBuilder: (context, index) {
                            final product = latestProducts[index];
                            return _buildFeaturedCard(
                              image: product.image != null
                                  ? 'http://10.0.2.2:8000/storage/${product.image}'
                                  : 'assets/images/pic1.png',
                              category: product.category,
                              name: product.name,
                              price: "\$${product.price}",
                              rating: 4.5,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        DetailPage(product: product),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            BottomNavOverlay(
              selectedIndex: _selectedIndex,
              onItemTapped: (index) => setState(() => _selectedIndex = index),
            ),
          ],
        ),
      ),
    );
  }

  // ===== SEMUA METHOD DI BAWAH TIDAK DIUBAH =====

  Widget _promoCard({
    required String title,
    required String price,
    required String oldPrice,
    required String image,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF4A3749), Color(0xFF24182E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: -60,
            left: -60,
            child: _softCircle(150, Colors.white.withOpacity(0.08)),
          ),
          Positioned(
            bottom: -60,
            right: -60,
            child: _softCircle(150, Colors.white.withOpacity(0.08)),
          ),
          Positioned(
            top: 10,
            right: 85,
            child: _softCircle(30, Colors.white.withOpacity(0.12)),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Image.asset(
              "assets/images/card-bg.png",
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              color: Colors.white.withOpacity(0.05),
              colorBlendMode: BlendMode.srcOver,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          price,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          oldPrice,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Image.asset(image, height: 140, fit: BoxFit.contain),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _softCircle(double size, Color color) => Container(
    height: size,
    width: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );

  Widget _categoryCard(String title, String svgPath) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductListPage(categoryName: title),
          ),
        );
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            colors: [Color(0xFF4A3749), Color(0xFF24182E)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(svgPath, height: 32, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedCard({
    required String image,
    required String category,
    required String name,
    required String price,
    required double rating,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.network(
                image,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A3749),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


