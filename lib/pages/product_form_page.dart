import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import '../models/product.dart';

class ProductFormPage extends StatefulWidget {
  final Product? product;

  const ProductFormPage({super.key, this.product});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;

  String? selectedCategory;
  final List<String> categories = ['Beverages', 'Foods', 'Pizza', 'Drink'];

  File? imageFile;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product?.name ?? '');
    priceController = TextEditingController(
      text: widget.product?.price.toString() ?? '',
    );
    descriptionController = TextEditingController(
      text: widget.product?.description ?? '',
    );
    selectedCategory = widget.product?.category ?? categories.first;
  }

  // ===== PILIH GAMBAR =====
  Future<void> _pickImage({bool fromDownload = false}) async {
    if (fromDownload) {
      final downloadPath = '/sdcard/Download';
      final directory = Directory(downloadPath);
      final files = directory.listSync().whereType<File>().toList();

      if (files.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Folder Download kosong')));
        return;
      }

      setState(() => imageFile = files.first);
    } else {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        setState(() => imageFile = File(pickedFile.path));
      }
    }
  }

  // ===== SUBMIT PRODUCT =====
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    bool success;

    if (widget.product == null) {
      success = await ApiService.createProduct(
        name: nameController.text,
        price: priceController.text,
        category: selectedCategory!,
        description: descriptionController.text,
        imageFile: imageFile,
      );
    } else {
      success = await ApiService.updateProduct(
        id: widget.product!.id,
        name: nameController.text,
        price: priceController.text,
        category: selectedCategory!,
        description: descriptionController.text,
        imageFile: imageFile,
      );
    }

    setState(() => isLoading = false);

    if (success && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Product' : 'Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: () => _pickImage(fromDownload: false),
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: imageFile != null
                      ? Image.file(imageFile!, fit: BoxFit.cover)
                      : widget.product?.image != null
                      ? Image.network(
                          'http://10.0.2.2:8000/storage/${widget.product!.image}',
                          fit: BoxFit.cover,
                        )
                      : const Center(child: Text('Tap to select image')),
                ),
              ),

              // ⬇️ JARAK YANG DIMINTA
              const SizedBox(height: 16),

              // ===== NAME INPUT (BALIK LAGI ADA DI SINI) =====
              _input(nameController, 'Name'),

              // ===== CATEGORY =====
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => selectedCategory = v),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),

              const SizedBox(height: 16),

              _input(priceController, 'Price', keyboard: TextInputType.number),
              _input(descriptionController, 'Description', maxLines: 3),

              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(isEdit ? 'Update Product' : 'Create Product'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _input(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboard,
        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}


