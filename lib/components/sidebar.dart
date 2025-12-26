import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../pages/main_page.dart';
import '../pages/product_list_page.dart';
import '../screens/welcome_screen.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 240,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Main Menu',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _menu(
                    context,
                    'assets/images/svg/icons/home_icon.svg',
                    'Home',
                    () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const MainPage()),
                    ),
                  ),
                  _menu(
                    context,
                    'assets/images/svg/icons/shop_cart_icon.svg',
                    'Products',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const ProductListPage(categoryName: 'All'),
                      ),
                    ),
                  ),
                  _menu(
                    context,
                    'assets/images/svg/icons/logout_icon.svg',
                    'Logout',
                    () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const WelcomeScreen(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menu(
    BuildContext context,
    String icon,
    String title,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: SvgPicture.asset(icon, width: 22),
      title: Text(title),
      onTap: onTap,
    );
  }
}
