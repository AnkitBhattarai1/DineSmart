import 'package:flutter/material.dart';
import 'restaurants.dart';
import 'menu.dart';
import 'bottomnavigationbar.dart'; // Import the BottomNavigationBarWidget

class RestaurantProfilePage extends StatefulWidget {
  final Restaurant restaurant;

  RestaurantProfilePage({required this.restaurant});

  @override
  _RestaurantProfilePageState createState() => _RestaurantProfilePageState();
}

class _RestaurantProfilePageState extends State<RestaurantProfilePage> {
  late MenuCategory _selectedCategory;
  late Map<int, int> _itemQuantities; // Map to store quantity for each item

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.restaurant.menu.first;
    _itemQuantities = Map.fromIterable(
      _selectedCategory.items,
      key: (item) => item.id,
      value: (item) => 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.restaurant.name),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(widget.restaurant.coverImage),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ClipOval(
                          child: Container(
                            color: Colors.white,
                            child: Image.asset(
                              widget.restaurant.logo,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      widget.restaurant.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (MenuCategory category in widget.restaurant.menu)
                          CategoryButton(
                            category: category,
                            isSelected: category == _selectedCategory,
                            onPressed: () {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ];
        },
        body: ListView.builder(
          itemCount: _selectedCategory.items.length,
          itemBuilder: (context, index) {
            final item = _selectedCategory.items[index];
            return MenuItemWidget(
              item: item,
              quantity:
                  _itemQuantities[item.id] ?? 0, // Pass quantity for the item
              onQuantityChanged: (newQuantity) {
                setState(() {
                  _itemQuantities[item.id] = newQuantity; // Update quantity
                });
              },
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBarWidget(
        selectedIndex: 0, // Set the appropriate index for the selected tab
        onItemTapped: (index) {}, // Define the functionality for tapping items
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final MenuCategory category;
  final bool isSelected;
  final VoidCallback onPressed;

  CategoryButton({
    required this.category,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue : Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          category.name,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class MenuItemWidget extends StatelessWidget {
  final MenuItem item;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  MenuItemWidget({
    required this.item,
    required this.quantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '\$${item.price.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 31), // Add SizedBox with width 31 pixels
                Row(
                  children: [
                    IconButton(
                      iconSize: 20,
                      onPressed: () {
                        onQuantityChanged(quantity - 1); // Decrease quantity
                      },
                      icon: Icon(Icons.remove),
                    ),
                    Text(
                      quantity.toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      iconSize: 20,
                      onPressed: () {
                        onQuantityChanged(quantity + 1); // Increase quantity
                      },
                      icon: Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
