import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../features/products/providers/product_provider.dart';
import '../../features/products/models/product_model.dart';
import '../../features/products/data/product_repository.dart';
import 'dart:typed_data'; // For web bytes
import 'package:image_picker/image_picker.dart';
import '../../features/products/models/category_model.dart';

import 'package:responsive_framework/responsive_framework.dart';
import 'widgets/responsive_admin_scaffold.dart';

class AdminProductsPage extends ConsumerStatefulWidget {
  const AdminProductsPage({super.key});

  @override
  ConsumerState<AdminProductsPage> createState() => _AdminProductsPageState();
}

class _AdminProductsPageState extends ConsumerState<AdminProductsPage> {
  bool _showForm = false;
  ProductModel? _editing;

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider(null));
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(DESKTOP);
    final padding = isMobile ? 16.0 : 40.0;

    return ResponsiveAdminScaffold(
      currentRoute: '/admin/products',
      title: 'Products',
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMobile) ...[
              Row(
                children: [
                  Text('Products', style: AppTypography.displaySmall),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () => setState(() {
                      _showForm = true;
                      _editing = null;
                    }),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Product'),
                  ),
                ],
              ),
            ] else
              // Mobile: Add Button is distinct or Floating?
              // For now, keep it simple: Just show the button full width or in a row.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('All Products', style: AppTypography.headlineSmall),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      _showForm = true;
                      _editing = null;
                    }),
                    child: const Text('Add New'),
                  ),
                ],
              ),
            if (_showForm) ...[
              const SizedBox(height: 32),
              _ProductForm(
                product: _editing,
                onSaved: () => setState(() {
                  _showForm = false;
                  _editing = null;
                  ref.invalidate(productsProvider(null));
                }),
                onCancel: () => setState(() {
                  _showForm = false;
                  _editing = null;
                }),
              ),
            ],
            const SizedBox(height: 32),
            productsAsync.when(
              loading: () => const Center(
                  child: CircularProgressIndicator(color: AppColors.primary)),
              error: (e, _) => Text('Error: $e'),
              data: (products) => products.isEmpty
                  ? Text('No products yet. Add one!',
                      style: AppTypography.bodyLarge)
                  : Column(
                      children: products
                          .map((p) => _ProductListTile(
                                product: p,
                                onEdit: () => setState(() {
                                  _editing = p;
                                  _showForm = true;
                                }),
                                onDelete: () async {
                                  await ProductRepository().deleteProduct(p.id);
                                  ref.invalidate(productsProvider(null));
                                },
                              ))
                          .toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductListTile extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProductListTile(
      {required this.product, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor(context),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          if (product.primaryImage.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(product.primaryImage,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                      width: 50, height: 50, color: AppColors.secondary)),
            )
          else
            Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(6)),
                child: const Icon(Icons.bakery_dining,
                    color: AppColors.primary, size: 24)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name, style: AppTypography.labelLarge),
                Text(Formatters.formatPrice(product.price),
                    style: AppTypography.bodySmall),
              ],
            ),
          ),
          if (product.isFeatured)
            Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(4)),
              child: Text('Featured',
                  style:
                      AppTypography.caption.copyWith(color: AppColors.accent)),
            ),
          IconButton(
              icon: const Icon(Icons.edit_outlined, size: 20),
              onPressed: onEdit),
          IconButton(
              icon: const Icon(Icons.delete_outline,
                  size: 20, color: AppColors.error),
              onPressed: onDelete),
        ],
      ),
    );
  }
}

class _ProductForm extends StatefulWidget {
  final ProductModel? product;
  final VoidCallback onSaved;
  final VoidCallback onCancel;
  const _ProductForm(
      {this.product, required this.onSaved, required this.onCancel});

