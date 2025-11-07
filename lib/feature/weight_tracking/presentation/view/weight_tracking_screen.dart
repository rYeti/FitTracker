import 'package:ForgeForm/feature/weight_tracking/presentation/providers/weight_provider.dart';
import 'package:ForgeForm/feature/weight_tracking/presentation/widgets/weight_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class WeightTrackingScreen extends StatelessWidget {
  const WeightTrackingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Weight Tracking'),
        actions: [
          IconButton(
            icon: Icon(Icons.flag),
            tooltip: 'Weight Goals',
            onPressed: () {
              Navigator.pushNamed(context, '/weight-goals');
            },
          ),
          PopupMenuButton(
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'goals',
                    child: Text('Set Weight Goals'),
                  ),
                  const PopupMenuItem(
                    value: 'bmi',
                    child: Text('Calculate BMI'),
                  ),
                ],
            onSelected: (value) {
              if (value == 'goals') {
                Navigator.pushNamed(context, '/weight-goals');
              } else if (value == 'bmi') {
                // TODO: Implement BMI calculation
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('BMI Calculator coming soon!')),
                );
              }
            },
          ),
        ],
      ),
      body: Consumer<WeightProvider>(
        builder: (context, weightProvider, _) {
          if (weightProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final weightRecords = weightProvider.weightRecords;

          if (weightRecords.isEmpty) {
            return _buildEmptyState(context, theme);
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Weight',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              '${weightProvider.latestWeightRecord?.weight.toStringAsFixed(1) ?? '--'} kg',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 16),
                            _buildWeightChangeIndicator(weightProvider, theme),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 200,
                      child: WeightChart(weightRecords: weightRecords),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: weightRecords.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final record = weightRecords[index];
                        return ListTile(
                          title: Text(
                            '${record.weight.toStringAsFixed(1)} kg',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            DateFormat('EEEE, MMMM d, y').format(record.date),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed:
                                    () => _showAddEditWeightDialog(
                                      context,
                                      weightProvider,
                                      record: record,
                                    ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed:
                                    () => _confirmDelete(
                                      context,
                                      weightProvider,
                                      record.id,
                                    ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            () => _showAddEditWeightDialog(
              context,
              Provider.of<WeightProvider>(context, listen: false),
            ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.monitor_weight,
            size: 80,
            color: theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text('No weight records yet', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'Add your first weight record to start tracking',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed:
                () => _showAddEditWeightDialog(
                  context,
                  Provider.of<WeightProvider>(context, listen: false),
                ),
            icon: const Icon(Icons.add),
            label: const Text('Add Weight'),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightChangeIndicator(WeightProvider provider, ThemeData theme) {
    final weekChange = provider.getWeightChange(
      period: const Duration(days: 7),
    );

    if (weekChange == 0) {
      return const Text('No change');
    }

    final isGain = weekChange > 0;
    final changeText =
        '${isGain ? '+' : ''}${weekChange.toStringAsFixed(1)} kg';
    final textColor = isGain ? Colors.red : Colors.green;
    final icon = isGain ? Icons.arrow_upward : Icons.arrow_downward;

    return Row(
      children: [
        Icon(icon, color: textColor, size: 16),
        const SizedBox(width: 4),
        Text(
          '$changeText this week',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  void _showAddEditWeightDialog(
    BuildContext context,
    WeightProvider provider, {
    dynamic record,
  }) {
    showDialog(
      context: context,
      builder:
          (context) => AddEditWeightDialog(provider: provider, record: record),
    );
  }

  void _confirmDelete(BuildContext context, WeightProvider provider, int id) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Weight Record'),
            content: const Text(
              'Are you sure you want to delete this weight record?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  provider.deleteWeightRecord(id);
                  Navigator.pop(context);
                },
                child: const Text('DELETE'),
              ),
            ],
          ),
    );
  }
}

class AddEditWeightDialog extends StatefulWidget {
  final WeightProvider provider;
  final dynamic record;

  const AddEditWeightDialog({Key? key, required this.provider, this.record})
    : super(key: key);

  @override
  _AddEditWeightDialogState createState() => _AddEditWeightDialogState();
}

class _AddEditWeightDialogState extends State<AddEditWeightDialog> {
  late TextEditingController _weightController;
  late DateTime _selectedDate;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();

    if (widget.record != null) {
      _weightController = TextEditingController(
        text: widget.record.weight.toString(),
      );
      _selectedDate = widget.record.date;
      _noteController = TextEditingController(text: widget.record.note ?? '');
    } else {
      _weightController = TextEditingController();
      _selectedDate = DateTime.now();
      _noteController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.record != null;
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(isEditing ? 'Edit Weight Record' : 'Add Weight Record'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _weightController,
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
                hintText: 'Enter your weight',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            Text('Date', style: theme.textTheme.bodyLarge),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.dividerColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(DateFormat('MMMM d, y').format(_selectedDate)),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Note (optional)',
                hintText: 'Add a note',
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        TextButton(
          onPressed: () => _saveWeight(isEditing),
          child: Text(isEditing ? 'UPDATE' : 'SAVE'),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _saveWeight(bool isEditing) {
    final weight = double.tryParse(_weightController.text);
    if (weight == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid weight')),
      );
      return;
    }

    if (isEditing) {
      widget.provider.updateWeightRecord(
        id: widget.record.id,
        date: _selectedDate,
        weight: weight,
        note: _noteController.text.isEmpty ? null : _noteController.text,
      );
    } else {
      widget.provider.addWeightRecord(
        date: _selectedDate,
        weight: weight,
        note: _noteController.text.isEmpty ? null : _noteController.text,
      );
    }

    Navigator.pop(context);
  }
}
