// cart.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'address.dart'; // Import AddressPage
import 'payment.dart'; // Import PaymentPage

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> items; // List of items in the cart
  final String restaurantName; // Name of the restaurant
  final Function(int, int)
      updateItemQuantity; // Function to update item quantity

  CartPage(
      {Key? key,
      required this.items,
      required this.restaurantName,
      required this.updateItemQuantity})
      : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int _selectedIndex = 0; // Set the initial index to Cart

  // Variables to store address details
  String name = '';
  String address = '';

  double getTotalAmount() {
    double total = 0.0;
    for (var item in widget.items) {
      total += item['price'] * item['quantity'];
    }
    return total;
  }

  String getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Cart';
      case 1:
        return 'Address';
      case 2:
        return 'Payment';
      default:
        return 'Cart';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(getAppBarTitle(),
            style: TextStyle(
                color: themeNotifier.currentTheme.textTheme.titleLarge?.color)),
        backgroundColor: themeNotifier.currentTheme.appBarTheme.backgroundColor,
        elevation: 4,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0), // Adjust the height as needed
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildNavItem(Icons.shopping_bag, 'Cart', 0),
                buildNavItem(Icons.location_on, 'Address', 1),
                buildNavItem(Icons.payment, 'Payment', 2),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.9),
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 143, 202, 87),
                  blurRadius: 7,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            margin: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Amount:',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  '\$${getTotalAmount().toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: _selectedIndex == 0
                ? buildCartItems() // Show cart items
                : _selectedIndex == 1
                    ? AddressPage() // Show address page
                    : PaymentPage(), // Show payment page
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onPressed: () {
                if (_selectedIndex == 0) {
                  Navigator.pop(context); // Go back to the previous screen
                } else if (_selectedIndex == 1) {
                  setState(() {
                    _selectedIndex = 0; // Move back to cart
                  });
                } else if (_selectedIndex == 2) {
                  setState(() {
                    _selectedIndex = 1; // Move back to address details
                  });
                }
              },
              child: Text('Back'),
            ),
            if (_selectedIndex == 0 &&
                widget.items.isNotEmpty) // Check if cart is not empty
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    widget.items.clear(); // Clear the cart
                    // Update quantities to zero in RestaurantProfilePage
                    for (var item in widget.items) {
                      widget.updateItemQuantity(item['id'], 0);
                    }
                  });
                },
                child: Text('ClearCart'),
              ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onPressed: () {
                if (_selectedIndex == 0) {
                  if (widget.items.isNotEmpty) {
                    // Check if cart is not empty
                    setState(() {
                      _selectedIndex = 1; // Move to address details
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Cart is Empty'),
                      ),
                    );
                  }
                } else if (_selectedIndex == 1) {
                  setState(() {
                    _selectedIndex = 2; // Move to payment options
                  });
                } else if (_selectedIndex == 2) {
                  // Handle checkout functionality
                  // For example: _handleCheckout();
                }
              },
              child: Text(_selectedIndex == 2 ? 'Checkout' : 'Continue'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNavItem(IconData icon, String label, int index) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    Color getTextColor() {
      if (themeNotifier.currentTheme.brightness == Brightness.light) {
        return Colors.black; // Black when in light mode and not selected
      } else {
        return Colors.white; // White when in dark mode and not selected
      }
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index; // Icon clicked
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _selectedIndex == index
                  ? Colors.blueAccent // Change color if selected
                  : Colors.grey,
            ),
            child: IconButton(
              icon: Icon(icon, color: getTextColor()),
              onPressed: () {
                // No functionality needed here as GestureDetector handles it
              },
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12.0, color: getTextColor()),
          ),
        ],
      ),
    );
  }

  Widget buildCartItems() {
    return widget.items.isNotEmpty
        ? Flexible(
            child: ListView.builder(
              itemCount: widget.items.length,
              itemBuilder: (context, index) {
                final item = widget.items[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Card(
                    elevation: 8,
                    margin: EdgeInsets.symmetric(horizontal: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      title: Text(
                        item['name'],
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Restaurant: ${widget.restaurantName}',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            'Price: \$${item['price']}',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              setState(() {
                                if (item['quantity'] > 1) {
                                  item['quantity']--;
                                  // Update quantity in RestaurantProfilePage
                                  widget.updateItemQuantity(
                                      item['id'], item['quantity']);
                                }
                              });
                            },
                          ),
                          Text(
                            '${item['quantity']}',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_circle_outline),
                            onPressed: () {
                              setState(() {
                                item['quantity']++;
                                // Update quantity in RestaurantProfilePage
                                widget.updateItemQuantity(
                                    item['id'], item['quantity']);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        : Center(
            child: Text(
              'Your cart is empty!',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          );
  }
}
