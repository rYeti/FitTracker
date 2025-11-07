import 'package:ForgeForm/core/app_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/meal_template.dart';
import '../../data/repositories/meal_template_repository.dart';
import '../../data/repositories/nutrition_repository.dart';
import 'food_tracking_screen.dart';
import 'create_meal_template_screen.dart';
import 'edit_meal_template_screen.dart';

class MealTemplatesScreen extends StatefulWidget {
  const MealTemplatesScreen({Key? key}) : super(key: key);

  @override
  State<MealTemplatesScreen> createState() => _MealTemplatesScreenState();
}

class _MealTemplatesScreenState extends State<MealTemplatesScreen> {
  // Use a simple key for the TabController
  final GlobalKey _tabControllerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      key: _tabControllerKey,
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Meal Templates'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Breakfast'),
              Tab(text: 'Lunch'),
              Tab(text: 'Dinner'),
              Tab(text: 'Snacks'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TemplateListTab(category: 'Breakfast'),
            TemplateListTab(category: 'Lunch'),
            TemplateListTab(category: 'Dinner'),
            TemplateListTab(category: 'Snack'),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // Navigate to create template screen and refresh when returning
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CreateMealTemplateScreen(),
              ),
            );

            // If a template was created (result is true), rebuild the screen
            if (result == true && context.mounted) {
              // Force a refresh by calling setState
              setState(() {
                // This will rebuild the widget with fresh data
              });
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class TemplateListTab extends StatefulWidget {
  final String category;

  const TemplateListTab({Key? key, required this.category}) : super(key: key);

  @override
  State<TemplateListTab> createState() => _TemplateListTabState();
}

class _TemplateListTabState extends State<TemplateListTab>
    with AutomaticKeepAliveClientMixin {
  // This ensures the state is preserved when switching tabs
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final repository = Provider.of<MealTemplateRepository>(context);

    return RefreshIndicator(
      onRefresh: () async {
        // Force a rebuild
        setState(() {});
      },
      child: FutureBuilder<List<MealTemplate>>(
        // Use the key to force refresh when needed
        key: ValueKey(
          'templates-${widget.category}-${DateTime.now().millisecondsSinceEpoch}',
        ),
        future: repository.getTemplatesByCategory(widget.category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final templates = snapshot.data ?? [];

          if (templates.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No templates found'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => CreateMealTemplateScreen(
                                initialCategory: widget.category,
                              ),
                        ),
                      );

                      if (result == true && mounted) {
                        setState(() {});
                      }
                    },
                    child: const Text('Create Template'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: templates.length,
            itemBuilder: (context, index) {
              final template = templates[index];
              return TemplateCard(
                template: template,
                onDelete: () {
                  setState(() {}); // Refresh after delete
                },
              );
            },
          );
        },
      ),
    );
  }
}

class TemplateCard extends StatelessWidget {
  final MealTemplate template;
  final VoidCallback? onDelete;

  const TemplateCard({Key? key, required this.template, this.onDelete})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          // Navigate to template detail or show dialog to apply template
          _showApplyTemplateDialog(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    template.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  PopupMenuButton(
                    itemBuilder:
                        (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                    onSelected: (value) async {
                      if (value == 'edit') {
                        // Navigate to edit template screen
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    EditMealTemplateScreen(template: template),
                          ),
                        );

                        // If template was updated (result is true), trigger a rebuild
                        if (result == true && onDelete != null) {
                          onDelete!(); // Use the same callback as delete to refresh
                        }
                      } else if (value == 'delete') {
                        _confirmDeleteTemplate(context);
                      }
                    },
                  ),
                ],
              ),
              if (template.description != null &&
                  template.description!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(template.description!),
              ],
              const SizedBox(height: 8),
              Text('${template.items.length} items'),
              const SizedBox(height: 4),
              Text('${template.totalCalories.toStringAsFixed(0)} calories'),
            ],
          ),
        ),
      ),
    );
  }

  void _showApplyTemplateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Apply Template'),
            content: const Text(
              'Would you like to add these foods to your meal diary?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);

                  // Use the database instance from Provider
                  final db = Provider.of<AppDatabase>(context, listen: false);
                  final nutritionRepository = NutritionRepository(db);

                  // Debug logging
                  print(
                    'Applying template: ${template.name} with ${template.items.length} items',
                  );
                  print('Template category: ${template.category}');

                  // Apply the template to the meal diary
                  try {
                    await nutritionRepository.applyTemplateToMeal(
                      template.category,
                      template.items,
                    );

                    print('Template applied successfully');

                    // Show success message and navigate back to food tracking screen to see changes
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${template.name} applied to ${template.category}',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );

                      // Navigate back to the food tracking screen
                      Navigator.of(context).popUntil((route) => route.isFirst);

                      // Use a better approach to refresh the food tracking data
                      // Get the current state of the food tracking screen and trigger a refresh
                      final currentState = globalFoodTrackingKey.currentState;
                      if (currentState != null) {
                        // Directly refresh the food tracking screen
                        currentState.loadNutritionData();
                        print('Refreshed food tracking screen directly');
                      } else {
                        print('Could not find food tracking screen state');
                        // As a fallback, still navigate to the home screen
                        if (context.mounted) {
                          Navigator.of(context).pushReplacementNamed('/');
                        }
                      }
                    }
                  } catch (e) {
                    // Debug log the error
                    print('Error applying template: $e');

                    // Show error message
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error applying template: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
                child: const Text('APPLY'),
              ),
            ],
          ),
    );
  }

  void _confirmDeleteTemplate(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Template'),
            content: const Text(
              'Are you sure you want to delete this template?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Delete the template
                  final repository = Provider.of<MealTemplateRepository>(
                    context,
                    listen: false,
                  );
                  repository.deleteMealTemplate(template.id!);

                  // Call the onDelete callback if provided
                  if (onDelete != null) {
                    onDelete!();
                  }
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('DELETE'),
              ),
            ],
          ),
    );
  }
}
