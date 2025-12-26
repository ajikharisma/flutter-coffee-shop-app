import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import 'product_form_page.dart';
import 'detail_page.dart'; // ⬅️ TAMBAHAN IMPORT

class ProductListPage extends StatefulWidget {
  final String categoryName;

  const ProductListPage({super.key, required this.categoryName});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage>
    with SingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  late TabController _tabController;

  List<Product> allProducts = [];
  List<Product> filteredProducts = [];

  final List<String> categories = [
    "All",
    "Beverages",
    "Foods",
    "Pizza",
    "Drink",
  ];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: categories.length, vsync: this);

    final index = categories.indexOf(widget.categoryName);
    if (index != -1) {
      _tabController.index = index;
    }

    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await ApiService.getProducts();

      List<Product> result = products;

      if (widget.categoryName != "All") {
        result = products
            .where((p) => p.category == widget.categoryName)
            .toList();
      }

      setState(() {
        allProducts = products;
        filteredProducts = result;
        isLoading = false;
      });
    } catch (e) {
      isLoading = false;
      setState(() {});
    }
  }

  void _searchProduct(String query) {
    setState(() {
      filteredProducts = allProducts
          .where(
            (p) =>
                p.name.toLowerCase().contains(query.toLowerCase()) &&
                (widget.categoryName == "All" ||
                    p.category == widget.categoryName),
          )
          .toList();
    });
  }

  List<Product> _filterByCategory(String category) {
    if (category == "All") return allProducts;
    return allProducts.where((p) => p.category == category).toList();
  }

  void _deleteProduct(Product product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Product"),
        content: Text("Delete '${product.name}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ApiService.deleteProduct(product.id);
      _loadProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProductFormPage()),
          ).then((reload) {
            if (reload == true) _loadProducts();
          });
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    widget.categoryName == "All"
                        ? "All Products"
                        : widget.categoryName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: searchController,
                onChanged: _searchProduct,
                decoration: const InputDecoration(
                  hintText: "Search product...",
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),

            const SizedBox(height: 10),

            TabBar(
              controller: _tabController,
              isScrollable: true,
              onTap: (index) {
                final selected = categories[index];
                setState(() {
                  filteredProducts = _filterByCategory(selected);
                });
              },
              tabs: categories.map((e) => Tab(text: e)).toList(),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredProducts.isEmpty
                  ? const Center(child: Text("No products"))
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredProducts.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.73,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailPage(product: product),
                              ),
                            );
                          },
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 6,
                                    ),
                                  ],
                                  color: Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(18),
                                      ),
                                      child:
                                          product.image != null &&
                                              product.image!.isNotEmpty
                                          ? Image.network(
                                              'http://10.0.2.2:8000/storage/${product.image}',
                                              height: 120,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              'assets/images/placeholder.png',
                                              height: 120,
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
                                          Text(
                                            product.name,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            product.category,
                                            style: const TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            "\$${product.price}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Positioned(
                                top: 8,
                                right: 8,
                                child: InkWell(
                                  onTap: () => _deleteProduct(product),
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ),

                              Positioned(
                                top: 8,
                                left: 8,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ProductFormPage(product: product),
                                      ),
                                    ).then((reload) {
                                      if (reload == true) _loadProducts();
                                    });
                                  },
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