  @override
  State<_ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<_ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _slugCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _descCtrl;
  bool _isFeatured = false;
  bool _isAvailable = true;
  bool _loading = false;
  List<CategoryModel> _categories = [];
  String? _selectedCategoryId;
  XFile? _pickedImage;
  Uint8List? _imageBytes; // For preview/upload

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.product?.name ?? '');
    _slugCtrl = TextEditingController(text: widget.product?.slug ?? '');
    _priceCtrl =
        TextEditingController(text: widget.product?.price.toString() ?? '');
    _descCtrl = TextEditingController(text: widget.product?.description ?? '');
    _isFeatured = widget.product?.isFeatured ?? false;
    _isAvailable = widget.product?.isAvailable ?? true;
    _selectedCategoryId = widget.product?.categoryId;
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final cats = await ProductRepository().fetchCategories();
    if (mounted) setState(() => _categories = cats);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _slugCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  String _toSlug(String name) => name
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      final bytes = await file.readAsBytes();
      setState(() {
        _pickedImage = file;
        _imageBytes = bytes;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final repo = ProductRepository();
    String? imageUrl;

    try {
      // 1. Upload Image if picked
      if (_pickedImage != null && _imageBytes != null) {
        final ext = _pickedImage!.name.split('.').last;
        final filename = '${DateTime.now().millisecondsSinceEpoch}.$ext';
        imageUrl = await repo.uploadProductImage(filename, _imageBytes!);
      }

      final data = {
        'name': _nameCtrl.text.trim(),
        'slug': _slugCtrl.text.trim(),
        'price': double.parse(_priceCtrl.text.trim()),
        'description': _descCtrl.text.trim(),
        'is_featured': _isFeatured,
        'is_available': _isAvailable,
        'category_id': _selectedCategoryId,
      };

      if (imageUrl != null) {
        data['image_url'] = imageUrl;
      }

      if (widget.product != null) {
        await repo.updateProduct(widget.product!.id, data);
      } else {
        await repo.createProduct(data);
      }
      widget.onSaved();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.product != null ? 'Edit Product' : 'Add New Product',
                style: AppTypography.headlineMedium),
            const SizedBox(height: 24),

            // Image Picker
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                    image: _imageBytes != null
                        ? DecorationImage(
                            image: MemoryImage(_imageBytes!), fit: BoxFit.cover)
                        : (widget.product?.primaryImage.isNotEmpty == true &&
                                _pickedImage == null)
                            ? DecorationImage(
                                image:
                                    NetworkImage(widget.product!.primaryImage),
                                fit: BoxFit.cover)
                            : null,
                  ),
                  child: _imageBytes == null &&
                          (widget.product == null ||
                              widget.product!.primaryImage.isEmpty)
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo,
                                color: AppColors.textLight, size: 32),
                            SizedBox(height: 8),
                            Text('Add Photo',
                                style: TextStyle(
                                    color: AppColors.textLight, fontSize: 12)),
                          ],
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Category Dropdown
            DropdownButtonFormField<String>(
              value: _selectedCategoryId,
              items: _categories
                  .map((c) => DropdownMenuItem(
                        value: c.id,
                        child: Text(c.name),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _selectedCategoryId = v),
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category_outlined),
              ),
              validator: (v) => v == null ? 'Select a category' : null,
            ),
            const SizedBox(height: 24),
            Row(children: [
              Expanded(
                child: TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                  onChanged: (v) {
                    if (widget.product == null) {
                      _slugCtrl.text = _toSlug(v);
                    }
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _priceCtrl,
                  decoration: const InputDecoration(labelText: 'Price (₹)'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v == null || double.tryParse(v) == null
                      ? 'Enter valid price'
                      : null,
                ),
              ),
            ]),
            const SizedBox(height: 16),
            TextFormField(
              controller: _slugCtrl,
              decoration: const InputDecoration(labelText: 'URL Slug'),
              validator: (v) => v == null || v.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descCtrl,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('Featured Product'),
              value: _isFeatured,
              onChanged: (v) => setState(() => _isFeatured = v ?? false),
              activeColor: AppColors.primary,
              contentPadding: EdgeInsets.zero,
            ),
            CheckboxListTile(
              title: const Text('Available for Sale'),
              value: _isAvailable,
              onChanged: (v) => setState(() => _isAvailable = v ?? true),
              activeColor: AppColors.success,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 24),
            Row(children: [
              ElevatedButton(
                onPressed: _loading ? null : _save,
                child: _loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : Text(widget.product != null ? 'Update' : 'Save'),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                  onPressed: widget.onCancel, child: const Text('Cancel')),
            ]),
          ],
        ),
      ),
    );
  }
}
