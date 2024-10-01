import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Product Model
class Fertilizer {
  final String name;
  final double price;
  final String description;
  final double rating;
  final int reviews;

  Fertilizer({
    required this.name,
    required this.price,
    required this.description,
    required this.rating,
    required this.reviews,
  });
}

// Main Screen
class FertilizerStoreScreen extends StatefulWidget {
  const FertilizerStoreScreen({super.key});

  @override
  _FertilizerStoreScreenState createState() => _FertilizerStoreScreenState();
}

class _FertilizerStoreScreenState extends State<FertilizerStoreScreen> {
  final List<Fertilizer> _fertilizers = [
    Fertilizer(name: 'Urea', price: 500, description: 'A nitrogen-rich fertilizer.', rating: 4.5, reviews: 120),
    Fertilizer(name: 'DAP', price: 1200, description: 'Di-ammonium phosphate fertilizer.', rating: 4.7, reviews: 250),
    Fertilizer(name: 'MOP', price: 900, description: 'Muriate of Potash.', rating: 4.4, reviews: 140),
    Fertilizer(name: 'Super Phosphate', price: 700, description: 'Phosphate fertilizer for plants.', rating: 4.3, reviews: 100),
    Fertilizer(name: 'Ammonium Nitrate', price: 1500, description: 'Quick-release nitrogen fertilizer.', rating: 4.6, reviews: 200),
    Fertilizer(name: 'Gypsum', price: 600, description: 'Improves soil structure.', rating: 4.1, reviews: 80),
    Fertilizer(name: 'Zinc Sulfate', price: 1000, description: 'Micronutrient fertilizer.', rating: 4.5, reviews: 170),
    Fertilizer(name: 'Calcium Nitrate', price: 1400, description: 'Source of calcium and nitrogen.', rating: 4.8, reviews: 300),
  ];

  List<Fertilizer> _cart = [];
  Map<Fertilizer, int> _cartQuantities = {};
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cart');
    if (cartData != null) {
      final List<dynamic> decodedData = jsonDecode(cartData);
      setState(() {
        _cart = decodedData.map((item) => _fertilizers.firstWhere((f) => f.name == item['name'])).toList();
        _cartQuantities = {for (var item in decodedData) _fertilizers.firstWhere((f) => f.name == item['name']): item['quantity']};
      });
    }
  }

  Future<void> _saveCart() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final cartData = _cart.map((item) {
      return {'name': item.name, 'quantity': _cartQuantities[item]};
    }).toList();
    await prefs.setString('cart', jsonEncode(cartData));
  }

  void _addToCart(Fertilizer fertilizer) {
    setState(() {
      if (!_cart.contains(fertilizer)) {
        _cart.add(fertilizer);
        _cartQuantities[fertilizer] = 1;
      } else {
        _cartQuantities[fertilizer] = _cartQuantities[fertilizer]! + 1;
      }
      _saveCart();
    });
  }

  void _removeFromCart(Fertilizer fertilizer) {
    setState(() {
      if (_cartQuantities[fertilizer]! > 1) {
        _cartQuantities[fertilizer] = _cartQuantities[fertilizer]! - 1;
      } else {
        _cart.remove(fertilizer);
        _cartQuantities.remove(fertilizer);
      }
      _saveCart();
    });
  }

  void _clearCart() {
    setState(() {
      _cart.clear();
      _cartQuantities.clear();
      _saveCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final filteredFertilizers = _fertilizers.where((fertilizer) {
      return fertilizer.name.toLowerCase().contains(_searchController.text.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy Fertilizers'),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.green,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(
                    cart: _cart,
                    cartQuantities: _cartQuantities,
                    clearCart: _clearCart,
                    removeFromCart: _removeFromCart,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Fertilizers',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                suffixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.green.withOpacity(0.1),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredFertilizers.length,
              itemBuilder: (context, index) {
                final fertilizer = filteredFertilizers[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(fertilizer: fertilizer, addToCart: _addToCart),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: Text(
                        fertilizer.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        '₹${fertilizer.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_shopping_cart),
                        onPressed: () => _addToCart(fertilizer),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Product Details Screen
class ProductDetailsScreen extends StatelessWidget {
  final Fertilizer fertilizer;
  final void Function(Fertilizer) addToCart;

  const ProductDetailsScreen({super.key, required this.fertilizer, required this.addToCart});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(fertilizer.name),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fertilizer.description,
              style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.white70 : Colors.black87),
            ),
            const SizedBox(height: 16),
            Text(
              'Price: ₹${fertilizer.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black),
            ),
            const SizedBox(height: 16),
            Text(
              'Rating: ${fertilizer.rating} (${fertilizer.reviews} reviews)',
              style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.white70 : Colors.black54),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => addToCart(fertilizer),
                  style: ElevatedButton.styleFrom(backgroundColor: isDarkMode ? Colors.grey[800] : Colors.green),
                  child: const Text('Add to Cart'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle "Buy Now" logic here
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: isDarkMode ? Colors.grey[800] : Colors.green),
                  child: const Text('Buy Now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Cart Screen
class CartScreen extends StatelessWidget {
  final List<Fertilizer> cart;
  final Map<Fertilizer, int> cartQuantities;
  final void Function(Fertilizer) removeFromCart;
  final VoidCallback clearCart;

  const CartScreen({super.key, 
    required this.cart,
    required this.cartQuantities,
    required this.removeFromCart,
    required this.clearCart,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.green,
      ),
      body: cart.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final fertilizer = cart[index];
                final quantity = cartQuantities[fertilizer] ?? 1;

                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(
                      fertilizer.name,
                      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                    ),
                    subtitle: Text(
                      'Quantity: $quantity',
                      style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.remove_shopping_cart),
                      onPressed: () => removeFromCart(fertilizer),
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: clearCart,
            style: ElevatedButton.styleFrom(backgroundColor: isDarkMode ? Colors.grey[800] : Colors.green),
            child: const Text('Clear Cart'),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    theme: ThemeData.light(),
    darkTheme: ThemeData.dark(),
    themeMode: ThemeMode.system, // Automatically switch between light and dark
    home: const FertilizerStoreScreen(),
  ));
}
