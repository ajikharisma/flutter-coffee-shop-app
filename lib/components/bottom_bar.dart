import 'package:flutter/material.dart';
import '../pages/product_list_page.dart';

class BottomNavOverlay extends StatefulWidget {
  final int? selectedIndex;
  final Function(int)? onItemTapped;

  const BottomNavOverlay({super.key, this.selectedIndex, this.onItemTapped});

  @override
  State<BottomNavOverlay> createState() => _BottomNavOverlayState();
}

class _BottomNavOverlayState extends State<BottomNavOverlay> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex ?? 0;
  }

  void _handleTap(int index) {
    if (!mounted) return;

    setState(() {
      _selectedIndex = index;
    });

    widget.onItemTapped?.call(index);

    // HOME → tidak pindah halaman
    if (index == 0) return;

    // STORE → ke Product List
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const ProductListPage(categoryName: 'All'),
        ),
      ).then((_) {
        if (!mounted) return;
        setState(() => _selectedIndex = 0);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color activeColor = Color(0xFF3E1F47);
    const Color inactiveColor = Colors.grey;

    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIcon(Icons.home_outlined, 0, activeColor, inactiveColor),
          _buildIcon(Icons.favorite_border, 1, activeColor, inactiveColor),
          _buildIcon(Icons.storefront_outlined, 2, activeColor, inactiveColor),
          _buildIcon(Icons.settings_outlined, 3, activeColor, inactiveColor),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon, int index, Color active, Color inactive) {
    return GestureDetector(
      onTap: () => _handleTap(index),
      child: Icon(
        icon,
        size: 28,
        color: _selectedIndex == index ? active : inactive,
      ),
    );
  }
}
