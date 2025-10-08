import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:fittnes_tracker/core/app_database.dart';
import '../../data/models/meal_template.dart';
import '../../data/repositories/meal_template_repository.dart';
import '../widgets/food_search_screen.dart';
import 'barcode_scanner_view.dart';
import '../../data/models/food_item_model.dart';

class CreateMealTemplateScreen extends StatefulWidget {
  final String? initialCategory;

  const CreateMealTemplateScreen({Key? key, this.initialCategory})
    : super(key: key);

  @override
  State<CreateMealTemplateScreen> createState() =>
      _CreateMealTemplateScreenState();
}

class _CreateMealTemplateScreenState extends State<CreateMealTemplateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedCategory = 'Breakfast';
  List<MealTemplateItem> _selectedFoods = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      _selectedCategory = widget.initialCategory!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Meal Template')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Template Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              value: _selectedCategory,
              items:
                  ['Breakfast', 'Lunch', 'Dinner', 'Snack']
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text(
                  'Foods',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _scanBarcode,
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('Scan'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.deepPurple,
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _addFood,
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // List of selected foods
            ..._buildFoodsList(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveTemplate,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor:
                    Colors.white, // Explicitly set text color to white
                textStyle: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ), // Make text more visible
              ),
              child: const Text('Save Template'),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFoodsList() {
    if (_selectedFoods.isEmpty) {
      return [
        const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('No foods added yet'),
          ),
        ),
      ];
    }

    return _selectedFoods.map((food) {
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          title: Text(food.foodName),
          subtitle: Text(
            '${food.quantity} ${food.unit} • ${food.calories.toStringAsFixed(0)} cal',
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              setState(() {
                _selectedFoods.remove(food);
              });
            },
          ),
        ),
      );
    }).toList();
  }

  void _addFood() async {
    // Navigate to food selection screen and get back selected food
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => const FoodSearchScreen(allowMultipleSelection: true),
      ),
    );

    if (result != null && result is List<FoodItemData>) {
      setState(() {
        // Convert FoodItemData to MealTemplateItem
        _selectedFoods.addAll(
          result.map(
            (food) => MealTemplateItem(
              templateId: -1, // Temporary value
              foodId: food.id,
              foodName: food.name,
              quantity: food.gramm.toDouble(),
              unit: 'g',
              calories: food.calories.toDouble(),
              protein: food.protein.toDouble(),
              carbs: food.carbs.toDouble(),
              fat: food.fat.toDouble(),
            ),
          ),
        );
      });
    }
  }

  void _scanBarcode() async {
    // Don't allow barcode scanning on web or desktop
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Barcode scanning is not supported on web'),
        ),
      );
      return;
    }

    try {
      // Navigate to barcode scanner screen with isTemplate flag set to true
      final scannedFood = await Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => BarcodeScannerView(
                category: _selectedCategory,
                isTemplate:
                    true, // Set this to true to indicate we're adding to template
              ),
        ),
      );

      // If a food item was scanned and returned
      if (scannedFood != null) {
        // Convert scanned food (likely FoodItemModel) to MealTemplateItem
        if (scannedFood is FoodItemModel) {
          setState(() {
            _selectedFoods.add(
              MealTemplateItem(
                templateId: -1, // Temporary value
                foodId: scannedFood.id ?? 0, // Use 0 if ID is null
                foodName: scannedFood.name,
                quantity: scannedFood.gramm.toDouble(),
                unit: 'g',
                calories: scannedFood.calories.toDouble(),
                protein: scannedFood.protein.toDouble(),
                carbs: scannedFood.carbs.toDouble(),
                fat: scannedFood.fat.toDouble(),
              ),
            );
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${scannedFood.name} added to template'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (scannedFood is FoodItemData) {
          // Handle if it's a FoodItemData object instead
          setState(() {
            _selectedFoods.add(
              MealTemplateItem(
                templateId: -1, // Temporary value
                foodId: scannedFood.id,
                foodName: scannedFood.name,
                quantity: scannedFood.gramm.toDouble(),
                unit: 'g',
                calories: scannedFood.calories.toDouble(),
                protein: scannedFood.protein.toDouble(),
                carbs: scannedFood.carbs.toDouble(),
                fat: scannedFood.fat.toDouble(),
              ),
            );
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${scannedFood.name} added to template'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error scanning barcode: $e');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error scanning barcode: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _saveTemplate() {
    if (_formKey.currentState!.validate()) {
      if (_selectedFoods.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one food')),
        );
        return;
      }

      final template = MealTemplate(
        name: _nameController.text,
        description: _descriptionController.text,
        category: _selectedCategory,
        items: _selectedFoods,
      );

      final repository = Provider.of<MealTemplateRepository>(
        context,
        listen: false,
      );
      repository
          .createMealTemplate(template)
          .then((_) {
            Navigator.pop(context, true); // Return success
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Template created successfully')),
            );
          })
          .catchError((error) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: $error')));
          });
    }
  }
}
