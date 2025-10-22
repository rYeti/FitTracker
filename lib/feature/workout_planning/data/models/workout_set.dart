/// Represents a single set within a workout exercise
/// For example: "12 reps at 50kg" or "60 seconds of jumping jacks"
class WorkoutSet {
  final int? id;
  final int
  exerciseInstanceId; // Links to the specific exercise instance in a workout
  final int setNumber; // The sequence of this set (1, 2, 3, etc.)
  final int? reps; // Number of repetitions (null for time-based)
  final double? weight; // Weight used (null for bodyweight)
  final String? weightUnit; // kg, lbs, etc.
  final int? durationSeconds; // Duration in seconds (null for rep-based)
  final bool isCompleted; // Whether this set has been completed
  final String? notes; // Any notes for this specific set

  WorkoutSet({
    this.id,
    required this.exerciseInstanceId,
    required this.setNumber,
    this.reps,
    this.weight,
    this.weightUnit,
    this.durationSeconds,
    this.isCompleted = false,
    this.notes,
  });

  // Convert to Map for database operations
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'exerciseInstanceId': exerciseInstanceId,
      'setNumber': setNumber,
      'reps': reps,
      'weight': weight,
      'weightUnit': weightUnit,
      'durationSeconds': durationSeconds,
      'isCompleted': isCompleted ? 1 : 0,
      'notes': notes,
    };
  }

  // Create from Map (e.g., from database)
  factory WorkoutSet.fromMap(Map<String, dynamic> map) {
    return WorkoutSet(
      id: map['id'],
      exerciseInstanceId: map['exerciseInstanceId'],
      setNumber: map['setNumber'],
      reps: map['reps'],
      weight: map['weight'],
      weightUnit: map['weightUnit'],
      durationSeconds: map['durationSeconds'],
      isCompleted: map['isCompleted'] == 1,
      notes: map['notes'],
    );
  }

  // Clone with ability to override properties
  WorkoutSet copyWith({
    int? id,
    int? exerciseInstanceId,
    int? setNumber,
    int? reps,
    double? weight,
    String? weightUnit,
    int? durationSeconds,
    bool? isCompleted,
    String? notes,
  }) {
    return WorkoutSet(
      id: id ?? this.id,
      exerciseInstanceId: exerciseInstanceId ?? this.exerciseInstanceId,
      setNumber: setNumber ?? this.setNumber,
      reps: reps ?? this.reps,
      weight: weight ?? this.weight,
      weightUnit: weightUnit ?? this.weightUnit,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
    );
  }
}
