import 'package:supabase_flutter/supabase_flutter.dart';
import '../constants/supabase_constants.dart';

class SeedData {
  static final _client = Supabase.instance.client;

  static Future<void> seed() async {
    // 1. Categories
    final categories = [
      {'id': 'cat_cakes', 'name': 'Cakes'},
      {'id': 'cat_savouries', 'name': 'Savouries'},
      {'id': 'cat_cookies', 'name': 'Cookies'},
      {'id': 'cat_breads', 'name': 'Breads'},
    ];

    for (final c in categories) {
      // Create if not exists (upsert)
      await _client.from(SupabaseConstants.categoriesTable).upsert(c);
    }

    // 2. Products
    final products = [
      {
        'name': 'Chocolate Truffle Cake',
        'description':
            'Rich dark chocolate ganache layers. A classic celebration cake.',
        'price': 45000, // 450.00
        'category_id': 'cat_cakes',
        'is_available': true,
        'is_featured': true,
        'slug': 'chocolate-truffle-cake',
        'image_url':
            'https://sallysbakingaddiction.com/wp-content/uploads/2013/04/triple-chocolate-cake-4.jpg'
      },
      {
        'name': 'Red Velvet Cake',
        'description': 'Soft red velvet sponge with cream cheese frosting.',
        'price': 50000, // 500.00
        'category_id': 'cat_cakes',
        'is_available': true,
        'is_featured': true,
        'slug': 'red-velvet-cake',
        'image_url':
            'https://sallysbakingaddiction.com/wp-content/uploads/2013/04/triple-chocolate-cake-4.jpg' // Placeholder
      },
      {
        'name': 'Butterscotch Cake',
        'description': 'Crunchy praline and caramel glaze.',
        'price': 40000, // 400.00
        'category_id': 'cat_cakes',
        'is_available': true,
        'is_featured': false,
        'slug': 'butterscotch-cake',
        'image_url':
            'https://sallysbakingaddiction.com/wp-content/uploads/2013/04/triple-chocolate-cake-4.jpg' // Placeholder
      },
      {
        'name': 'Paneer Puff',
        'description': 'Flaky pastry filled with spiced paneer.',
        'price': 4500, // 45.00
        'category_id': 'cat_savouries',
        'is_available': true,
        'is_featured': false,
        'slug': 'paneer-puff',
        'image_url':
            'https://sallysbakingaddiction.com/wp-content/uploads/2013/04/triple-chocolate-cake-4.jpg' // Placeholder
      },
      {
        'name': 'Chicken Roll',
        'description': 'Spicy chicken filling in a soft roll.',
        'price': 6000, // 60.00
        'category_id': 'cat_savouries',
        'is_available': true,
        'is_featured': true,
        'slug': 'chicken-roll',
        'image_url':
            'https://sallysbakingaddiction.com/wp-content/uploads/2013/04/triple-chocolate-cake-4.jpg' // Placeholder
      },
      {
        'name': 'Almond Cookies',
        'description': 'Buttery cookies with roasted almonds.',
        'price': 20000, // 200.00
        'category_id': 'cat_cookies',
        'is_available': true,
        'is_featured': true,
        'slug': 'almond-cookies',
        'image_url':
            'https://sallysbakingaddiction.com/wp-content/uploads/2013/04/triple-chocolate-cake-4.jpg' // Placeholder
      },
    ];

    for (final p in products) {
      // Upsert by slug (requires unique constraint on slug, or we use name?)
      // We assume slug is unique or we replace.
      // Upsert requires primary key match. 'slug' is likely unique but ID is usually PK.
      // If we don't provide ID, it tries to insert. If slug conflict, it might fail unless we specify conflict target.
      // But Supabase client upsert handles it if we specify onConflict.
      await _client
          .from(SupabaseConstants.productsTable)
          .upsert(p, onConflict: 'slug');
    }
  }
}
