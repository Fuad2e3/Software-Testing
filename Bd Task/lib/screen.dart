import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'db_helper.dart';

class Screen extends StatefulWidget {
  final String token;
  const Screen({super.key, required this.token});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  List<Map<String, dynamic>> _foodItems = [];
  bool _isLoading = true;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _fetchAndLoadData();
  }

  Future<void> _fetchAndLoadData() async {
    try {
      final response = await http.post(
        Uri.parse('http://159.65.141.100/v2/pos/foodlist'),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'id': '0',
          'CategoryID': '0',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          List foodList = data['data']['foodinfo'];
          List<Map<String, dynamic>> items = foodList.map((e) => e as Map<String, dynamic>).toList();
          
          final mappedItems = items.map((e) => {
            'id': e['ProductsID'],
            'name': e['ProductName'],
            'image': e['ProductImage'],
            'price': e['price'],
          }).toList();

          // Save based on platform
          if (kIsWeb) {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('offline_food_list', json.encode(mappedItems));
          } else {
            await _dbHelper.insertFoodItems(items);
          }
          
          if (mounted) {
            setState(() {
              _foodItems = mappedItems;
              _isLoading = false;
            });
          }
          return;
        }
      }
    } catch (e) {
      debugPrint('Exception during fetch: $e');
    }

    _loadLocalData();
  }

  Future<void> _loadLocalData() async {
    List<Map<String, dynamic>> localItems = [];
    
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final String? encodedData = prefs.getString('offline_food_list');
      if (encodedData != null) {
        localItems = List<Map<String, dynamic>>.from(json.decode(encodedData));
      }
    } else {
      localItems = await _dbHelper.getFoodItems();
    }

    if (mounted) {
      setState(() {
        _foodItems = localItems;
        _isLoading = false;
      });
      if (localItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No data available offline.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Loaded from offline storage.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Food List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => _isLoading = true);
              _fetchAndLoadData();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _foodItems.isEmpty
              ? const Center(child: Text("No food items found."))
              : ListView.builder(
                  itemCount: _foodItems.length,
                  itemBuilder: (context, index) {
                    final item = _foodItems[index];
                    return ListTile(
                      leading: Image.network(
                        item['image'] ?? '',
                        width: 50,
                        height: 50,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.fastfood),
                      ),
                      title: Text(item['name'] ?? 'Unknown'),
                      subtitle: Text('\$${item['price'] ?? '0.00'}'),
                    );
                  },
                ),
    );
  }
}