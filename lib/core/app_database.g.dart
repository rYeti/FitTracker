// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $FoodItemTable extends FoodItem
    with TableInfo<$FoodItemTable, FoodItemData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodItemTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caloriesMeta = const VerificationMeta(
    'calories',
  );
  @override
  late final GeneratedColumn<int> calories = GeneratedColumn<int>(
    'calories',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinMeta = const VerificationMeta(
    'protein',
  );
  @override
  late final GeneratedColumn<int> protein = GeneratedColumn<int>(
    'protein',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbsMeta = const VerificationMeta('carbs');
  @override
  late final GeneratedColumn<int> carbs = GeneratedColumn<int>(
    'carbs',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fatMeta = const VerificationMeta('fat');
  @override
  late final GeneratedColumn<int> fat = GeneratedColumn<int>(
    'fat',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _grammMeta = const VerificationMeta('gramm');
  @override
  late final GeneratedColumn<int> gramm = GeneratedColumn<int>(
    'gramm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(100),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    calories,
    protein,
    carbs,
    fat,
    gramm,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'food_item';
  @override
  VerificationContext validateIntegrity(
    Insertable<FoodItemData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('calories')) {
      context.handle(
        _caloriesMeta,
        calories.isAcceptableOrUnknown(data['calories']!, _caloriesMeta),
      );
    } else if (isInserting) {
      context.missing(_caloriesMeta);
    }
    if (data.containsKey('protein')) {
      context.handle(
        _proteinMeta,
        protein.isAcceptableOrUnknown(data['protein']!, _proteinMeta),
      );
    } else if (isInserting) {
      context.missing(_proteinMeta);
    }
    if (data.containsKey('carbs')) {
      context.handle(
        _carbsMeta,
        carbs.isAcceptableOrUnknown(data['carbs']!, _carbsMeta),
      );
    } else if (isInserting) {
      context.missing(_carbsMeta);
    }
    if (data.containsKey('fat')) {
      context.handle(
        _fatMeta,
        fat.isAcceptableOrUnknown(data['fat']!, _fatMeta),
      );
    } else if (isInserting) {
      context.missing(_fatMeta);
    }
    if (data.containsKey('gramm')) {
      context.handle(
        _grammMeta,
        gramm.isAcceptableOrUnknown(data['gramm']!, _grammMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodItemData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodItemData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      calories:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}calories'],
          )!,
      protein:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}protein'],
          )!,
      carbs:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}carbs'],
          )!,
      fat:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}fat'],
          )!,
      gramm:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}gramm'],
          )!,
    );
  }

  @override
  $FoodItemTable createAlias(String alias) {
    return $FoodItemTable(attachedDatabase, alias);
  }
}

class FoodItemData extends DataClass implements Insertable<FoodItemData> {
  final int id;
  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final int gramm;
  const FoodItemData({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.gramm,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['calories'] = Variable<int>(calories);
    map['protein'] = Variable<int>(protein);
    map['carbs'] = Variable<int>(carbs);
    map['fat'] = Variable<int>(fat);
    map['gramm'] = Variable<int>(gramm);
    return map;
  }

  FoodItemCompanion toCompanion(bool nullToAbsent) {
    return FoodItemCompanion(
      id: Value(id),
      name: Value(name),
      calories: Value(calories),
      protein: Value(protein),
      carbs: Value(carbs),
      fat: Value(fat),
      gramm: Value(gramm),
    );
  }

  factory FoodItemData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodItemData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      calories: serializer.fromJson<int>(json['calories']),
      protein: serializer.fromJson<int>(json['protein']),
      carbs: serializer.fromJson<int>(json['carbs']),
      fat: serializer.fromJson<int>(json['fat']),
      gramm: serializer.fromJson<int>(json['gramm']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'calories': serializer.toJson<int>(calories),
      'protein': serializer.toJson<int>(protein),
      'carbs': serializer.toJson<int>(carbs),
      'fat': serializer.toJson<int>(fat),
      'gramm': serializer.toJson<int>(gramm),
    };
  }

  FoodItemData copyWith({
    int? id,
    String? name,
    int? calories,
    int? protein,
    int? carbs,
    int? fat,
    int? gramm,
  }) => FoodItemData(
    id: id ?? this.id,
    name: name ?? this.name,
    calories: calories ?? this.calories,
    protein: protein ?? this.protein,
    carbs: carbs ?? this.carbs,
    fat: fat ?? this.fat,
    gramm: gramm ?? this.gramm,
  );
  FoodItemData copyWithCompanion(FoodItemCompanion data) {
    return FoodItemData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      calories: data.calories.present ? data.calories.value : this.calories,
      protein: data.protein.present ? data.protein.value : this.protein,
      carbs: data.carbs.present ? data.carbs.value : this.carbs,
      fat: data.fat.present ? data.fat.value : this.fat,
      gramm: data.gramm.present ? data.gramm.value : this.gramm,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodItemData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('calories: $calories, ')
          ..write('protein: $protein, ')
          ..write('carbs: $carbs, ')
          ..write('fat: $fat, ')
          ..write('gramm: $gramm')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, calories, protein, carbs, fat, gramm);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodItemData &&
          other.id == this.id &&
          other.name == this.name &&
          other.calories == this.calories &&
          other.protein == this.protein &&
          other.carbs == this.carbs &&
          other.fat == this.fat &&
          other.gramm == this.gramm);
}

class FoodItemCompanion extends UpdateCompanion<FoodItemData> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> calories;
  final Value<int> protein;
  final Value<int> carbs;
  final Value<int> fat;
  final Value<int> gramm;
  const FoodItemCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.calories = const Value.absent(),
    this.protein = const Value.absent(),
    this.carbs = const Value.absent(),
    this.fat = const Value.absent(),
    this.gramm = const Value.absent(),
  });
  FoodItemCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int calories,
    required int protein,
    required int carbs,
    required int fat,
    this.gramm = const Value.absent(),
  }) : name = Value(name),
       calories = Value(calories),
       protein = Value(protein),
       carbs = Value(carbs),
       fat = Value(fat);
  static Insertable<FoodItemData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? calories,
    Expression<int>? protein,
    Expression<int>? carbs,
    Expression<int>? fat,
    Expression<int>? gramm,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (calories != null) 'calories': calories,
      if (protein != null) 'protein': protein,
      if (carbs != null) 'carbs': carbs,
      if (fat != null) 'fat': fat,
      if (gramm != null) 'gramm': gramm,
    });
  }

  FoodItemCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? calories,
    Value<int>? protein,
    Value<int>? carbs,
    Value<int>? fat,
    Value<int>? gramm,
  }) {
    return FoodItemCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      gramm: gramm ?? this.gramm,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (calories.present) {
      map['calories'] = Variable<int>(calories.value);
    }
    if (protein.present) {
      map['protein'] = Variable<int>(protein.value);
    }
    if (carbs.present) {
      map['carbs'] = Variable<int>(carbs.value);
    }
    if (fat.present) {
      map['fat'] = Variable<int>(fat.value);
    }
    if (gramm.present) {
      map['gramm'] = Variable<int>(gramm.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodItemCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('calories: $calories, ')
          ..write('protein: $protein, ')
          ..write('carbs: $carbs, ')
          ..write('fat: $fat, ')
          ..write('gramm: $gramm')
          ..write(')'))
        .toString();
  }
}

class $UserSettingsTable extends UserSettings
    with TableInfo<$UserSettingsTable, UserSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dailyCalorieGoalMeta = const VerificationMeta(
    'dailyCalorieGoal',
  );
  @override
  late final GeneratedColumn<int> dailyCalorieGoal = GeneratedColumn<int>(
    'daily_calorie_goal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2000),
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('light'),
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<int> heightCm = GeneratedColumn<int>(
    'height_cm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(170),
  );
  static const VerificationMeta _sexMeta = const VerificationMeta('sex');
  @override
  late final GeneratedColumn<String> sex = GeneratedColumn<String>(
    'sex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('male'),
  );
  static const VerificationMeta _activityLevelMeta = const VerificationMeta(
    'activityLevel',
  );
  @override
  late final GeneratedColumn<int> activityLevel = GeneratedColumn<int>(
    'activity_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _goalTypeMeta = const VerificationMeta(
    'goalType',
  );
  @override
  late final GeneratedColumn<int> goalType = GeneratedColumn<int>(
    'goal_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _startingWeightMeta = const VerificationMeta(
    'startingWeight',
  );
  @override
  late final GeneratedColumn<double> startingWeight = GeneratedColumn<double>(
    'starting_weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(80.0),
  );
  static const VerificationMeta _goalWeightMeta = const VerificationMeta(
    'goalWeight',
  );
  @override
  late final GeneratedColumn<double> goalWeight = GeneratedColumn<double>(
    'goal_weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(70.0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dailyCalorieGoal,
    themeMode,
    age,
    heightCm,
    sex,
    activityLevel,
    goalType,
    startingWeight,
    goalWeight,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('daily_calorie_goal')) {
      context.handle(
        _dailyCalorieGoalMeta,
        dailyCalorieGoal.isAcceptableOrUnknown(
          data['daily_calorie_goal']!,
          _dailyCalorieGoalMeta,
        ),
      );
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    }
    if (data.containsKey('sex')) {
      context.handle(
        _sexMeta,
        sex.isAcceptableOrUnknown(data['sex']!, _sexMeta),
      );
    }
    if (data.containsKey('activity_level')) {
      context.handle(
        _activityLevelMeta,
        activityLevel.isAcceptableOrUnknown(
          data['activity_level']!,
          _activityLevelMeta,
        ),
      );
    }
    if (data.containsKey('goal_type')) {
      context.handle(
        _goalTypeMeta,
        goalType.isAcceptableOrUnknown(data['goal_type']!, _goalTypeMeta),
      );
    }
    if (data.containsKey('starting_weight')) {
      context.handle(
        _startingWeightMeta,
        startingWeight.isAcceptableOrUnknown(
          data['starting_weight']!,
          _startingWeightMeta,
        ),
      );
    }
    if (data.containsKey('goal_weight')) {
      context.handle(
        _goalWeightMeta,
        goalWeight.isAcceptableOrUnknown(data['goal_weight']!, _goalWeightMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSetting(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      dailyCalorieGoal:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}daily_calorie_goal'],
          )!,
      themeMode:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}theme_mode'],
          )!,
      age:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}age'],
          )!,
      heightCm:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}height_cm'],
          )!,
      sex:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}sex'],
          )!,
      activityLevel:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}activity_level'],
          )!,
      goalType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}goal_type'],
          )!,
      startingWeight:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}starting_weight'],
          )!,
      goalWeight:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}goal_weight'],
          )!,
    );
  }

  @override
  $UserSettingsTable createAlias(String alias) {
    return $UserSettingsTable(attachedDatabase, alias);
  }
}

class UserSetting extends DataClass implements Insertable<UserSetting> {
  final int id;
  final int dailyCalorieGoal;
  final String themeMode;
  final int age;
  final int heightCm;
  final String sex;
  final int activityLevel;
  final int goalType;
  final double startingWeight;
  final double goalWeight;
  const UserSetting({
    required this.id,
    required this.dailyCalorieGoal,
    required this.themeMode,
    required this.age,
    required this.heightCm,
    required this.sex,
    required this.activityLevel,
    required this.goalType,
    required this.startingWeight,
    required this.goalWeight,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['daily_calorie_goal'] = Variable<int>(dailyCalorieGoal);
    map['theme_mode'] = Variable<String>(themeMode);
    map['age'] = Variable<int>(age);
    map['height_cm'] = Variable<int>(heightCm);
    map['sex'] = Variable<String>(sex);
    map['activity_level'] = Variable<int>(activityLevel);
    map['goal_type'] = Variable<int>(goalType);
    map['starting_weight'] = Variable<double>(startingWeight);
    map['goal_weight'] = Variable<double>(goalWeight);
    return map;
  }

  UserSettingsCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsCompanion(
      id: Value(id),
      dailyCalorieGoal: Value(dailyCalorieGoal),
      themeMode: Value(themeMode),
      age: Value(age),
      heightCm: Value(heightCm),
      sex: Value(sex),
      activityLevel: Value(activityLevel),
      goalType: Value(goalType),
      startingWeight: Value(startingWeight),
      goalWeight: Value(goalWeight),
    );
  }

  factory UserSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSetting(
      id: serializer.fromJson<int>(json['id']),
      dailyCalorieGoal: serializer.fromJson<int>(json['dailyCalorieGoal']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      age: serializer.fromJson<int>(json['age']),
      heightCm: serializer.fromJson<int>(json['heightCm']),
      sex: serializer.fromJson<String>(json['sex']),
      activityLevel: serializer.fromJson<int>(json['activityLevel']),
      goalType: serializer.fromJson<int>(json['goalType']),
      startingWeight: serializer.fromJson<double>(json['startingWeight']),
      goalWeight: serializer.fromJson<double>(json['goalWeight']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dailyCalorieGoal': serializer.toJson<int>(dailyCalorieGoal),
      'themeMode': serializer.toJson<String>(themeMode),
      'age': serializer.toJson<int>(age),
      'heightCm': serializer.toJson<int>(heightCm),
      'sex': serializer.toJson<String>(sex),
      'activityLevel': serializer.toJson<int>(activityLevel),
      'goalType': serializer.toJson<int>(goalType),
      'startingWeight': serializer.toJson<double>(startingWeight),
      'goalWeight': serializer.toJson<double>(goalWeight),
    };
  }

  UserSetting copyWith({
    int? id,
    int? dailyCalorieGoal,
    String? themeMode,
    int? age,
    int? heightCm,
    String? sex,
    int? activityLevel,
    int? goalType,
    double? startingWeight,
    double? goalWeight,
  }) => UserSetting(
    id: id ?? this.id,
    dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
    themeMode: themeMode ?? this.themeMode,
    age: age ?? this.age,
    heightCm: heightCm ?? this.heightCm,
    sex: sex ?? this.sex,
    activityLevel: activityLevel ?? this.activityLevel,
    goalType: goalType ?? this.goalType,
    startingWeight: startingWeight ?? this.startingWeight,
    goalWeight: goalWeight ?? this.goalWeight,
  );
  UserSetting copyWithCompanion(UserSettingsCompanion data) {
    return UserSetting(
      id: data.id.present ? data.id.value : this.id,
      dailyCalorieGoal:
          data.dailyCalorieGoal.present
              ? data.dailyCalorieGoal.value
              : this.dailyCalorieGoal,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      age: data.age.present ? data.age.value : this.age,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      sex: data.sex.present ? data.sex.value : this.sex,
      activityLevel:
          data.activityLevel.present
              ? data.activityLevel.value
              : this.activityLevel,
      goalType: data.goalType.present ? data.goalType.value : this.goalType,
      startingWeight:
          data.startingWeight.present
              ? data.startingWeight.value
              : this.startingWeight,
      goalWeight:
          data.goalWeight.present ? data.goalWeight.value : this.goalWeight,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSetting(')
          ..write('id: $id, ')
          ..write('dailyCalorieGoal: $dailyCalorieGoal, ')
          ..write('themeMode: $themeMode, ')
          ..write('age: $age, ')
          ..write('heightCm: $heightCm, ')
          ..write('sex: $sex, ')
          ..write('activityLevel: $activityLevel, ')
          ..write('goalType: $goalType, ')
          ..write('startingWeight: $startingWeight, ')
          ..write('goalWeight: $goalWeight')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    dailyCalorieGoal,
    themeMode,
    age,
    heightCm,
    sex,
    activityLevel,
    goalType,
    startingWeight,
    goalWeight,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSetting &&
          other.id == this.id &&
          other.dailyCalorieGoal == this.dailyCalorieGoal &&
          other.themeMode == this.themeMode &&
          other.age == this.age &&
          other.heightCm == this.heightCm &&
          other.sex == this.sex &&
          other.activityLevel == this.activityLevel &&
          other.goalType == this.goalType &&
          other.startingWeight == this.startingWeight &&
          other.goalWeight == this.goalWeight);
}

class UserSettingsCompanion extends UpdateCompanion<UserSetting> {
  final Value<int> id;
  final Value<int> dailyCalorieGoal;
  final Value<String> themeMode;
  final Value<int> age;
  final Value<int> heightCm;
  final Value<String> sex;
  final Value<int> activityLevel;
  final Value<int> goalType;
  final Value<double> startingWeight;
  final Value<double> goalWeight;
  const UserSettingsCompanion({
    this.id = const Value.absent(),
    this.dailyCalorieGoal = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.age = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.sex = const Value.absent(),
    this.activityLevel = const Value.absent(),
    this.goalType = const Value.absent(),
    this.startingWeight = const Value.absent(),
    this.goalWeight = const Value.absent(),
  });
  UserSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.dailyCalorieGoal = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.age = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.sex = const Value.absent(),
    this.activityLevel = const Value.absent(),
    this.goalType = const Value.absent(),
    this.startingWeight = const Value.absent(),
    this.goalWeight = const Value.absent(),
  });
  static Insertable<UserSetting> custom({
    Expression<int>? id,
    Expression<int>? dailyCalorieGoal,
    Expression<String>? themeMode,
    Expression<int>? age,
    Expression<int>? heightCm,
    Expression<String>? sex,
    Expression<int>? activityLevel,
    Expression<int>? goalType,
    Expression<double>? startingWeight,
    Expression<double>? goalWeight,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dailyCalorieGoal != null) 'daily_calorie_goal': dailyCalorieGoal,
      if (themeMode != null) 'theme_mode': themeMode,
      if (age != null) 'age': age,
      if (heightCm != null) 'height_cm': heightCm,
      if (sex != null) 'sex': sex,
      if (activityLevel != null) 'activity_level': activityLevel,
      if (goalType != null) 'goal_type': goalType,
      if (startingWeight != null) 'starting_weight': startingWeight,
      if (goalWeight != null) 'goal_weight': goalWeight,
    });
  }

  UserSettingsCompanion copyWith({
    Value<int>? id,
    Value<int>? dailyCalorieGoal,
    Value<String>? themeMode,
    Value<int>? age,
    Value<int>? heightCm,
    Value<String>? sex,
    Value<int>? activityLevel,
    Value<int>? goalType,
    Value<double>? startingWeight,
    Value<double>? goalWeight,
  }) {
    return UserSettingsCompanion(
      id: id ?? this.id,
      dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
      themeMode: themeMode ?? this.themeMode,
      age: age ?? this.age,
      heightCm: heightCm ?? this.heightCm,
      sex: sex ?? this.sex,
      activityLevel: activityLevel ?? this.activityLevel,
      goalType: goalType ?? this.goalType,
      startingWeight: startingWeight ?? this.startingWeight,
      goalWeight: goalWeight ?? this.goalWeight,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dailyCalorieGoal.present) {
      map['daily_calorie_goal'] = Variable<int>(dailyCalorieGoal.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<int>(heightCm.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(sex.value);
    }
    if (activityLevel.present) {
      map['activity_level'] = Variable<int>(activityLevel.value);
    }
    if (goalType.present) {
      map['goal_type'] = Variable<int>(goalType.value);
    }
    if (startingWeight.present) {
      map['starting_weight'] = Variable<double>(startingWeight.value);
    }
    if (goalWeight.present) {
      map['goal_weight'] = Variable<double>(goalWeight.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsCompanion(')
          ..write('id: $id, ')
          ..write('dailyCalorieGoal: $dailyCalorieGoal, ')
          ..write('themeMode: $themeMode, ')
          ..write('age: $age, ')
          ..write('heightCm: $heightCm, ')
          ..write('sex: $sex, ')
          ..write('activityLevel: $activityLevel, ')
          ..write('goalType: $goalType, ')
          ..write('startingWeight: $startingWeight, ')
          ..write('goalWeight: $goalWeight')
          ..write(')'))
        .toString();
  }
}

class $MealTableTable extends MealTable
    with TableInfo<$MealTableTable, MealTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _foodItemIdMeta = const VerificationMeta(
    'foodItemId',
  );
  @override
  late final GeneratedColumn<int> foodItemId = GeneratedColumn<int>(
    'food_item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, category, foodItemId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('food_item_id')) {
      context.handle(
        _foodItemIdMeta,
        foodItemId.isAcceptableOrUnknown(
          data['food_item_id']!,
          _foodItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_foodItemIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      date:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}date'],
          )!,
      category:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}category'],
          )!,
      foodItemId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}food_item_id'],
          )!,
    );
  }

  @override
  $MealTableTable createAlias(String alias) {
    return $MealTableTable(attachedDatabase, alias);
  }
}

class MealTableData extends DataClass implements Insertable<MealTableData> {
  final int id;
  final DateTime date;
  final String category;
  final int foodItemId;
  const MealTableData({
    required this.id,
    required this.date,
    required this.category,
    required this.foodItemId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['category'] = Variable<String>(category);
    map['food_item_id'] = Variable<int>(foodItemId);
    return map;
  }

  MealTableCompanion toCompanion(bool nullToAbsent) {
    return MealTableCompanion(
      id: Value(id),
      date: Value(date),
      category: Value(category),
      foodItemId: Value(foodItemId),
    );
  }

  factory MealTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealTableData(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      category: serializer.fromJson<String>(json['category']),
      foodItemId: serializer.fromJson<int>(json['foodItemId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'category': serializer.toJson<String>(category),
      'foodItemId': serializer.toJson<int>(foodItemId),
    };
  }

  MealTableData copyWith({
    int? id,
    DateTime? date,
    String? category,
    int? foodItemId,
  }) => MealTableData(
    id: id ?? this.id,
    date: date ?? this.date,
    category: category ?? this.category,
    foodItemId: foodItemId ?? this.foodItemId,
  );
  MealTableData copyWithCompanion(MealTableCompanion data) {
    return MealTableData(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      category: data.category.present ? data.category.value : this.category,
      foodItemId:
          data.foodItemId.present ? data.foodItemId.value : this.foodItemId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealTableData(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('foodItemId: $foodItemId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, category, foodItemId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealTableData &&
          other.id == this.id &&
          other.date == this.date &&
          other.category == this.category &&
          other.foodItemId == this.foodItemId);
}

class MealTableCompanion extends UpdateCompanion<MealTableData> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> category;
  final Value<int> foodItemId;
  const MealTableCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.category = const Value.absent(),
    this.foodItemId = const Value.absent(),
  });
  MealTableCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required String category,
    required int foodItemId,
  }) : date = Value(date),
       category = Value(category),
       foodItemId = Value(foodItemId);
  static Insertable<MealTableData> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? category,
    Expression<int>? foodItemId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (category != null) 'category': category,
      if (foodItemId != null) 'food_item_id': foodItemId,
    });
  }

  MealTableCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<String>? category,
    Value<int>? foodItemId,
  }) {
    return MealTableCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      category: category ?? this.category,
      foodItemId: foodItemId ?? this.foodItemId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (foodItemId.present) {
      map['food_item_id'] = Variable<int>(foodItemId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealTableCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('foodItemId: $foodItemId')
          ..write(')'))
        .toString();
  }
}

class $MealFoodTableTable extends MealFoodTable
    with TableInfo<$MealFoodTableTable, MealFoodTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealFoodTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _mealIdMeta = const VerificationMeta('mealId');
  @override
  late final GeneratedColumn<int> mealId = GeneratedColumn<int>(
    'meal_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES meal_table (id)',
    ),
  );
  static const VerificationMeta _foodEntryIdMeta = const VerificationMeta(
    'foodEntryId',
  );
  @override
  late final GeneratedColumn<int> foodEntryId = GeneratedColumn<int>(
    'food_entry_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES food_item (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, mealId, foodEntryId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_food_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealFoodTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('meal_id')) {
      context.handle(
        _mealIdMeta,
        mealId.isAcceptableOrUnknown(data['meal_id']!, _mealIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mealIdMeta);
    }
    if (data.containsKey('food_entry_id')) {
      context.handle(
        _foodEntryIdMeta,
        foodEntryId.isAcceptableOrUnknown(
          data['food_entry_id']!,
          _foodEntryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_foodEntryIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealFoodTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealFoodTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      mealId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}meal_id'],
          )!,
      foodEntryId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}food_entry_id'],
          )!,
    );
  }

  @override
  $MealFoodTableTable createAlias(String alias) {
    return $MealFoodTableTable(attachedDatabase, alias);
  }
}

class MealFoodTableData extends DataClass
    implements Insertable<MealFoodTableData> {
  final int id;
  final int mealId;
  final int foodEntryId;
  const MealFoodTableData({
    required this.id,
    required this.mealId,
    required this.foodEntryId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['meal_id'] = Variable<int>(mealId);
    map['food_entry_id'] = Variable<int>(foodEntryId);
    return map;
  }

  MealFoodTableCompanion toCompanion(bool nullToAbsent) {
    return MealFoodTableCompanion(
      id: Value(id),
      mealId: Value(mealId),
      foodEntryId: Value(foodEntryId),
    );
  }

  factory MealFoodTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealFoodTableData(
      id: serializer.fromJson<int>(json['id']),
      mealId: serializer.fromJson<int>(json['mealId']),
      foodEntryId: serializer.fromJson<int>(json['foodEntryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mealId': serializer.toJson<int>(mealId),
      'foodEntryId': serializer.toJson<int>(foodEntryId),
    };
  }

  MealFoodTableData copyWith({int? id, int? mealId, int? foodEntryId}) =>
      MealFoodTableData(
        id: id ?? this.id,
        mealId: mealId ?? this.mealId,
        foodEntryId: foodEntryId ?? this.foodEntryId,
      );
  MealFoodTableData copyWithCompanion(MealFoodTableCompanion data) {
    return MealFoodTableData(
      id: data.id.present ? data.id.value : this.id,
      mealId: data.mealId.present ? data.mealId.value : this.mealId,
      foodEntryId:
          data.foodEntryId.present ? data.foodEntryId.value : this.foodEntryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealFoodTableData(')
          ..write('id: $id, ')
          ..write('mealId: $mealId, ')
          ..write('foodEntryId: $foodEntryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, mealId, foodEntryId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealFoodTableData &&
          other.id == this.id &&
          other.mealId == this.mealId &&
          other.foodEntryId == this.foodEntryId);
}

class MealFoodTableCompanion extends UpdateCompanion<MealFoodTableData> {
  final Value<int> id;
  final Value<int> mealId;
  final Value<int> foodEntryId;
  const MealFoodTableCompanion({
    this.id = const Value.absent(),
    this.mealId = const Value.absent(),
    this.foodEntryId = const Value.absent(),
  });
  MealFoodTableCompanion.insert({
    this.id = const Value.absent(),
    required int mealId,
    required int foodEntryId,
  }) : mealId = Value(mealId),
       foodEntryId = Value(foodEntryId);
  static Insertable<MealFoodTableData> custom({
    Expression<int>? id,
    Expression<int>? mealId,
    Expression<int>? foodEntryId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (mealId != null) 'meal_id': mealId,
      if (foodEntryId != null) 'food_entry_id': foodEntryId,
    });
  }

  MealFoodTableCompanion copyWith({
    Value<int>? id,
    Value<int>? mealId,
    Value<int>? foodEntryId,
  }) {
    return MealFoodTableCompanion(
      id: id ?? this.id,
      mealId: mealId ?? this.mealId,
      foodEntryId: foodEntryId ?? this.foodEntryId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (mealId.present) {
      map['meal_id'] = Variable<int>(mealId.value);
    }
    if (foodEntryId.present) {
      map['food_entry_id'] = Variable<int>(foodEntryId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealFoodTableCompanion(')
          ..write('id: $id, ')
          ..write('mealId: $mealId, ')
          ..write('foodEntryId: $foodEntryId')
          ..write(')'))
        .toString();
  }
}

class $SearchCacheTableTable extends SearchCacheTable
    with TableInfo<$SearchCacheTableTable, SearchCacheTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SearchCacheTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _queryMeta = const VerificationMeta('query');
  @override
  late final GeneratedColumn<String> query = GeneratedColumn<String>(
    'query',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tsMeta = const VerificationMeta('ts');
  @override
  late final GeneratedColumn<int> ts = GeneratedColumn<int>(
    'ts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [query, json, ts];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'search_cache_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SearchCacheTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('query')) {
      context.handle(
        _queryMeta,
        query.isAcceptableOrUnknown(data['query']!, _queryMeta),
      );
    } else if (isInserting) {
      context.missing(_queryMeta);
    }
    if (data.containsKey('json')) {
      context.handle(
        _jsonMeta,
        json.isAcceptableOrUnknown(data['json']!, _jsonMeta),
      );
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    if (data.containsKey('ts')) {
      context.handle(_tsMeta, ts.isAcceptableOrUnknown(data['ts']!, _tsMeta));
    } else if (isInserting) {
      context.missing(_tsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {query};
  @override
  SearchCacheTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SearchCacheTableData(
      query:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}query'],
          )!,
      json:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}json'],
          )!,
      ts:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}ts'],
          )!,
    );
  }

  @override
  $SearchCacheTableTable createAlias(String alias) {
    return $SearchCacheTableTable(attachedDatabase, alias);
  }
}

class SearchCacheTableData extends DataClass
    implements Insertable<SearchCacheTableData> {
  final String query;
  final String json;
  final int ts;
  const SearchCacheTableData({
    required this.query,
    required this.json,
    required this.ts,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['query'] = Variable<String>(query);
    map['json'] = Variable<String>(json);
    map['ts'] = Variable<int>(ts);
    return map;
  }

  SearchCacheTableCompanion toCompanion(bool nullToAbsent) {
    return SearchCacheTableCompanion(
      query: Value(query),
      json: Value(json),
      ts: Value(ts),
    );
  }

  factory SearchCacheTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SearchCacheTableData(
      query: serializer.fromJson<String>(json['query']),
      json: serializer.fromJson<String>(json['json']),
      ts: serializer.fromJson<int>(json['ts']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'query': serializer.toJson<String>(query),
      'json': serializer.toJson<String>(json),
      'ts': serializer.toJson<int>(ts),
    };
  }

  SearchCacheTableData copyWith({String? query, String? json, int? ts}) =>
      SearchCacheTableData(
        query: query ?? this.query,
        json: json ?? this.json,
        ts: ts ?? this.ts,
      );
  SearchCacheTableData copyWithCompanion(SearchCacheTableCompanion data) {
    return SearchCacheTableData(
      query: data.query.present ? data.query.value : this.query,
      json: data.json.present ? data.json.value : this.json,
      ts: data.ts.present ? data.ts.value : this.ts,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SearchCacheTableData(')
          ..write('query: $query, ')
          ..write('json: $json, ')
          ..write('ts: $ts')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(query, json, ts);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SearchCacheTableData &&
          other.query == this.query &&
          other.json == this.json &&
          other.ts == this.ts);
}

class SearchCacheTableCompanion extends UpdateCompanion<SearchCacheTableData> {
  final Value<String> query;
  final Value<String> json;
  final Value<int> ts;
  final Value<int> rowid;
  const SearchCacheTableCompanion({
    this.query = const Value.absent(),
    this.json = const Value.absent(),
    this.ts = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SearchCacheTableCompanion.insert({
    required String query,
    required String json,
    required int ts,
    this.rowid = const Value.absent(),
  }) : query = Value(query),
       json = Value(json),
       ts = Value(ts);
  static Insertable<SearchCacheTableData> custom({
    Expression<String>? query,
    Expression<String>? json,
    Expression<int>? ts,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (query != null) 'query': query,
      if (json != null) 'json': json,
      if (ts != null) 'ts': ts,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SearchCacheTableCompanion copyWith({
    Value<String>? query,
    Value<String>? json,
    Value<int>? ts,
    Value<int>? rowid,
  }) {
    return SearchCacheTableCompanion(
      query: query ?? this.query,
      json: json ?? this.json,
      ts: ts ?? this.ts,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (query.present) {
      map['query'] = Variable<String>(query.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (ts.present) {
      map['ts'] = Variable<int>(ts.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SearchCacheTableCompanion(')
          ..write('query: $query, ')
          ..write('json: $json, ')
          ..write('ts: $ts, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WeightRecordTable extends WeightRecord
    with TableInfo<$WeightRecordTable, WeightRecordData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeightRecordTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, weight, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weight_record';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeightRecordData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeightRecordData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeightRecordData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      date:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}date'],
          )!,
      weight:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}weight'],
          )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $WeightRecordTable createAlias(String alias) {
    return $WeightRecordTable(attachedDatabase, alias);
  }
}

class WeightRecordData extends DataClass
    implements Insertable<WeightRecordData> {
  final int id;
  final DateTime date;
  final double weight;
  final String? note;
  const WeightRecordData({
    required this.id,
    required this.date,
    required this.weight,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['weight'] = Variable<double>(weight);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  WeightRecordCompanion toCompanion(bool nullToAbsent) {
    return WeightRecordCompanion(
      id: Value(id),
      date: Value(date),
      weight: Value(weight),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory WeightRecordData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeightRecordData(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      weight: serializer.fromJson<double>(json['weight']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'weight': serializer.toJson<double>(weight),
      'note': serializer.toJson<String?>(note),
    };
  }

  WeightRecordData copyWith({
    int? id,
    DateTime? date,
    double? weight,
    Value<String?> note = const Value.absent(),
  }) => WeightRecordData(
    id: id ?? this.id,
    date: date ?? this.date,
    weight: weight ?? this.weight,
    note: note.present ? note.value : this.note,
  );
  WeightRecordData copyWithCompanion(WeightRecordCompanion data) {
    return WeightRecordData(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      weight: data.weight.present ? data.weight.value : this.weight,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeightRecordData(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('weight: $weight, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, weight, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeightRecordData &&
          other.id == this.id &&
          other.date == this.date &&
          other.weight == this.weight &&
          other.note == this.note);
}

class WeightRecordCompanion extends UpdateCompanion<WeightRecordData> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<double> weight;
  final Value<String?> note;
  const WeightRecordCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.weight = const Value.absent(),
    this.note = const Value.absent(),
  });
  WeightRecordCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required double weight,
    this.note = const Value.absent(),
  }) : date = Value(date),
       weight = Value(weight);
  static Insertable<WeightRecordData> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<double>? weight,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (weight != null) 'weight': weight,
      if (note != null) 'note': note,
    });
  }

  WeightRecordCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<double>? weight,
    Value<String?>? note,
  }) {
    return WeightRecordCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      weight: weight ?? this.weight,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeightRecordCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('weight: $weight, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $ExerciseTableTable extends ExerciseTable
    with TableInfo<$ExerciseTableTable, ExerciseTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExerciseTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetMuscleGroupsMeta =
      const VerificationMeta('targetMuscleGroups');
  @override
  late final GeneratedColumn<String> targetMuscleGroups =
      GeneratedColumn<String>(
        'target_muscle_groups',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCustomMeta = const VerificationMeta(
    'isCustom',
  );
  @override
  late final GeneratedColumn<bool> isCustom = GeneratedColumn<bool>(
    'is_custom',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_custom" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    type,
    targetMuscleGroups,
    imageUrl,
    isCustom,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exercise_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExerciseTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('target_muscle_groups')) {
      context.handle(
        _targetMuscleGroupsMeta,
        targetMuscleGroups.isAcceptableOrUnknown(
          data['target_muscle_groups']!,
          _targetMuscleGroupsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetMuscleGroupsMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('is_custom')) {
      context.handle(
        _isCustomMeta,
        isCustom.isAcceptableOrUnknown(data['is_custom']!, _isCustomMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExerciseTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExerciseTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      type:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}type'],
          )!,
      targetMuscleGroups:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}target_muscle_groups'],
          )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      isCustom:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_custom'],
          )!,
    );
  }

  @override
  $ExerciseTableTable createAlias(String alias) {
    return $ExerciseTableTable(attachedDatabase, alias);
  }
}

class ExerciseTableData extends DataClass
    implements Insertable<ExerciseTableData> {
  final int id;
  final String name;
  final String? description;
  final int type;
  final String targetMuscleGroups;
  final String? imageUrl;
  final bool isCustom;
  const ExerciseTableData({
    required this.id,
    required this.name,
    this.description,
    required this.type,
    required this.targetMuscleGroups,
    this.imageUrl,
    required this.isCustom,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['type'] = Variable<int>(type);
    map['target_muscle_groups'] = Variable<String>(targetMuscleGroups);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['is_custom'] = Variable<bool>(isCustom);
    return map;
  }

  ExerciseTableCompanion toCompanion(bool nullToAbsent) {
    return ExerciseTableCompanion(
      id: Value(id),
      name: Value(name),
      description:
          description == null && nullToAbsent
              ? const Value.absent()
              : Value(description),
      type: Value(type),
      targetMuscleGroups: Value(targetMuscleGroups),
      imageUrl:
          imageUrl == null && nullToAbsent
              ? const Value.absent()
              : Value(imageUrl),
      isCustom: Value(isCustom),
    );
  }

  factory ExerciseTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExerciseTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      type: serializer.fromJson<int>(json['type']),
      targetMuscleGroups: serializer.fromJson<String>(
        json['targetMuscleGroups'],
      ),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      isCustom: serializer.fromJson<bool>(json['isCustom']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'type': serializer.toJson<int>(type),
      'targetMuscleGroups': serializer.toJson<String>(targetMuscleGroups),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'isCustom': serializer.toJson<bool>(isCustom),
    };
  }

  ExerciseTableData copyWith({
    int? id,
    String? name,
    Value<String?> description = const Value.absent(),
    int? type,
    String? targetMuscleGroups,
    Value<String?> imageUrl = const Value.absent(),
    bool? isCustom,
  }) => ExerciseTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    type: type ?? this.type,
    targetMuscleGroups: targetMuscleGroups ?? this.targetMuscleGroups,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    isCustom: isCustom ?? this.isCustom,
  );
  ExerciseTableData copyWithCompanion(ExerciseTableCompanion data) {
    return ExerciseTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      type: data.type.present ? data.type.value : this.type,
      targetMuscleGroups:
          data.targetMuscleGroups.present
              ? data.targetMuscleGroups.value
              : this.targetMuscleGroups,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      isCustom: data.isCustom.present ? data.isCustom.value : this.isCustom,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('targetMuscleGroups: $targetMuscleGroups, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    type,
    targetMuscleGroups,
    imageUrl,
    isCustom,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExerciseTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.type == this.type &&
          other.targetMuscleGroups == this.targetMuscleGroups &&
          other.imageUrl == this.imageUrl &&
          other.isCustom == this.isCustom);
}

class ExerciseTableCompanion extends UpdateCompanion<ExerciseTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> type;
  final Value<String> targetMuscleGroups;
  final Value<String?> imageUrl;
  final Value<bool> isCustom;
  const ExerciseTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.type = const Value.absent(),
    this.targetMuscleGroups = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.isCustom = const Value.absent(),
  });
  ExerciseTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    required int type,
    required String targetMuscleGroups,
    this.imageUrl = const Value.absent(),
    this.isCustom = const Value.absent(),
  }) : name = Value(name),
       type = Value(type),
       targetMuscleGroups = Value(targetMuscleGroups);
  static Insertable<ExerciseTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? type,
    Expression<String>? targetMuscleGroups,
    Expression<String>? imageUrl,
    Expression<bool>? isCustom,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (targetMuscleGroups != null)
        'target_muscle_groups': targetMuscleGroups,
      if (imageUrl != null) 'image_url': imageUrl,
      if (isCustom != null) 'is_custom': isCustom,
    });
  }

  ExerciseTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<int>? type,
    Value<String>? targetMuscleGroups,
    Value<String?>? imageUrl,
    Value<bool>? isCustom,
  }) {
    return ExerciseTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      targetMuscleGroups: targetMuscleGroups ?? this.targetMuscleGroups,
      imageUrl: imageUrl ?? this.imageUrl,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (targetMuscleGroups.present) {
      map['target_muscle_groups'] = Variable<String>(targetMuscleGroups.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (isCustom.present) {
      map['is_custom'] = Variable<bool>(isCustom.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExerciseTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('type: $type, ')
          ..write('targetMuscleGroups: $targetMuscleGroups, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('isCustom: $isCustom')
          ..write(')'))
        .toString();
  }
}

class $WorkoutTableTable extends WorkoutTable
    with TableInfo<$WorkoutTableTable, WorkoutTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<int> difficulty = GeneratedColumn<int>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estimatedDurationMinutesMeta =
      const VerificationMeta('estimatedDurationMinutes');
  @override
  late final GeneratedColumn<int> estimatedDurationMinutes =
      GeneratedColumn<int>(
        'estimated_duration_minutes',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(30),
      );
  static const VerificationMeta _isTemplateMeta = const VerificationMeta(
    'isTemplate',
  );
  @override
  late final GeneratedColumn<bool> isTemplate = GeneratedColumn<bool>(
    'is_template',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_template" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _scheduledDateMeta = const VerificationMeta(
    'scheduledDate',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledDate =
      GeneratedColumn<DateTime>(
        'scheduled_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _completedDateMeta = const VerificationMeta(
    'completedDate',
  );
  @override
  late final GeneratedColumn<DateTime> completedDate =
      GeneratedColumn<DateTime>(
        'completed_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    difficulty,
    estimatedDurationMinutes,
    isTemplate,
    scheduledDate,
    completedDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('estimated_duration_minutes')) {
      context.handle(
        _estimatedDurationMinutesMeta,
        estimatedDurationMinutes.isAcceptableOrUnknown(
          data['estimated_duration_minutes']!,
          _estimatedDurationMinutesMeta,
        ),
      );
    }
    if (data.containsKey('is_template')) {
      context.handle(
        _isTemplateMeta,
        isTemplate.isAcceptableOrUnknown(data['is_template']!, _isTemplateMeta),
      );
    }
    if (data.containsKey('scheduled_date')) {
      context.handle(
        _scheduledDateMeta,
        scheduledDate.isAcceptableOrUnknown(
          data['scheduled_date']!,
          _scheduledDateMeta,
        ),
      );
    }
    if (data.containsKey('completed_date')) {
      context.handle(
        _completedDateMeta,
        completedDate.isAcceptableOrUnknown(
          data['completed_date']!,
          _completedDateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      difficulty:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}difficulty'],
          )!,
      estimatedDurationMinutes:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}estimated_duration_minutes'],
          )!,
      isTemplate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_template'],
          )!,
      scheduledDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_date'],
      ),
      completedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_date'],
      ),
    );
  }

  @override
  $WorkoutTableTable createAlias(String alias) {
    return $WorkoutTableTable(attachedDatabase, alias);
  }
}

class WorkoutTableData extends DataClass
    implements Insertable<WorkoutTableData> {
  final int id;
  final String name;
  final String? description;
  final int difficulty;
  final int estimatedDurationMinutes;
  final bool isTemplate;
  final DateTime? scheduledDate;
  final DateTime? completedDate;
  const WorkoutTableData({
    required this.id,
    required this.name,
    this.description,
    required this.difficulty,
    required this.estimatedDurationMinutes,
    required this.isTemplate,
    this.scheduledDate,
    this.completedDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['difficulty'] = Variable<int>(difficulty);
    map['estimated_duration_minutes'] = Variable<int>(estimatedDurationMinutes);
    map['is_template'] = Variable<bool>(isTemplate);
    if (!nullToAbsent || scheduledDate != null) {
      map['scheduled_date'] = Variable<DateTime>(scheduledDate);
    }
    if (!nullToAbsent || completedDate != null) {
      map['completed_date'] = Variable<DateTime>(completedDate);
    }
    return map;
  }

  WorkoutTableCompanion toCompanion(bool nullToAbsent) {
    return WorkoutTableCompanion(
      id: Value(id),
      name: Value(name),
      description:
          description == null && nullToAbsent
              ? const Value.absent()
              : Value(description),
      difficulty: Value(difficulty),
      estimatedDurationMinutes: Value(estimatedDurationMinutes),
      isTemplate: Value(isTemplate),
      scheduledDate:
          scheduledDate == null && nullToAbsent
              ? const Value.absent()
              : Value(scheduledDate),
      completedDate:
          completedDate == null && nullToAbsent
              ? const Value.absent()
              : Value(completedDate),
    );
  }

  factory WorkoutTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      difficulty: serializer.fromJson<int>(json['difficulty']),
      estimatedDurationMinutes: serializer.fromJson<int>(
        json['estimatedDurationMinutes'],
      ),
      isTemplate: serializer.fromJson<bool>(json['isTemplate']),
      scheduledDate: serializer.fromJson<DateTime?>(json['scheduledDate']),
      completedDate: serializer.fromJson<DateTime?>(json['completedDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'difficulty': serializer.toJson<int>(difficulty),
      'estimatedDurationMinutes': serializer.toJson<int>(
        estimatedDurationMinutes,
      ),
      'isTemplate': serializer.toJson<bool>(isTemplate),
      'scheduledDate': serializer.toJson<DateTime?>(scheduledDate),
      'completedDate': serializer.toJson<DateTime?>(completedDate),
    };
  }

  WorkoutTableData copyWith({
    int? id,
    String? name,
    Value<String?> description = const Value.absent(),
    int? difficulty,
    int? estimatedDurationMinutes,
    bool? isTemplate,
    Value<DateTime?> scheduledDate = const Value.absent(),
    Value<DateTime?> completedDate = const Value.absent(),
  }) => WorkoutTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    difficulty: difficulty ?? this.difficulty,
    estimatedDurationMinutes:
        estimatedDurationMinutes ?? this.estimatedDurationMinutes,
    isTemplate: isTemplate ?? this.isTemplate,
    scheduledDate:
        scheduledDate.present ? scheduledDate.value : this.scheduledDate,
    completedDate:
        completedDate.present ? completedDate.value : this.completedDate,
  );
  WorkoutTableData copyWithCompanion(WorkoutTableCompanion data) {
    return WorkoutTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      difficulty:
          data.difficulty.present ? data.difficulty.value : this.difficulty,
      estimatedDurationMinutes:
          data.estimatedDurationMinutes.present
              ? data.estimatedDurationMinutes.value
              : this.estimatedDurationMinutes,
      isTemplate:
          data.isTemplate.present ? data.isTemplate.value : this.isTemplate,
      scheduledDate:
          data.scheduledDate.present
              ? data.scheduledDate.value
              : this.scheduledDate,
      completedDate:
          data.completedDate.present
              ? data.completedDate.value
              : this.completedDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('difficulty: $difficulty, ')
          ..write('estimatedDurationMinutes: $estimatedDurationMinutes, ')
          ..write('isTemplate: $isTemplate, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('completedDate: $completedDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    difficulty,
    estimatedDurationMinutes,
    isTemplate,
    scheduledDate,
    completedDate,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.difficulty == this.difficulty &&
          other.estimatedDurationMinutes == this.estimatedDurationMinutes &&
          other.isTemplate == this.isTemplate &&
          other.scheduledDate == this.scheduledDate &&
          other.completedDate == this.completedDate);
}

class WorkoutTableCompanion extends UpdateCompanion<WorkoutTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> difficulty;
  final Value<int> estimatedDurationMinutes;
  final Value<bool> isTemplate;
  final Value<DateTime?> scheduledDate;
  final Value<DateTime?> completedDate;
  const WorkoutTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.estimatedDurationMinutes = const Value.absent(),
    this.isTemplate = const Value.absent(),
    this.scheduledDate = const Value.absent(),
    this.completedDate = const Value.absent(),
  });
  WorkoutTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    required int difficulty,
    this.estimatedDurationMinutes = const Value.absent(),
    this.isTemplate = const Value.absent(),
    this.scheduledDate = const Value.absent(),
    this.completedDate = const Value.absent(),
  }) : name = Value(name),
       difficulty = Value(difficulty);
  static Insertable<WorkoutTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? difficulty,
    Expression<int>? estimatedDurationMinutes,
    Expression<bool>? isTemplate,
    Expression<DateTime>? scheduledDate,
    Expression<DateTime>? completedDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (difficulty != null) 'difficulty': difficulty,
      if (estimatedDurationMinutes != null)
        'estimated_duration_minutes': estimatedDurationMinutes,
      if (isTemplate != null) 'is_template': isTemplate,
      if (scheduledDate != null) 'scheduled_date': scheduledDate,
      if (completedDate != null) 'completed_date': completedDate,
    });
  }

  WorkoutTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<int>? difficulty,
    Value<int>? estimatedDurationMinutes,
    Value<bool>? isTemplate,
    Value<DateTime?>? scheduledDate,
    Value<DateTime?>? completedDate,
  }) {
    return WorkoutTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      difficulty: difficulty ?? this.difficulty,
      estimatedDurationMinutes:
          estimatedDurationMinutes ?? this.estimatedDurationMinutes,
      isTemplate: isTemplate ?? this.isTemplate,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      completedDate: completedDate ?? this.completedDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<int>(difficulty.value);
    }
    if (estimatedDurationMinutes.present) {
      map['estimated_duration_minutes'] = Variable<int>(
        estimatedDurationMinutes.value,
      );
    }
    if (isTemplate.present) {
      map['is_template'] = Variable<bool>(isTemplate.value);
    }
    if (scheduledDate.present) {
      map['scheduled_date'] = Variable<DateTime>(scheduledDate.value);
    }
    if (completedDate.present) {
      map['completed_date'] = Variable<DateTime>(completedDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('difficulty: $difficulty, ')
          ..write('estimatedDurationMinutes: $estimatedDurationMinutes, ')
          ..write('isTemplate: $isTemplate, ')
          ..write('scheduledDate: $scheduledDate, ')
          ..write('completedDate: $completedDate')
          ..write(')'))
        .toString();
  }
}

class $WorkoutExerciseTableTable extends WorkoutExerciseTable
    with TableInfo<$WorkoutExerciseTableTable, WorkoutExerciseTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutExerciseTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _workoutIdMeta = const VerificationMeta(
    'workoutId',
  );
  @override
  late final GeneratedColumn<int> workoutId = GeneratedColumn<int>(
    'workout_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_table (id)',
    ),
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<int> exerciseId = GeneratedColumn<int>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES exercise_table (id)',
    ),
  );
  static const VerificationMeta _orderPositionMeta = const VerificationMeta(
    'orderPosition',
  );
  @override
  late final GeneratedColumn<int> orderPosition = GeneratedColumn<int>(
    'order_position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workoutId,
    exerciseId,
    orderPosition,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_exercise_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutExerciseTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('workout_id')) {
      context.handle(
        _workoutIdMeta,
        workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workoutIdMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('order_position')) {
      context.handle(
        _orderPositionMeta,
        orderPosition.isAcceptableOrUnknown(
          data['order_position']!,
          _orderPositionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_orderPositionMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutExerciseTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutExerciseTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      workoutId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}workout_id'],
          )!,
      exerciseId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}exercise_id'],
          )!,
      orderPosition:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}order_position'],
          )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $WorkoutExerciseTableTable createAlias(String alias) {
    return $WorkoutExerciseTableTable(attachedDatabase, alias);
  }
}

class WorkoutExerciseTableData extends DataClass
    implements Insertable<WorkoutExerciseTableData> {
  final int id;
  final int workoutId;
  final int exerciseId;
  final int orderPosition;
  final String? notes;
  const WorkoutExerciseTableData({
    required this.id,
    required this.workoutId,
    required this.exerciseId,
    required this.orderPosition,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['workout_id'] = Variable<int>(workoutId);
    map['exercise_id'] = Variable<int>(exerciseId);
    map['order_position'] = Variable<int>(orderPosition);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  WorkoutExerciseTableCompanion toCompanion(bool nullToAbsent) {
    return WorkoutExerciseTableCompanion(
      id: Value(id),
      workoutId: Value(workoutId),
      exerciseId: Value(exerciseId),
      orderPosition: Value(orderPosition),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory WorkoutExerciseTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutExerciseTableData(
      id: serializer.fromJson<int>(json['id']),
      workoutId: serializer.fromJson<int>(json['workoutId']),
      exerciseId: serializer.fromJson<int>(json['exerciseId']),
      orderPosition: serializer.fromJson<int>(json['orderPosition']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'workoutId': serializer.toJson<int>(workoutId),
      'exerciseId': serializer.toJson<int>(exerciseId),
      'orderPosition': serializer.toJson<int>(orderPosition),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  WorkoutExerciseTableData copyWith({
    int? id,
    int? workoutId,
    int? exerciseId,
    int? orderPosition,
    Value<String?> notes = const Value.absent(),
  }) => WorkoutExerciseTableData(
    id: id ?? this.id,
    workoutId: workoutId ?? this.workoutId,
    exerciseId: exerciseId ?? this.exerciseId,
    orderPosition: orderPosition ?? this.orderPosition,
    notes: notes.present ? notes.value : this.notes,
  );
  WorkoutExerciseTableData copyWithCompanion(
    WorkoutExerciseTableCompanion data,
  ) {
    return WorkoutExerciseTableData(
      id: data.id.present ? data.id.value : this.id,
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
      exerciseId:
          data.exerciseId.present ? data.exerciseId.value : this.exerciseId,
      orderPosition:
          data.orderPosition.present
              ? data.orderPosition.value
              : this.orderPosition,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutExerciseTableData(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('orderPosition: $orderPosition, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, workoutId, exerciseId, orderPosition, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutExerciseTableData &&
          other.id == this.id &&
          other.workoutId == this.workoutId &&
          other.exerciseId == this.exerciseId &&
          other.orderPosition == this.orderPosition &&
          other.notes == this.notes);
}

class WorkoutExerciseTableCompanion
    extends UpdateCompanion<WorkoutExerciseTableData> {
  final Value<int> id;
  final Value<int> workoutId;
  final Value<int> exerciseId;
  final Value<int> orderPosition;
  final Value<String?> notes;
  const WorkoutExerciseTableCompanion({
    this.id = const Value.absent(),
    this.workoutId = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.orderPosition = const Value.absent(),
    this.notes = const Value.absent(),
  });
  WorkoutExerciseTableCompanion.insert({
    this.id = const Value.absent(),
    required int workoutId,
    required int exerciseId,
    required int orderPosition,
    this.notes = const Value.absent(),
  }) : workoutId = Value(workoutId),
       exerciseId = Value(exerciseId),
       orderPosition = Value(orderPosition);
  static Insertable<WorkoutExerciseTableData> custom({
    Expression<int>? id,
    Expression<int>? workoutId,
    Expression<int>? exerciseId,
    Expression<int>? orderPosition,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workoutId != null) 'workout_id': workoutId,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (orderPosition != null) 'order_position': orderPosition,
      if (notes != null) 'notes': notes,
    });
  }

  WorkoutExerciseTableCompanion copyWith({
    Value<int>? id,
    Value<int>? workoutId,
    Value<int>? exerciseId,
    Value<int>? orderPosition,
    Value<String?>? notes,
  }) {
    return WorkoutExerciseTableCompanion(
      id: id ?? this.id,
      workoutId: workoutId ?? this.workoutId,
      exerciseId: exerciseId ?? this.exerciseId,
      orderPosition: orderPosition ?? this.orderPosition,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (workoutId.present) {
      map['workout_id'] = Variable<int>(workoutId.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<int>(exerciseId.value);
    }
    if (orderPosition.present) {
      map['order_position'] = Variable<int>(orderPosition.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutExerciseTableCompanion(')
          ..write('id: $id, ')
          ..write('workoutId: $workoutId, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('orderPosition: $orderPosition, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSetTableTable extends WorkoutSetTable
    with TableInfo<$WorkoutSetTableTable, WorkoutSetTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSetTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _exerciseInstanceIdMeta =
      const VerificationMeta('exerciseInstanceId');
  @override
  late final GeneratedColumn<int> exerciseInstanceId = GeneratedColumn<int>(
    'exercise_instance_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_exercise_table (id)',
    ),
  );
  static const VerificationMeta _setNumberMeta = const VerificationMeta(
    'setNumber',
  );
  @override
  late final GeneratedColumn<int> setNumber = GeneratedColumn<int>(
    'set_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightUnitMeta = const VerificationMeta(
    'weightUnit',
  );
  @override
  late final GeneratedColumn<String> weightUnit = GeneratedColumn<String>(
    'weight_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    exerciseInstanceId,
    setNumber,
    reps,
    weight,
    weightUnit,
    durationSeconds,
    isCompleted,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_set_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSetTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('exercise_instance_id')) {
      context.handle(
        _exerciseInstanceIdMeta,
        exerciseInstanceId.isAcceptableOrUnknown(
          data['exercise_instance_id']!,
          _exerciseInstanceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseInstanceIdMeta);
    }
    if (data.containsKey('set_number')) {
      context.handle(
        _setNumberMeta,
        setNumber.isAcceptableOrUnknown(data['set_number']!, _setNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_setNumberMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    }
    if (data.containsKey('weight_unit')) {
      context.handle(
        _weightUnitMeta,
        weightUnit.isAcceptableOrUnknown(data['weight_unit']!, _weightUnitMeta),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSetTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSetTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      exerciseInstanceId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}exercise_instance_id'],
          )!,
      setNumber:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}set_number'],
          )!,
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      ),
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      ),
      weightUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weight_unit'],
      ),
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      ),
      isCompleted:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_completed'],
          )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $WorkoutSetTableTable createAlias(String alias) {
    return $WorkoutSetTableTable(attachedDatabase, alias);
  }
}

class WorkoutSetTableData extends DataClass
    implements Insertable<WorkoutSetTableData> {
  final int id;
  final int exerciseInstanceId;
  final int setNumber;
  final int? reps;
  final double? weight;
  final String? weightUnit;
  final int? durationSeconds;
  final bool isCompleted;
  final String? notes;
  const WorkoutSetTableData({
    required this.id,
    required this.exerciseInstanceId,
    required this.setNumber,
    this.reps,
    this.weight,
    this.weightUnit,
    this.durationSeconds,
    required this.isCompleted,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['exercise_instance_id'] = Variable<int>(exerciseInstanceId);
    map['set_number'] = Variable<int>(setNumber);
    if (!nullToAbsent || reps != null) {
      map['reps'] = Variable<int>(reps);
    }
    if (!nullToAbsent || weight != null) {
      map['weight'] = Variable<double>(weight);
    }
    if (!nullToAbsent || weightUnit != null) {
      map['weight_unit'] = Variable<String>(weightUnit);
    }
    if (!nullToAbsent || durationSeconds != null) {
      map['duration_seconds'] = Variable<int>(durationSeconds);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  WorkoutSetTableCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSetTableCompanion(
      id: Value(id),
      exerciseInstanceId: Value(exerciseInstanceId),
      setNumber: Value(setNumber),
      reps: reps == null && nullToAbsent ? const Value.absent() : Value(reps),
      weight:
          weight == null && nullToAbsent ? const Value.absent() : Value(weight),
      weightUnit:
          weightUnit == null && nullToAbsent
              ? const Value.absent()
              : Value(weightUnit),
      durationSeconds:
          durationSeconds == null && nullToAbsent
              ? const Value.absent()
              : Value(durationSeconds),
      isCompleted: Value(isCompleted),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory WorkoutSetTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSetTableData(
      id: serializer.fromJson<int>(json['id']),
      exerciseInstanceId: serializer.fromJson<int>(json['exerciseInstanceId']),
      setNumber: serializer.fromJson<int>(json['setNumber']),
      reps: serializer.fromJson<int?>(json['reps']),
      weight: serializer.fromJson<double?>(json['weight']),
      weightUnit: serializer.fromJson<String?>(json['weightUnit']),
      durationSeconds: serializer.fromJson<int?>(json['durationSeconds']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'exerciseInstanceId': serializer.toJson<int>(exerciseInstanceId),
      'setNumber': serializer.toJson<int>(setNumber),
      'reps': serializer.toJson<int?>(reps),
      'weight': serializer.toJson<double?>(weight),
      'weightUnit': serializer.toJson<String?>(weightUnit),
      'durationSeconds': serializer.toJson<int?>(durationSeconds),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  WorkoutSetTableData copyWith({
    int? id,
    int? exerciseInstanceId,
    int? setNumber,
    Value<int?> reps = const Value.absent(),
    Value<double?> weight = const Value.absent(),
    Value<String?> weightUnit = const Value.absent(),
    Value<int?> durationSeconds = const Value.absent(),
    bool? isCompleted,
    Value<String?> notes = const Value.absent(),
  }) => WorkoutSetTableData(
    id: id ?? this.id,
    exerciseInstanceId: exerciseInstanceId ?? this.exerciseInstanceId,
    setNumber: setNumber ?? this.setNumber,
    reps: reps.present ? reps.value : this.reps,
    weight: weight.present ? weight.value : this.weight,
    weightUnit: weightUnit.present ? weightUnit.value : this.weightUnit,
    durationSeconds:
        durationSeconds.present ? durationSeconds.value : this.durationSeconds,
    isCompleted: isCompleted ?? this.isCompleted,
    notes: notes.present ? notes.value : this.notes,
  );
  WorkoutSetTableData copyWithCompanion(WorkoutSetTableCompanion data) {
    return WorkoutSetTableData(
      id: data.id.present ? data.id.value : this.id,
      exerciseInstanceId:
          data.exerciseInstanceId.present
              ? data.exerciseInstanceId.value
              : this.exerciseInstanceId,
      setNumber: data.setNumber.present ? data.setNumber.value : this.setNumber,
      reps: data.reps.present ? data.reps.value : this.reps,
      weight: data.weight.present ? data.weight.value : this.weight,
      weightUnit:
          data.weightUnit.present ? data.weightUnit.value : this.weightUnit,
      durationSeconds:
          data.durationSeconds.present
              ? data.durationSeconds.value
              : this.durationSeconds,
      isCompleted:
          data.isCompleted.present ? data.isCompleted.value : this.isCompleted,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetTableData(')
          ..write('id: $id, ')
          ..write('exerciseInstanceId: $exerciseInstanceId, ')
          ..write('setNumber: $setNumber, ')
          ..write('reps: $reps, ')
          ..write('weight: $weight, ')
          ..write('weightUnit: $weightUnit, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    exerciseInstanceId,
    setNumber,
    reps,
    weight,
    weightUnit,
    durationSeconds,
    isCompleted,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSetTableData &&
          other.id == this.id &&
          other.exerciseInstanceId == this.exerciseInstanceId &&
          other.setNumber == this.setNumber &&
          other.reps == this.reps &&
          other.weight == this.weight &&
          other.weightUnit == this.weightUnit &&
          other.durationSeconds == this.durationSeconds &&
          other.isCompleted == this.isCompleted &&
          other.notes == this.notes);
}

class WorkoutSetTableCompanion extends UpdateCompanion<WorkoutSetTableData> {
  final Value<int> id;
  final Value<int> exerciseInstanceId;
  final Value<int> setNumber;
  final Value<int?> reps;
  final Value<double?> weight;
  final Value<String?> weightUnit;
  final Value<int?> durationSeconds;
  final Value<bool> isCompleted;
  final Value<String?> notes;
  const WorkoutSetTableCompanion({
    this.id = const Value.absent(),
    this.exerciseInstanceId = const Value.absent(),
    this.setNumber = const Value.absent(),
    this.reps = const Value.absent(),
    this.weight = const Value.absent(),
    this.weightUnit = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.notes = const Value.absent(),
  });
  WorkoutSetTableCompanion.insert({
    this.id = const Value.absent(),
    required int exerciseInstanceId,
    required int setNumber,
    this.reps = const Value.absent(),
    this.weight = const Value.absent(),
    this.weightUnit = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.notes = const Value.absent(),
  }) : exerciseInstanceId = Value(exerciseInstanceId),
       setNumber = Value(setNumber);
  static Insertable<WorkoutSetTableData> custom({
    Expression<int>? id,
    Expression<int>? exerciseInstanceId,
    Expression<int>? setNumber,
    Expression<int>? reps,
    Expression<double>? weight,
    Expression<String>? weightUnit,
    Expression<int>? durationSeconds,
    Expression<bool>? isCompleted,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exerciseInstanceId != null)
        'exercise_instance_id': exerciseInstanceId,
      if (setNumber != null) 'set_number': setNumber,
      if (reps != null) 'reps': reps,
      if (weight != null) 'weight': weight,
      if (weightUnit != null) 'weight_unit': weightUnit,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (notes != null) 'notes': notes,
    });
  }

  WorkoutSetTableCompanion copyWith({
    Value<int>? id,
    Value<int>? exerciseInstanceId,
    Value<int>? setNumber,
    Value<int?>? reps,
    Value<double?>? weight,
    Value<String?>? weightUnit,
    Value<int?>? durationSeconds,
    Value<bool>? isCompleted,
    Value<String?>? notes,
  }) {
    return WorkoutSetTableCompanion(
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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (exerciseInstanceId.present) {
      map['exercise_instance_id'] = Variable<int>(exerciseInstanceId.value);
    }
    if (setNumber.present) {
      map['set_number'] = Variable<int>(setNumber.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (weightUnit.present) {
      map['weight_unit'] = Variable<String>(weightUnit.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetTableCompanion(')
          ..write('id: $id, ')
          ..write('exerciseInstanceId: $exerciseInstanceId, ')
          ..write('setNumber: $setNumber, ')
          ..write('reps: $reps, ')
          ..write('weight: $weight, ')
          ..write('weightUnit: $weightUnit, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $WorkoutPlanTableTable extends WorkoutPlanTable
    with TableInfo<$WorkoutPlanTableTable, WorkoutPlanTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutPlanTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    startDate,
    endDate,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_plan_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutPlanTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutPlanTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutPlanTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      startDate:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}start_date'],
          )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      isActive:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_active'],
          )!,
    );
  }

  @override
  $WorkoutPlanTableTable createAlias(String alias) {
    return $WorkoutPlanTableTable(attachedDatabase, alias);
  }
}

class WorkoutPlanTableData extends DataClass
    implements Insertable<WorkoutPlanTableData> {
  final int id;
  final String name;
  final String? description;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isActive;
  const WorkoutPlanTableData({
    required this.id,
    required this.name,
    this.description,
    required this.startDate,
    this.endDate,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  WorkoutPlanTableCompanion toCompanion(bool nullToAbsent) {
    return WorkoutPlanTableCompanion(
      id: Value(id),
      name: Value(name),
      description:
          description == null && nullToAbsent
              ? const Value.absent()
              : Value(description),
      startDate: Value(startDate),
      endDate:
          endDate == null && nullToAbsent
              ? const Value.absent()
              : Value(endDate),
      isActive: Value(isActive),
    );
  }

  factory WorkoutPlanTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutPlanTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  WorkoutPlanTableData copyWith({
    int? id,
    String? name,
    Value<String?> description = const Value.absent(),
    DateTime? startDate,
    Value<DateTime?> endDate = const Value.absent(),
    bool? isActive,
  }) => WorkoutPlanTableData(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    isActive: isActive ?? this.isActive,
  );
  WorkoutPlanTableData copyWithCompanion(WorkoutPlanTableCompanion data) {
    return WorkoutPlanTableData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description:
          data.description.present ? data.description.value : this.description,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutPlanTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, description, startDate, endDate, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutPlanTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.isActive == this.isActive);
}

class WorkoutPlanTableCompanion extends UpdateCompanion<WorkoutPlanTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<bool> isActive;
  const WorkoutPlanTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  WorkoutPlanTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.isActive = const Value.absent(),
  }) : name = Value(name),
       startDate = Value(startDate);
  static Insertable<WorkoutPlanTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (isActive != null) 'is_active': isActive,
    });
  }

  WorkoutPlanTableCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<DateTime>? startDate,
    Value<DateTime?>? endDate,
    Value<bool>? isActive,
  }) {
    return WorkoutPlanTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutPlanTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $WorkoutPlanWorkoutTableTable extends WorkoutPlanWorkoutTable
    with TableInfo<$WorkoutPlanWorkoutTableTable, WorkoutPlanWorkoutTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutPlanWorkoutTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _planIdMeta = const VerificationMeta('planId');
  @override
  late final GeneratedColumn<int> planId = GeneratedColumn<int>(
    'plan_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_plan_table (id)',
    ),
  );
  static const VerificationMeta _workoutIdMeta = const VerificationMeta(
    'workoutId',
  );
  @override
  late final GeneratedColumn<int> workoutId = GeneratedColumn<int>(
    'workout_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES workout_table (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, planId, workoutId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_plan_workout_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutPlanWorkoutTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plan_id')) {
      context.handle(
        _planIdMeta,
        planId.isAcceptableOrUnknown(data['plan_id']!, _planIdMeta),
      );
    } else if (isInserting) {
      context.missing(_planIdMeta);
    }
    if (data.containsKey('workout_id')) {
      context.handle(
        _workoutIdMeta,
        workoutId.isAcceptableOrUnknown(data['workout_id']!, _workoutIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workoutIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutPlanWorkoutTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutPlanWorkoutTableData(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      planId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}plan_id'],
          )!,
      workoutId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}workout_id'],
          )!,
    );
  }

  @override
  $WorkoutPlanWorkoutTableTable createAlias(String alias) {
    return $WorkoutPlanWorkoutTableTable(attachedDatabase, alias);
  }
}

class WorkoutPlanWorkoutTableData extends DataClass
    implements Insertable<WorkoutPlanWorkoutTableData> {
  final int id;
  final int planId;
  final int workoutId;
  const WorkoutPlanWorkoutTableData({
    required this.id,
    required this.planId,
    required this.workoutId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['plan_id'] = Variable<int>(planId);
    map['workout_id'] = Variable<int>(workoutId);
    return map;
  }

  WorkoutPlanWorkoutTableCompanion toCompanion(bool nullToAbsent) {
    return WorkoutPlanWorkoutTableCompanion(
      id: Value(id),
      planId: Value(planId),
      workoutId: Value(workoutId),
    );
  }

  factory WorkoutPlanWorkoutTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutPlanWorkoutTableData(
      id: serializer.fromJson<int>(json['id']),
      planId: serializer.fromJson<int>(json['planId']),
      workoutId: serializer.fromJson<int>(json['workoutId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'planId': serializer.toJson<int>(planId),
      'workoutId': serializer.toJson<int>(workoutId),
    };
  }

  WorkoutPlanWorkoutTableData copyWith({
    int? id,
    int? planId,
    int? workoutId,
  }) => WorkoutPlanWorkoutTableData(
    id: id ?? this.id,
    planId: planId ?? this.planId,
    workoutId: workoutId ?? this.workoutId,
  );
  WorkoutPlanWorkoutTableData copyWithCompanion(
    WorkoutPlanWorkoutTableCompanion data,
  ) {
    return WorkoutPlanWorkoutTableData(
      id: data.id.present ? data.id.value : this.id,
      planId: data.planId.present ? data.planId.value : this.planId,
      workoutId: data.workoutId.present ? data.workoutId.value : this.workoutId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutPlanWorkoutTableData(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('workoutId: $workoutId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, planId, workoutId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutPlanWorkoutTableData &&
          other.id == this.id &&
          other.planId == this.planId &&
          other.workoutId == this.workoutId);
}

class WorkoutPlanWorkoutTableCompanion
    extends UpdateCompanion<WorkoutPlanWorkoutTableData> {
  final Value<int> id;
  final Value<int> planId;
  final Value<int> workoutId;
  const WorkoutPlanWorkoutTableCompanion({
    this.id = const Value.absent(),
    this.planId = const Value.absent(),
    this.workoutId = const Value.absent(),
  });
  WorkoutPlanWorkoutTableCompanion.insert({
    this.id = const Value.absent(),
    required int planId,
    required int workoutId,
  }) : planId = Value(planId),
       workoutId = Value(workoutId);
  static Insertable<WorkoutPlanWorkoutTableData> custom({
    Expression<int>? id,
    Expression<int>? planId,
    Expression<int>? workoutId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planId != null) 'plan_id': planId,
      if (workoutId != null) 'workout_id': workoutId,
    });
  }

  WorkoutPlanWorkoutTableCompanion copyWith({
    Value<int>? id,
    Value<int>? planId,
    Value<int>? workoutId,
  }) {
    return WorkoutPlanWorkoutTableCompanion(
      id: id ?? this.id,
      planId: planId ?? this.planId,
      workoutId: workoutId ?? this.workoutId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (planId.present) {
      map['plan_id'] = Variable<int>(planId.value);
    }
    if (workoutId.present) {
      map['workout_id'] = Variable<int>(workoutId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutPlanWorkoutTableCompanion(')
          ..write('id: $id, ')
          ..write('planId: $planId, ')
          ..write('workoutId: $workoutId')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FoodItemTable foodItem = $FoodItemTable(this);
  late final $UserSettingsTable userSettings = $UserSettingsTable(this);
  late final $MealTableTable mealTable = $MealTableTable(this);
  late final $MealFoodTableTable mealFoodTable = $MealFoodTableTable(this);
  late final $SearchCacheTableTable searchCacheTable = $SearchCacheTableTable(
    this,
  );
  late final $WeightRecordTable weightRecord = $WeightRecordTable(this);
  late final $ExerciseTableTable exerciseTable = $ExerciseTableTable(this);
  late final $WorkoutTableTable workoutTable = $WorkoutTableTable(this);
  late final $WorkoutExerciseTableTable workoutExerciseTable =
      $WorkoutExerciseTableTable(this);
  late final $WorkoutSetTableTable workoutSetTable = $WorkoutSetTableTable(
    this,
  );
  late final $WorkoutPlanTableTable workoutPlanTable = $WorkoutPlanTableTable(
    this,
  );
  late final $WorkoutPlanWorkoutTableTable workoutPlanWorkoutTable =
      $WorkoutPlanWorkoutTableTable(this);
  late final FoodItemDao foodItemDao = FoodItemDao(this as AppDatabase);
  late final UserSettingsDao userSettingsDao = UserSettingsDao(
    this as AppDatabase,
  );
  late final MealDao mealDao = MealDao(this as AppDatabase);
  late final SearchCacheDao searchCacheDao = SearchCacheDao(
    this as AppDatabase,
  );
  late final WeightRecordDao weightRecordDao = WeightRecordDao(
    this as AppDatabase,
  );
  late final ExerciseDao exerciseDao = ExerciseDao(this as AppDatabase);
  late final WorkoutDao workoutDao = WorkoutDao(this as AppDatabase);
  late final WorkoutPlanDao workoutPlanDao = WorkoutPlanDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    foodItem,
    userSettings,
    mealTable,
    mealFoodTable,
    searchCacheTable,
    weightRecord,
    exerciseTable,
    workoutTable,
    workoutExerciseTable,
    workoutSetTable,
    workoutPlanTable,
    workoutPlanWorkoutTable,
  ];
}

typedef $$FoodItemTableCreateCompanionBuilder =
    FoodItemCompanion Function({
      Value<int> id,
      required String name,
      required int calories,
      required int protein,
      required int carbs,
      required int fat,
      Value<int> gramm,
    });
typedef $$FoodItemTableUpdateCompanionBuilder =
    FoodItemCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> calories,
      Value<int> protein,
      Value<int> carbs,
      Value<int> fat,
      Value<int> gramm,
    });

final class $$FoodItemTableReferences
    extends BaseReferences<_$AppDatabase, $FoodItemTable, FoodItemData> {
  $$FoodItemTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MealFoodTableTable, List<MealFoodTableData>>
  _mealFoodTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mealFoodTable,
    aliasName: $_aliasNameGenerator(
      db.foodItem.id,
      db.mealFoodTable.foodEntryId,
    ),
  );

  $$MealFoodTableTableProcessedTableManager get mealFoodTableRefs {
    final manager = $$MealFoodTableTableTableManager(
      $_db,
      $_db.mealFoodTable,
    ).filter((f) => f.foodEntryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealFoodTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FoodItemTableFilterComposer
    extends Composer<_$AppDatabase, $FoodItemTable> {
  $$FoodItemTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get protein => $composableBuilder(
    column: $table.protein,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get carbs => $composableBuilder(
    column: $table.carbs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fat => $composableBuilder(
    column: $table.fat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gramm => $composableBuilder(
    column: $table.gramm,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> mealFoodTableRefs(
    Expression<bool> Function($$MealFoodTableTableFilterComposer f) f,
  ) {
    final $$MealFoodTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealFoodTable,
      getReferencedColumn: (t) => t.foodEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealFoodTableTableFilterComposer(
            $db: $db,
            $table: $db.mealFoodTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FoodItemTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodItemTable> {
  $$FoodItemTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get calories => $composableBuilder(
    column: $table.calories,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get protein => $composableBuilder(
    column: $table.protein,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get carbs => $composableBuilder(
    column: $table.carbs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fat => $composableBuilder(
    column: $table.fat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gramm => $composableBuilder(
    column: $table.gramm,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FoodItemTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodItemTable> {
  $$FoodItemTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get calories =>
      $composableBuilder(column: $table.calories, builder: (column) => column);

  GeneratedColumn<int> get protein =>
      $composableBuilder(column: $table.protein, builder: (column) => column);

  GeneratedColumn<int> get carbs =>
      $composableBuilder(column: $table.carbs, builder: (column) => column);

  GeneratedColumn<int> get fat =>
      $composableBuilder(column: $table.fat, builder: (column) => column);

  GeneratedColumn<int> get gramm =>
      $composableBuilder(column: $table.gramm, builder: (column) => column);

  Expression<T> mealFoodTableRefs<T extends Object>(
    Expression<T> Function($$MealFoodTableTableAnnotationComposer a) f,
  ) {
    final $$MealFoodTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealFoodTable,
      getReferencedColumn: (t) => t.foodEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealFoodTableTableAnnotationComposer(
            $db: $db,
            $table: $db.mealFoodTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FoodItemTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoodItemTable,
          FoodItemData,
          $$FoodItemTableFilterComposer,
          $$FoodItemTableOrderingComposer,
          $$FoodItemTableAnnotationComposer,
          $$FoodItemTableCreateCompanionBuilder,
          $$FoodItemTableUpdateCompanionBuilder,
          (FoodItemData, $$FoodItemTableReferences),
          FoodItemData,
          PrefetchHooks Function({bool mealFoodTableRefs})
        > {
  $$FoodItemTableTableManager(_$AppDatabase db, $FoodItemTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$FoodItemTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$FoodItemTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$FoodItemTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> calories = const Value.absent(),
                Value<int> protein = const Value.absent(),
                Value<int> carbs = const Value.absent(),
                Value<int> fat = const Value.absent(),
                Value<int> gramm = const Value.absent(),
              }) => FoodItemCompanion(
                id: id,
                name: name,
                calories: calories,
                protein: protein,
                carbs: carbs,
                fat: fat,
                gramm: gramm,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int calories,
                required int protein,
                required int carbs,
                required int fat,
                Value<int> gramm = const Value.absent(),
              }) => FoodItemCompanion.insert(
                id: id,
                name: name,
                calories: calories,
                protein: protein,
                carbs: carbs,
                fat: fat,
                gramm: gramm,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$FoodItemTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({mealFoodTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (mealFoodTableRefs) db.mealFoodTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mealFoodTableRefs)
                    await $_getPrefetchedData<
                      FoodItemData,
                      $FoodItemTable,
                      MealFoodTableData
                    >(
                      currentTable: table,
                      referencedTable: $$FoodItemTableReferences
                          ._mealFoodTableRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$FoodItemTableReferences(
                                db,
                                table,
                                p0,
                              ).mealFoodTableRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.foodEntryId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$FoodItemTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoodItemTable,
      FoodItemData,
      $$FoodItemTableFilterComposer,
      $$FoodItemTableOrderingComposer,
      $$FoodItemTableAnnotationComposer,
      $$FoodItemTableCreateCompanionBuilder,
      $$FoodItemTableUpdateCompanionBuilder,
      (FoodItemData, $$FoodItemTableReferences),
      FoodItemData,
      PrefetchHooks Function({bool mealFoodTableRefs})
    >;
typedef $$UserSettingsTableCreateCompanionBuilder =
    UserSettingsCompanion Function({
      Value<int> id,
      Value<int> dailyCalorieGoal,
      Value<String> themeMode,
      Value<int> age,
      Value<int> heightCm,
      Value<String> sex,
      Value<int> activityLevel,
      Value<int> goalType,
      Value<double> startingWeight,
      Value<double> goalWeight,
    });
typedef $$UserSettingsTableUpdateCompanionBuilder =
    UserSettingsCompanion Function({
      Value<int> id,
      Value<int> dailyCalorieGoal,
      Value<String> themeMode,
      Value<int> age,
      Value<int> heightCm,
      Value<String> sex,
      Value<int> activityLevel,
      Value<int> goalType,
      Value<double> startingWeight,
      Value<double> goalWeight,
    });

class $$UserSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyCalorieGoal => $composableBuilder(
    column: $table.dailyCalorieGoal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get goalType => $composableBuilder(
    column: $table.goalType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get startingWeight => $composableBuilder(
    column: $table.startingWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get goalWeight => $composableBuilder(
    column: $table.goalWeight,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyCalorieGoal => $composableBuilder(
    column: $table.dailyCalorieGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get goalType => $composableBuilder(
    column: $table.goalType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get startingWeight => $composableBuilder(
    column: $table.startingWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get goalWeight => $composableBuilder(
    column: $table.goalWeight,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get dailyCalorieGoal => $composableBuilder(
    column: $table.dailyCalorieGoal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<int> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<int> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get goalType =>
      $composableBuilder(column: $table.goalType, builder: (column) => column);

  GeneratedColumn<double> get startingWeight => $composableBuilder(
    column: $table.startingWeight,
    builder: (column) => column,
  );

  GeneratedColumn<double> get goalWeight => $composableBuilder(
    column: $table.goalWeight,
    builder: (column) => column,
  );
}

class $$UserSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserSettingsTable,
          UserSetting,
          $$UserSettingsTableFilterComposer,
          $$UserSettingsTableOrderingComposer,
          $$UserSettingsTableAnnotationComposer,
          $$UserSettingsTableCreateCompanionBuilder,
          $$UserSettingsTableUpdateCompanionBuilder,
          (
            UserSetting,
            BaseReferences<_$AppDatabase, $UserSettingsTable, UserSetting>,
          ),
          UserSetting,
          PrefetchHooks Function()
        > {
  $$UserSettingsTableTableManager(_$AppDatabase db, $UserSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$UserSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$UserSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$UserSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> dailyCalorieGoal = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<int> age = const Value.absent(),
                Value<int> heightCm = const Value.absent(),
                Value<String> sex = const Value.absent(),
                Value<int> activityLevel = const Value.absent(),
                Value<int> goalType = const Value.absent(),
                Value<double> startingWeight = const Value.absent(),
                Value<double> goalWeight = const Value.absent(),
              }) => UserSettingsCompanion(
                id: id,
                dailyCalorieGoal: dailyCalorieGoal,
                themeMode: themeMode,
                age: age,
                heightCm: heightCm,
                sex: sex,
                activityLevel: activityLevel,
                goalType: goalType,
                startingWeight: startingWeight,
                goalWeight: goalWeight,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> dailyCalorieGoal = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<int> age = const Value.absent(),
                Value<int> heightCm = const Value.absent(),
                Value<String> sex = const Value.absent(),
                Value<int> activityLevel = const Value.absent(),
                Value<int> goalType = const Value.absent(),
                Value<double> startingWeight = const Value.absent(),
                Value<double> goalWeight = const Value.absent(),
              }) => UserSettingsCompanion.insert(
                id: id,
                dailyCalorieGoal: dailyCalorieGoal,
                themeMode: themeMode,
                age: age,
                heightCm: heightCm,
                sex: sex,
                activityLevel: activityLevel,
                goalType: goalType,
                startingWeight: startingWeight,
                goalWeight: goalWeight,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserSettingsTable,
      UserSetting,
      $$UserSettingsTableFilterComposer,
      $$UserSettingsTableOrderingComposer,
      $$UserSettingsTableAnnotationComposer,
      $$UserSettingsTableCreateCompanionBuilder,
      $$UserSettingsTableUpdateCompanionBuilder,
      (
        UserSetting,
        BaseReferences<_$AppDatabase, $UserSettingsTable, UserSetting>,
      ),
      UserSetting,
      PrefetchHooks Function()
    >;
typedef $$MealTableTableCreateCompanionBuilder =
    MealTableCompanion Function({
      Value<int> id,
      required DateTime date,
      required String category,
      required int foodItemId,
    });
typedef $$MealTableTableUpdateCompanionBuilder =
    MealTableCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<String> category,
      Value<int> foodItemId,
    });

final class $$MealTableTableReferences
    extends BaseReferences<_$AppDatabase, $MealTableTable, MealTableData> {
  $$MealTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MealFoodTableTable, List<MealFoodTableData>>
  _mealFoodTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.mealFoodTable,
    aliasName: $_aliasNameGenerator(db.mealTable.id, db.mealFoodTable.mealId),
  );

  $$MealFoodTableTableProcessedTableManager get mealFoodTableRefs {
    final manager = $$MealFoodTableTableTableManager(
      $_db,
      $_db.mealFoodTable,
    ).filter((f) => f.mealId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealFoodTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MealTableTableFilterComposer
    extends Composer<_$AppDatabase, $MealTableTable> {
  $$MealTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get foodItemId => $composableBuilder(
    column: $table.foodItemId,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> mealFoodTableRefs(
    Expression<bool> Function($$MealFoodTableTableFilterComposer f) f,
  ) {
    final $$MealFoodTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealFoodTable,
      getReferencedColumn: (t) => t.mealId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealFoodTableTableFilterComposer(
            $db: $db,
            $table: $db.mealFoodTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MealTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MealTableTable> {
  $$MealTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get foodItemId => $composableBuilder(
    column: $table.foodItemId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MealTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealTableTable> {
  $$MealTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get foodItemId => $composableBuilder(
    column: $table.foodItemId,
    builder: (column) => column,
  );

  Expression<T> mealFoodTableRefs<T extends Object>(
    Expression<T> Function($$MealFoodTableTableAnnotationComposer a) f,
  ) {
    final $$MealFoodTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.mealFoodTable,
      getReferencedColumn: (t) => t.mealId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealFoodTableTableAnnotationComposer(
            $db: $db,
            $table: $db.mealFoodTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MealTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealTableTable,
          MealTableData,
          $$MealTableTableFilterComposer,
          $$MealTableTableOrderingComposer,
          $$MealTableTableAnnotationComposer,
          $$MealTableTableCreateCompanionBuilder,
          $$MealTableTableUpdateCompanionBuilder,
          (MealTableData, $$MealTableTableReferences),
          MealTableData,
          PrefetchHooks Function({bool mealFoodTableRefs})
        > {
  $$MealTableTableTableManager(_$AppDatabase db, $MealTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$MealTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$MealTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$MealTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> foodItemId = const Value.absent(),
              }) => MealTableCompanion(
                id: id,
                date: date,
                category: category,
                foodItemId: foodItemId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required String category,
                required int foodItemId,
              }) => MealTableCompanion.insert(
                id: id,
                date: date,
                category: category,
                foodItemId: foodItemId,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$MealTableTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({mealFoodTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (mealFoodTableRefs) db.mealFoodTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mealFoodTableRefs)
                    await $_getPrefetchedData<
                      MealTableData,
                      $MealTableTable,
                      MealFoodTableData
                    >(
                      currentTable: table,
                      referencedTable: $$MealTableTableReferences
                          ._mealFoodTableRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$MealTableTableReferences(
                                db,
                                table,
                                p0,
                              ).mealFoodTableRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.mealId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MealTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealTableTable,
      MealTableData,
      $$MealTableTableFilterComposer,
      $$MealTableTableOrderingComposer,
      $$MealTableTableAnnotationComposer,
      $$MealTableTableCreateCompanionBuilder,
      $$MealTableTableUpdateCompanionBuilder,
      (MealTableData, $$MealTableTableReferences),
      MealTableData,
      PrefetchHooks Function({bool mealFoodTableRefs})
    >;
typedef $$MealFoodTableTableCreateCompanionBuilder =
    MealFoodTableCompanion Function({
      Value<int> id,
      required int mealId,
      required int foodEntryId,
    });
typedef $$MealFoodTableTableUpdateCompanionBuilder =
    MealFoodTableCompanion Function({
      Value<int> id,
      Value<int> mealId,
      Value<int> foodEntryId,
    });

final class $$MealFoodTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $MealFoodTableTable, MealFoodTableData> {
  $$MealFoodTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $MealTableTable _mealIdTable(_$AppDatabase db) =>
      db.mealTable.createAlias(
        $_aliasNameGenerator(db.mealFoodTable.mealId, db.mealTable.id),
      );

  $$MealTableTableProcessedTableManager get mealId {
    final $_column = $_itemColumn<int>('meal_id')!;

    final manager = $$MealTableTableTableManager(
      $_db,
      $_db.mealTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mealIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $FoodItemTable _foodEntryIdTable(_$AppDatabase db) =>
      db.foodItem.createAlias(
        $_aliasNameGenerator(db.mealFoodTable.foodEntryId, db.foodItem.id),
      );

  $$FoodItemTableProcessedTableManager get foodEntryId {
    final $_column = $_itemColumn<int>('food_entry_id')!;

    final manager = $$FoodItemTableTableManager(
      $_db,
      $_db.foodItem,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_foodEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MealFoodTableTableFilterComposer
    extends Composer<_$AppDatabase, $MealFoodTableTable> {
  $$MealFoodTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  $$MealTableTableFilterComposer get mealId {
    final $$MealTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealId,
      referencedTable: $db.mealTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealTableTableFilterComposer(
            $db: $db,
            $table: $db.mealTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FoodItemTableFilterComposer get foodEntryId {
    final $$FoodItemTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodEntryId,
      referencedTable: $db.foodItem,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodItemTableFilterComposer(
            $db: $db,
            $table: $db.foodItem,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealFoodTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MealFoodTableTable> {
  $$MealFoodTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  $$MealTableTableOrderingComposer get mealId {
    final $$MealTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealId,
      referencedTable: $db.mealTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealTableTableOrderingComposer(
            $db: $db,
            $table: $db.mealTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FoodItemTableOrderingComposer get foodEntryId {
    final $$FoodItemTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodEntryId,
      referencedTable: $db.foodItem,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodItemTableOrderingComposer(
            $db: $db,
            $table: $db.foodItem,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealFoodTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealFoodTableTable> {
  $$MealFoodTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  $$MealTableTableAnnotationComposer get mealId {
    final $$MealTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealId,
      referencedTable: $db.mealTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealTableTableAnnotationComposer(
            $db: $db,
            $table: $db.mealTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FoodItemTableAnnotationComposer get foodEntryId {
    final $$FoodItemTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodEntryId,
      referencedTable: $db.foodItem,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodItemTableAnnotationComposer(
            $db: $db,
            $table: $db.foodItem,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealFoodTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealFoodTableTable,
          MealFoodTableData,
          $$MealFoodTableTableFilterComposer,
          $$MealFoodTableTableOrderingComposer,
          $$MealFoodTableTableAnnotationComposer,
          $$MealFoodTableTableCreateCompanionBuilder,
          $$MealFoodTableTableUpdateCompanionBuilder,
          (MealFoodTableData, $$MealFoodTableTableReferences),
          MealFoodTableData,
          PrefetchHooks Function({bool mealId, bool foodEntryId})
        > {
  $$MealFoodTableTableTableManager(_$AppDatabase db, $MealFoodTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$MealFoodTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$MealFoodTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$MealFoodTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> mealId = const Value.absent(),
                Value<int> foodEntryId = const Value.absent(),
              }) => MealFoodTableCompanion(
                id: id,
                mealId: mealId,
                foodEntryId: foodEntryId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int mealId,
                required int foodEntryId,
              }) => MealFoodTableCompanion.insert(
                id: id,
                mealId: mealId,
                foodEntryId: foodEntryId,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$MealFoodTableTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({mealId = false, foodEntryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (mealId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.mealId,
                            referencedTable: $$MealFoodTableTableReferences
                                ._mealIdTable(db),
                            referencedColumn:
                                $$MealFoodTableTableReferences
                                    ._mealIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (foodEntryId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.foodEntryId,
                            referencedTable: $$MealFoodTableTableReferences
                                ._foodEntryIdTable(db),
                            referencedColumn:
                                $$MealFoodTableTableReferences
                                    ._foodEntryIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MealFoodTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealFoodTableTable,
      MealFoodTableData,
      $$MealFoodTableTableFilterComposer,
      $$MealFoodTableTableOrderingComposer,
      $$MealFoodTableTableAnnotationComposer,
      $$MealFoodTableTableCreateCompanionBuilder,
      $$MealFoodTableTableUpdateCompanionBuilder,
      (MealFoodTableData, $$MealFoodTableTableReferences),
      MealFoodTableData,
      PrefetchHooks Function({bool mealId, bool foodEntryId})
    >;
typedef $$SearchCacheTableTableCreateCompanionBuilder =
    SearchCacheTableCompanion Function({
      required String query,
      required String json,
      required int ts,
      Value<int> rowid,
    });
typedef $$SearchCacheTableTableUpdateCompanionBuilder =
    SearchCacheTableCompanion Function({
      Value<String> query,
      Value<String> json,
      Value<int> ts,
      Value<int> rowid,
    });

class $$SearchCacheTableTableFilterComposer
    extends Composer<_$AppDatabase, $SearchCacheTableTable> {
  $$SearchCacheTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get query => $composableBuilder(
    column: $table.query,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ts => $composableBuilder(
    column: $table.ts,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SearchCacheTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SearchCacheTableTable> {
  $$SearchCacheTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get query => $composableBuilder(
    column: $table.query,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ts => $composableBuilder(
    column: $table.ts,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SearchCacheTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SearchCacheTableTable> {
  $$SearchCacheTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get query =>
      $composableBuilder(column: $table.query, builder: (column) => column);

  GeneratedColumn<String> get json =>
      $composableBuilder(column: $table.json, builder: (column) => column);

  GeneratedColumn<int> get ts =>
      $composableBuilder(column: $table.ts, builder: (column) => column);
}

class $$SearchCacheTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SearchCacheTableTable,
          SearchCacheTableData,
          $$SearchCacheTableTableFilterComposer,
          $$SearchCacheTableTableOrderingComposer,
          $$SearchCacheTableTableAnnotationComposer,
          $$SearchCacheTableTableCreateCompanionBuilder,
          $$SearchCacheTableTableUpdateCompanionBuilder,
          (
            SearchCacheTableData,
            BaseReferences<
              _$AppDatabase,
              $SearchCacheTableTable,
              SearchCacheTableData
            >,
          ),
          SearchCacheTableData,
          PrefetchHooks Function()
        > {
  $$SearchCacheTableTableTableManager(
    _$AppDatabase db,
    $SearchCacheTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$SearchCacheTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$SearchCacheTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$SearchCacheTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> query = const Value.absent(),
                Value<String> json = const Value.absent(),
                Value<int> ts = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SearchCacheTableCompanion(
                query: query,
                json: json,
                ts: ts,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String query,
                required String json,
                required int ts,
                Value<int> rowid = const Value.absent(),
              }) => SearchCacheTableCompanion.insert(
                query: query,
                json: json,
                ts: ts,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SearchCacheTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SearchCacheTableTable,
      SearchCacheTableData,
      $$SearchCacheTableTableFilterComposer,
      $$SearchCacheTableTableOrderingComposer,
      $$SearchCacheTableTableAnnotationComposer,
      $$SearchCacheTableTableCreateCompanionBuilder,
      $$SearchCacheTableTableUpdateCompanionBuilder,
      (
        SearchCacheTableData,
        BaseReferences<
          _$AppDatabase,
          $SearchCacheTableTable,
          SearchCacheTableData
        >,
      ),
      SearchCacheTableData,
      PrefetchHooks Function()
    >;
typedef $$WeightRecordTableCreateCompanionBuilder =
    WeightRecordCompanion Function({
      Value<int> id,
      required DateTime date,
      required double weight,
      Value<String?> note,
    });
typedef $$WeightRecordTableUpdateCompanionBuilder =
    WeightRecordCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<double> weight,
      Value<String?> note,
    });

class $$WeightRecordTableFilterComposer
    extends Composer<_$AppDatabase, $WeightRecordTable> {
  $$WeightRecordTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeightRecordTableOrderingComposer
    extends Composer<_$AppDatabase, $WeightRecordTable> {
  $$WeightRecordTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeightRecordTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeightRecordTable> {
  $$WeightRecordTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$WeightRecordTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeightRecordTable,
          WeightRecordData,
          $$WeightRecordTableFilterComposer,
          $$WeightRecordTableOrderingComposer,
          $$WeightRecordTableAnnotationComposer,
          $$WeightRecordTableCreateCompanionBuilder,
          $$WeightRecordTableUpdateCompanionBuilder,
          (
            WeightRecordData,
            BaseReferences<_$AppDatabase, $WeightRecordTable, WeightRecordData>,
          ),
          WeightRecordData,
          PrefetchHooks Function()
        > {
  $$WeightRecordTableTableManager(_$AppDatabase db, $WeightRecordTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$WeightRecordTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$WeightRecordTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$WeightRecordTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double> weight = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => WeightRecordCompanion(
                id: id,
                date: date,
                weight: weight,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required double weight,
                Value<String?> note = const Value.absent(),
              }) => WeightRecordCompanion.insert(
                id: id,
                date: date,
                weight: weight,
                note: note,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeightRecordTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeightRecordTable,
      WeightRecordData,
      $$WeightRecordTableFilterComposer,
      $$WeightRecordTableOrderingComposer,
      $$WeightRecordTableAnnotationComposer,
      $$WeightRecordTableCreateCompanionBuilder,
      $$WeightRecordTableUpdateCompanionBuilder,
      (
        WeightRecordData,
        BaseReferences<_$AppDatabase, $WeightRecordTable, WeightRecordData>,
      ),
      WeightRecordData,
      PrefetchHooks Function()
    >;
typedef $$ExerciseTableTableCreateCompanionBuilder =
    ExerciseTableCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> description,
      required int type,
      required String targetMuscleGroups,
      Value<String?> imageUrl,
      Value<bool> isCustom,
    });
typedef $$ExerciseTableTableUpdateCompanionBuilder =
    ExerciseTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> description,
      Value<int> type,
      Value<String> targetMuscleGroups,
      Value<String?> imageUrl,
      Value<bool> isCustom,
    });

final class $$ExerciseTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $ExerciseTableTable, ExerciseTableData> {
  $$ExerciseTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $WorkoutExerciseTableTable,
    List<WorkoutExerciseTableData>
  >
  _workoutExerciseTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.workoutExerciseTable,
        aliasName: $_aliasNameGenerator(
          db.exerciseTable.id,
          db.workoutExerciseTable.exerciseId,
        ),
      );

  $$WorkoutExerciseTableTableProcessedTableManager
  get workoutExerciseTableRefs {
    final manager = $$WorkoutExerciseTableTableTableManager(
      $_db,
      $_db.workoutExerciseTable,
    ).filter((f) => f.exerciseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutExerciseTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ExerciseTableTableFilterComposer
    extends Composer<_$AppDatabase, $ExerciseTableTable> {
  $$ExerciseTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetMuscleGroups => $composableBuilder(
    column: $table.targetMuscleGroups,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> workoutExerciseTableRefs(
    Expression<bool> Function($$WorkoutExerciseTableTableFilterComposer f) f,
  ) {
    final $$WorkoutExerciseTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutExerciseTable,
      getReferencedColumn: (t) => t.exerciseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExerciseTableTableFilterComposer(
            $db: $db,
            $table: $db.workoutExerciseTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ExerciseTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ExerciseTableTable> {
  $$ExerciseTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetMuscleGroups => $composableBuilder(
    column: $table.targetMuscleGroups,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCustom => $composableBuilder(
    column: $table.isCustom,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExerciseTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExerciseTableTable> {
  $$ExerciseTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get targetMuscleGroups => $composableBuilder(
    column: $table.targetMuscleGroups,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<bool> get isCustom =>
      $composableBuilder(column: $table.isCustom, builder: (column) => column);

  Expression<T> workoutExerciseTableRefs<T extends Object>(
    Expression<T> Function($$WorkoutExerciseTableTableAnnotationComposer a) f,
  ) {
    final $$WorkoutExerciseTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workoutExerciseTable,
          getReferencedColumn: (t) => t.exerciseId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutExerciseTableTableAnnotationComposer(
                $db: $db,
                $table: $db.workoutExerciseTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$ExerciseTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExerciseTableTable,
          ExerciseTableData,
          $$ExerciseTableTableFilterComposer,
          $$ExerciseTableTableOrderingComposer,
          $$ExerciseTableTableAnnotationComposer,
          $$ExerciseTableTableCreateCompanionBuilder,
          $$ExerciseTableTableUpdateCompanionBuilder,
          (ExerciseTableData, $$ExerciseTableTableReferences),
          ExerciseTableData,
          PrefetchHooks Function({bool workoutExerciseTableRefs})
        > {
  $$ExerciseTableTableTableManager(_$AppDatabase db, $ExerciseTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ExerciseTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$ExerciseTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ExerciseTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> type = const Value.absent(),
                Value<String> targetMuscleGroups = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
              }) => ExerciseTableCompanion(
                id: id,
                name: name,
                description: description,
                type: type,
                targetMuscleGroups: targetMuscleGroups,
                imageUrl: imageUrl,
                isCustom: isCustom,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                required int type,
                required String targetMuscleGroups,
                Value<String?> imageUrl = const Value.absent(),
                Value<bool> isCustom = const Value.absent(),
              }) => ExerciseTableCompanion.insert(
                id: id,
                name: name,
                description: description,
                type: type,
                targetMuscleGroups: targetMuscleGroups,
                imageUrl: imageUrl,
                isCustom: isCustom,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$ExerciseTableTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({workoutExerciseTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (workoutExerciseTableRefs) db.workoutExerciseTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workoutExerciseTableRefs)
                    await $_getPrefetchedData<
                      ExerciseTableData,
                      $ExerciseTableTable,
                      WorkoutExerciseTableData
                    >(
                      currentTable: table,
                      referencedTable: $$ExerciseTableTableReferences
                          ._workoutExerciseTableRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$ExerciseTableTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutExerciseTableRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.exerciseId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ExerciseTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExerciseTableTable,
      ExerciseTableData,
      $$ExerciseTableTableFilterComposer,
      $$ExerciseTableTableOrderingComposer,
      $$ExerciseTableTableAnnotationComposer,
      $$ExerciseTableTableCreateCompanionBuilder,
      $$ExerciseTableTableUpdateCompanionBuilder,
      (ExerciseTableData, $$ExerciseTableTableReferences),
      ExerciseTableData,
      PrefetchHooks Function({bool workoutExerciseTableRefs})
    >;
typedef $$WorkoutTableTableCreateCompanionBuilder =
    WorkoutTableCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> description,
      required int difficulty,
      Value<int> estimatedDurationMinutes,
      Value<bool> isTemplate,
      Value<DateTime?> scheduledDate,
      Value<DateTime?> completedDate,
    });
typedef $$WorkoutTableTableUpdateCompanionBuilder =
    WorkoutTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> description,
      Value<int> difficulty,
      Value<int> estimatedDurationMinutes,
      Value<bool> isTemplate,
      Value<DateTime?> scheduledDate,
      Value<DateTime?> completedDate,
    });

final class $$WorkoutTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $WorkoutTableTable, WorkoutTableData> {
  $$WorkoutTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $WorkoutExerciseTableTable,
    List<WorkoutExerciseTableData>
  >
  _workoutExerciseTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.workoutExerciseTable,
        aliasName: $_aliasNameGenerator(
          db.workoutTable.id,
          db.workoutExerciseTable.workoutId,
        ),
      );

  $$WorkoutExerciseTableTableProcessedTableManager
  get workoutExerciseTableRefs {
    final manager = $$WorkoutExerciseTableTableTableManager(
      $_db,
      $_db.workoutExerciseTable,
    ).filter((f) => f.workoutId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutExerciseTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $WorkoutPlanWorkoutTableTable,
    List<WorkoutPlanWorkoutTableData>
  >
  _workoutPlanWorkoutTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.workoutPlanWorkoutTable,
        aliasName: $_aliasNameGenerator(
          db.workoutTable.id,
          db.workoutPlanWorkoutTable.workoutId,
        ),
      );

  $$WorkoutPlanWorkoutTableTableProcessedTableManager
  get workoutPlanWorkoutTableRefs {
    final manager = $$WorkoutPlanWorkoutTableTableTableManager(
      $_db,
      $_db.workoutPlanWorkoutTable,
    ).filter((f) => f.workoutId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutPlanWorkoutTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutTableTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutTableTable> {
  $$WorkoutTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedDurationMinutes => $composableBuilder(
    column: $table.estimatedDurationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isTemplate => $composableBuilder(
    column: $table.isTemplate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedDate => $composableBuilder(
    column: $table.completedDate,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> workoutExerciseTableRefs(
    Expression<bool> Function($$WorkoutExerciseTableTableFilterComposer f) f,
  ) {
    final $$WorkoutExerciseTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutExerciseTable,
      getReferencedColumn: (t) => t.workoutId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExerciseTableTableFilterComposer(
            $db: $db,
            $table: $db.workoutExerciseTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> workoutPlanWorkoutTableRefs(
    Expression<bool> Function($$WorkoutPlanWorkoutTableTableFilterComposer f) f,
  ) {
    final $$WorkoutPlanWorkoutTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workoutPlanWorkoutTable,
          getReferencedColumn: (t) => t.workoutId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutPlanWorkoutTableTableFilterComposer(
                $db: $db,
                $table: $db.workoutPlanWorkoutTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WorkoutTableTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutTableTable> {
  $$WorkoutTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedDurationMinutes => $composableBuilder(
    column: $table.estimatedDurationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isTemplate => $composableBuilder(
    column: $table.isTemplate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedDate => $composableBuilder(
    column: $table.completedDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutTableTable> {
  $$WorkoutTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<int> get estimatedDurationMinutes => $composableBuilder(
    column: $table.estimatedDurationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isTemplate => $composableBuilder(
    column: $table.isTemplate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get scheduledDate => $composableBuilder(
    column: $table.scheduledDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get completedDate => $composableBuilder(
    column: $table.completedDate,
    builder: (column) => column,
  );

  Expression<T> workoutExerciseTableRefs<T extends Object>(
    Expression<T> Function($$WorkoutExerciseTableTableAnnotationComposer a) f,
  ) {
    final $$WorkoutExerciseTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workoutExerciseTable,
          getReferencedColumn: (t) => t.workoutId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutExerciseTableTableAnnotationComposer(
                $db: $db,
                $table: $db.workoutExerciseTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> workoutPlanWorkoutTableRefs<T extends Object>(
    Expression<T> Function($$WorkoutPlanWorkoutTableTableAnnotationComposer a)
    f,
  ) {
    final $$WorkoutPlanWorkoutTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workoutPlanWorkoutTable,
          getReferencedColumn: (t) => t.workoutId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutPlanWorkoutTableTableAnnotationComposer(
                $db: $db,
                $table: $db.workoutPlanWorkoutTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WorkoutTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutTableTable,
          WorkoutTableData,
          $$WorkoutTableTableFilterComposer,
          $$WorkoutTableTableOrderingComposer,
          $$WorkoutTableTableAnnotationComposer,
          $$WorkoutTableTableCreateCompanionBuilder,
          $$WorkoutTableTableUpdateCompanionBuilder,
          (WorkoutTableData, $$WorkoutTableTableReferences),
          WorkoutTableData,
          PrefetchHooks Function({
            bool workoutExerciseTableRefs,
            bool workoutPlanWorkoutTableRefs,
          })
        > {
  $$WorkoutTableTableTableManager(_$AppDatabase db, $WorkoutTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$WorkoutTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$WorkoutTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$WorkoutTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> difficulty = const Value.absent(),
                Value<int> estimatedDurationMinutes = const Value.absent(),
                Value<bool> isTemplate = const Value.absent(),
                Value<DateTime?> scheduledDate = const Value.absent(),
                Value<DateTime?> completedDate = const Value.absent(),
              }) => WorkoutTableCompanion(
                id: id,
                name: name,
                description: description,
                difficulty: difficulty,
                estimatedDurationMinutes: estimatedDurationMinutes,
                isTemplate: isTemplate,
                scheduledDate: scheduledDate,
                completedDate: completedDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                required int difficulty,
                Value<int> estimatedDurationMinutes = const Value.absent(),
                Value<bool> isTemplate = const Value.absent(),
                Value<DateTime?> scheduledDate = const Value.absent(),
                Value<DateTime?> completedDate = const Value.absent(),
              }) => WorkoutTableCompanion.insert(
                id: id,
                name: name,
                description: description,
                difficulty: difficulty,
                estimatedDurationMinutes: estimatedDurationMinutes,
                isTemplate: isTemplate,
                scheduledDate: scheduledDate,
                completedDate: completedDate,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$WorkoutTableTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            workoutExerciseTableRefs = false,
            workoutPlanWorkoutTableRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (workoutExerciseTableRefs) db.workoutExerciseTable,
                if (workoutPlanWorkoutTableRefs) db.workoutPlanWorkoutTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workoutExerciseTableRefs)
                    await $_getPrefetchedData<
                      WorkoutTableData,
                      $WorkoutTableTable,
                      WorkoutExerciseTableData
                    >(
                      currentTable: table,
                      referencedTable: $$WorkoutTableTableReferences
                          ._workoutExerciseTableRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$WorkoutTableTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutExerciseTableRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.workoutId == item.id,
                          ),
                      typedResults: items,
                    ),
                  if (workoutPlanWorkoutTableRefs)
                    await $_getPrefetchedData<
                      WorkoutTableData,
                      $WorkoutTableTable,
                      WorkoutPlanWorkoutTableData
                    >(
                      currentTable: table,
                      referencedTable: $$WorkoutTableTableReferences
                          ._workoutPlanWorkoutTableRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$WorkoutTableTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutPlanWorkoutTableRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.workoutId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutTableTable,
      WorkoutTableData,
      $$WorkoutTableTableFilterComposer,
      $$WorkoutTableTableOrderingComposer,
      $$WorkoutTableTableAnnotationComposer,
      $$WorkoutTableTableCreateCompanionBuilder,
      $$WorkoutTableTableUpdateCompanionBuilder,
      (WorkoutTableData, $$WorkoutTableTableReferences),
      WorkoutTableData,
      PrefetchHooks Function({
        bool workoutExerciseTableRefs,
        bool workoutPlanWorkoutTableRefs,
      })
    >;
typedef $$WorkoutExerciseTableTableCreateCompanionBuilder =
    WorkoutExerciseTableCompanion Function({
      Value<int> id,
      required int workoutId,
      required int exerciseId,
      required int orderPosition,
      Value<String?> notes,
    });
typedef $$WorkoutExerciseTableTableUpdateCompanionBuilder =
    WorkoutExerciseTableCompanion Function({
      Value<int> id,
      Value<int> workoutId,
      Value<int> exerciseId,
      Value<int> orderPosition,
      Value<String?> notes,
    });

final class $$WorkoutExerciseTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WorkoutExerciseTableTable,
          WorkoutExerciseTableData
        > {
  $$WorkoutExerciseTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutTableTable _workoutIdTable(_$AppDatabase db) =>
      db.workoutTable.createAlias(
        $_aliasNameGenerator(
          db.workoutExerciseTable.workoutId,
          db.workoutTable.id,
        ),
      );

  $$WorkoutTableTableProcessedTableManager get workoutId {
    final $_column = $_itemColumn<int>('workout_id')!;

    final manager = $$WorkoutTableTableTableManager(
      $_db,
      $_db.workoutTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ExerciseTableTable _exerciseIdTable(_$AppDatabase db) =>
      db.exerciseTable.createAlias(
        $_aliasNameGenerator(
          db.workoutExerciseTable.exerciseId,
          db.exerciseTable.id,
        ),
      );

  $$ExerciseTableTableProcessedTableManager get exerciseId {
    final $_column = $_itemColumn<int>('exercise_id')!;

    final manager = $$ExerciseTableTableTableManager(
      $_db,
      $_db.exerciseTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$WorkoutSetTableTable, List<WorkoutSetTableData>>
  _workoutSetTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workoutSetTable,
    aliasName: $_aliasNameGenerator(
      db.workoutExerciseTable.id,
      db.workoutSetTable.exerciseInstanceId,
    ),
  );

  $$WorkoutSetTableTableProcessedTableManager get workoutSetTableRefs {
    final manager = $$WorkoutSetTableTableTableManager(
      $_db,
      $_db.workoutSetTable,
    ).filter(
      (f) => f.exerciseInstanceId.id.sqlEquals($_itemColumn<int>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(
      _workoutSetTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutExerciseTableTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutExerciseTableTable> {
  $$WorkoutExerciseTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderPosition => $composableBuilder(
    column: $table.orderPosition,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutTableTableFilterComposer get workoutId {
    final $$WorkoutTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workoutTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutTableTableFilterComposer(
            $db: $db,
            $table: $db.workoutTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExerciseTableTableFilterComposer get exerciseId {
    final $$ExerciseTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exerciseTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciseTableTableFilterComposer(
            $db: $db,
            $table: $db.exerciseTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> workoutSetTableRefs(
    Expression<bool> Function($$WorkoutSetTableTableFilterComposer f) f,
  ) {
    final $$WorkoutSetTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSetTable,
      getReferencedColumn: (t) => t.exerciseInstanceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetTableTableFilterComposer(
            $db: $db,
            $table: $db.workoutSetTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutExerciseTableTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutExerciseTableTable> {
  $$WorkoutExerciseTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderPosition => $composableBuilder(
    column: $table.orderPosition,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutTableTableOrderingComposer get workoutId {
    final $$WorkoutTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workoutTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutTableTableOrderingComposer(
            $db: $db,
            $table: $db.workoutTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExerciseTableTableOrderingComposer get exerciseId {
    final $$ExerciseTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exerciseTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciseTableTableOrderingComposer(
            $db: $db,
            $table: $db.exerciseTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutExerciseTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutExerciseTableTable> {
  $$WorkoutExerciseTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get orderPosition => $composableBuilder(
    column: $table.orderPosition,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$WorkoutTableTableAnnotationComposer get workoutId {
    final $$WorkoutTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workoutTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutTableTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ExerciseTableTableAnnotationComposer get exerciseId {
    final $$ExerciseTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseId,
      referencedTable: $db.exerciseTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExerciseTableTableAnnotationComposer(
            $db: $db,
            $table: $db.exerciseTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> workoutSetTableRefs<T extends Object>(
    Expression<T> Function($$WorkoutSetTableTableAnnotationComposer a) f,
  ) {
    final $$WorkoutSetTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workoutSetTable,
      getReferencedColumn: (t) => t.exerciseInstanceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutSetTableTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutSetTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WorkoutExerciseTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutExerciseTableTable,
          WorkoutExerciseTableData,
          $$WorkoutExerciseTableTableFilterComposer,
          $$WorkoutExerciseTableTableOrderingComposer,
          $$WorkoutExerciseTableTableAnnotationComposer,
          $$WorkoutExerciseTableTableCreateCompanionBuilder,
          $$WorkoutExerciseTableTableUpdateCompanionBuilder,
          (WorkoutExerciseTableData, $$WorkoutExerciseTableTableReferences),
          WorkoutExerciseTableData,
          PrefetchHooks Function({
            bool workoutId,
            bool exerciseId,
            bool workoutSetTableRefs,
          })
        > {
  $$WorkoutExerciseTableTableTableManager(
    _$AppDatabase db,
    $WorkoutExerciseTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$WorkoutExerciseTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$WorkoutExerciseTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$WorkoutExerciseTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> workoutId = const Value.absent(),
                Value<int> exerciseId = const Value.absent(),
                Value<int> orderPosition = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => WorkoutExerciseTableCompanion(
                id: id,
                workoutId: workoutId,
                exerciseId: exerciseId,
                orderPosition: orderPosition,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int workoutId,
                required int exerciseId,
                required int orderPosition,
                Value<String?> notes = const Value.absent(),
              }) => WorkoutExerciseTableCompanion.insert(
                id: id,
                workoutId: workoutId,
                exerciseId: exerciseId,
                orderPosition: orderPosition,
                notes: notes,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$WorkoutExerciseTableTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({
            workoutId = false,
            exerciseId = false,
            workoutSetTableRefs = false,
          }) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (workoutSetTableRefs) db.workoutSetTable,
              ],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (workoutId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.workoutId,
                            referencedTable:
                                $$WorkoutExerciseTableTableReferences
                                    ._workoutIdTable(db),
                            referencedColumn:
                                $$WorkoutExerciseTableTableReferences
                                    ._workoutIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (exerciseId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.exerciseId,
                            referencedTable:
                                $$WorkoutExerciseTableTableReferences
                                    ._exerciseIdTable(db),
                            referencedColumn:
                                $$WorkoutExerciseTableTableReferences
                                    ._exerciseIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workoutSetTableRefs)
                    await $_getPrefetchedData<
                      WorkoutExerciseTableData,
                      $WorkoutExerciseTableTable,
                      WorkoutSetTableData
                    >(
                      currentTable: table,
                      referencedTable: $$WorkoutExerciseTableTableReferences
                          ._workoutSetTableRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$WorkoutExerciseTableTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutSetTableRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) => referencedItems.where(
                            (e) => e.exerciseInstanceId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutExerciseTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutExerciseTableTable,
      WorkoutExerciseTableData,
      $$WorkoutExerciseTableTableFilterComposer,
      $$WorkoutExerciseTableTableOrderingComposer,
      $$WorkoutExerciseTableTableAnnotationComposer,
      $$WorkoutExerciseTableTableCreateCompanionBuilder,
      $$WorkoutExerciseTableTableUpdateCompanionBuilder,
      (WorkoutExerciseTableData, $$WorkoutExerciseTableTableReferences),
      WorkoutExerciseTableData,
      PrefetchHooks Function({
        bool workoutId,
        bool exerciseId,
        bool workoutSetTableRefs,
      })
    >;
typedef $$WorkoutSetTableTableCreateCompanionBuilder =
    WorkoutSetTableCompanion Function({
      Value<int> id,
      required int exerciseInstanceId,
      required int setNumber,
      Value<int?> reps,
      Value<double?> weight,
      Value<String?> weightUnit,
      Value<int?> durationSeconds,
      Value<bool> isCompleted,
      Value<String?> notes,
    });
typedef $$WorkoutSetTableTableUpdateCompanionBuilder =
    WorkoutSetTableCompanion Function({
      Value<int> id,
      Value<int> exerciseInstanceId,
      Value<int> setNumber,
      Value<int?> reps,
      Value<double?> weight,
      Value<String?> weightUnit,
      Value<int?> durationSeconds,
      Value<bool> isCompleted,
      Value<String?> notes,
    });

final class $$WorkoutSetTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WorkoutSetTableTable,
          WorkoutSetTableData
        > {
  $$WorkoutSetTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutExerciseTableTable _exerciseInstanceIdTable(
    _$AppDatabase db,
  ) => db.workoutExerciseTable.createAlias(
    $_aliasNameGenerator(
      db.workoutSetTable.exerciseInstanceId,
      db.workoutExerciseTable.id,
    ),
  );

  $$WorkoutExerciseTableTableProcessedTableManager get exerciseInstanceId {
    final $_column = $_itemColumn<int>('exercise_instance_id')!;

    final manager = $$WorkoutExerciseTableTableTableManager(
      $_db,
      $_db.workoutExerciseTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_exerciseInstanceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkoutSetTableTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSetTableTable> {
  $$WorkoutSetTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get setNumber => $composableBuilder(
    column: $table.setNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weightUnit => $composableBuilder(
    column: $table.weightUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutExerciseTableTableFilterComposer get exerciseInstanceId {
    final $$WorkoutExerciseTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.exerciseInstanceId,
      referencedTable: $db.workoutExerciseTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutExerciseTableTableFilterComposer(
            $db: $db,
            $table: $db.workoutExerciseTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutSetTableTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSetTableTable> {
  $$WorkoutSetTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get setNumber => $composableBuilder(
    column: $table.setNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weightUnit => $composableBuilder(
    column: $table.weightUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutExerciseTableTableOrderingComposer get exerciseInstanceId {
    final $$WorkoutExerciseTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.exerciseInstanceId,
          referencedTable: $db.workoutExerciseTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutExerciseTableTableOrderingComposer(
                $db: $db,
                $table: $db.workoutExerciseTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$WorkoutSetTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSetTableTable> {
  $$WorkoutSetTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get setNumber =>
      $composableBuilder(column: $table.setNumber, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<String> get weightUnit => $composableBuilder(
    column: $table.weightUnit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$WorkoutExerciseTableTableAnnotationComposer get exerciseInstanceId {
    final $$WorkoutExerciseTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.exerciseInstanceId,
          referencedTable: $db.workoutExerciseTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutExerciseTableTableAnnotationComposer(
                $db: $db,
                $table: $db.workoutExerciseTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$WorkoutSetTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSetTableTable,
          WorkoutSetTableData,
          $$WorkoutSetTableTableFilterComposer,
          $$WorkoutSetTableTableOrderingComposer,
          $$WorkoutSetTableTableAnnotationComposer,
          $$WorkoutSetTableTableCreateCompanionBuilder,
          $$WorkoutSetTableTableUpdateCompanionBuilder,
          (WorkoutSetTableData, $$WorkoutSetTableTableReferences),
          WorkoutSetTableData,
          PrefetchHooks Function({bool exerciseInstanceId})
        > {
  $$WorkoutSetTableTableTableManager(
    _$AppDatabase db,
    $WorkoutSetTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$WorkoutSetTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$WorkoutSetTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$WorkoutSetTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> exerciseInstanceId = const Value.absent(),
                Value<int> setNumber = const Value.absent(),
                Value<int?> reps = const Value.absent(),
                Value<double?> weight = const Value.absent(),
                Value<String?> weightUnit = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => WorkoutSetTableCompanion(
                id: id,
                exerciseInstanceId: exerciseInstanceId,
                setNumber: setNumber,
                reps: reps,
                weight: weight,
                weightUnit: weightUnit,
                durationSeconds: durationSeconds,
                isCompleted: isCompleted,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int exerciseInstanceId,
                required int setNumber,
                Value<int?> reps = const Value.absent(),
                Value<double?> weight = const Value.absent(),
                Value<String?> weightUnit = const Value.absent(),
                Value<int?> durationSeconds = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => WorkoutSetTableCompanion.insert(
                id: id,
                exerciseInstanceId: exerciseInstanceId,
                setNumber: setNumber,
                reps: reps,
                weight: weight,
                weightUnit: weightUnit,
                durationSeconds: durationSeconds,
                isCompleted: isCompleted,
                notes: notes,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$WorkoutSetTableTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({exerciseInstanceId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (exerciseInstanceId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.exerciseInstanceId,
                            referencedTable: $$WorkoutSetTableTableReferences
                                ._exerciseInstanceIdTable(db),
                            referencedColumn:
                                $$WorkoutSetTableTableReferences
                                    ._exerciseInstanceIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutSetTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSetTableTable,
      WorkoutSetTableData,
      $$WorkoutSetTableTableFilterComposer,
      $$WorkoutSetTableTableOrderingComposer,
      $$WorkoutSetTableTableAnnotationComposer,
      $$WorkoutSetTableTableCreateCompanionBuilder,
      $$WorkoutSetTableTableUpdateCompanionBuilder,
      (WorkoutSetTableData, $$WorkoutSetTableTableReferences),
      WorkoutSetTableData,
      PrefetchHooks Function({bool exerciseInstanceId})
    >;
typedef $$WorkoutPlanTableTableCreateCompanionBuilder =
    WorkoutPlanTableCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> description,
      required DateTime startDate,
      Value<DateTime?> endDate,
      Value<bool> isActive,
    });
typedef $$WorkoutPlanTableTableUpdateCompanionBuilder =
    WorkoutPlanTableCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> description,
      Value<DateTime> startDate,
      Value<DateTime?> endDate,
      Value<bool> isActive,
    });

final class $$WorkoutPlanTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WorkoutPlanTableTable,
          WorkoutPlanTableData
        > {
  $$WorkoutPlanTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $WorkoutPlanWorkoutTableTable,
    List<WorkoutPlanWorkoutTableData>
  >
  _workoutPlanWorkoutTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.workoutPlanWorkoutTable,
        aliasName: $_aliasNameGenerator(
          db.workoutPlanTable.id,
          db.workoutPlanWorkoutTable.planId,
        ),
      );

  $$WorkoutPlanWorkoutTableTableProcessedTableManager
  get workoutPlanWorkoutTableRefs {
    final manager = $$WorkoutPlanWorkoutTableTableTableManager(
      $_db,
      $_db.workoutPlanWorkoutTable,
    ).filter((f) => f.planId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workoutPlanWorkoutTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WorkoutPlanTableTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutPlanTableTable> {
  $$WorkoutPlanTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> workoutPlanWorkoutTableRefs(
    Expression<bool> Function($$WorkoutPlanWorkoutTableTableFilterComposer f) f,
  ) {
    final $$WorkoutPlanWorkoutTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workoutPlanWorkoutTable,
          getReferencedColumn: (t) => t.planId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutPlanWorkoutTableTableFilterComposer(
                $db: $db,
                $table: $db.workoutPlanWorkoutTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WorkoutPlanTableTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutPlanTableTable> {
  $$WorkoutPlanTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutPlanTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutPlanTableTable> {
  $$WorkoutPlanTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> workoutPlanWorkoutTableRefs<T extends Object>(
    Expression<T> Function($$WorkoutPlanWorkoutTableTableAnnotationComposer a)
    f,
  ) {
    final $$WorkoutPlanWorkoutTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.workoutPlanWorkoutTable,
          getReferencedColumn: (t) => t.planId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WorkoutPlanWorkoutTableTableAnnotationComposer(
                $db: $db,
                $table: $db.workoutPlanWorkoutTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$WorkoutPlanTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutPlanTableTable,
          WorkoutPlanTableData,
          $$WorkoutPlanTableTableFilterComposer,
          $$WorkoutPlanTableTableOrderingComposer,
          $$WorkoutPlanTableTableAnnotationComposer,
          $$WorkoutPlanTableTableCreateCompanionBuilder,
          $$WorkoutPlanTableTableUpdateCompanionBuilder,
          (WorkoutPlanTableData, $$WorkoutPlanTableTableReferences),
          WorkoutPlanTableData,
          PrefetchHooks Function({bool workoutPlanWorkoutTableRefs})
        > {
  $$WorkoutPlanTableTableTableManager(
    _$AppDatabase db,
    $WorkoutPlanTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () =>
                  $$WorkoutPlanTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$WorkoutPlanTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$WorkoutPlanTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => WorkoutPlanTableCompanion(
                id: id,
                name: name,
                description: description,
                startDate: startDate,
                endDate: endDate,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> description = const Value.absent(),
                required DateTime startDate,
                Value<DateTime?> endDate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => WorkoutPlanTableCompanion.insert(
                id: id,
                name: name,
                description: description,
                startDate: startDate,
                endDate: endDate,
                isActive: isActive,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$WorkoutPlanTableTableReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({workoutPlanWorkoutTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (workoutPlanWorkoutTableRefs) db.workoutPlanWorkoutTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (workoutPlanWorkoutTableRefs)
                    await $_getPrefetchedData<
                      WorkoutPlanTableData,
                      $WorkoutPlanTableTable,
                      WorkoutPlanWorkoutTableData
                    >(
                      currentTable: table,
                      referencedTable: $$WorkoutPlanTableTableReferences
                          ._workoutPlanWorkoutTableRefsTable(db),
                      managerFromTypedResult:
                          (p0) =>
                              $$WorkoutPlanTableTableReferences(
                                db,
                                table,
                                p0,
                              ).workoutPlanWorkoutTableRefs,
                      referencedItemsForCurrentItem:
                          (item, referencedItems) =>
                              referencedItems.where((e) => e.planId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutPlanTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutPlanTableTable,
      WorkoutPlanTableData,
      $$WorkoutPlanTableTableFilterComposer,
      $$WorkoutPlanTableTableOrderingComposer,
      $$WorkoutPlanTableTableAnnotationComposer,
      $$WorkoutPlanTableTableCreateCompanionBuilder,
      $$WorkoutPlanTableTableUpdateCompanionBuilder,
      (WorkoutPlanTableData, $$WorkoutPlanTableTableReferences),
      WorkoutPlanTableData,
      PrefetchHooks Function({bool workoutPlanWorkoutTableRefs})
    >;
typedef $$WorkoutPlanWorkoutTableTableCreateCompanionBuilder =
    WorkoutPlanWorkoutTableCompanion Function({
      Value<int> id,
      required int planId,
      required int workoutId,
    });
typedef $$WorkoutPlanWorkoutTableTableUpdateCompanionBuilder =
    WorkoutPlanWorkoutTableCompanion Function({
      Value<int> id,
      Value<int> planId,
      Value<int> workoutId,
    });

final class $$WorkoutPlanWorkoutTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WorkoutPlanWorkoutTableTable,
          WorkoutPlanWorkoutTableData
        > {
  $$WorkoutPlanWorkoutTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WorkoutPlanTableTable _planIdTable(_$AppDatabase db) =>
      db.workoutPlanTable.createAlias(
        $_aliasNameGenerator(
          db.workoutPlanWorkoutTable.planId,
          db.workoutPlanTable.id,
        ),
      );

  $$WorkoutPlanTableTableProcessedTableManager get planId {
    final $_column = $_itemColumn<int>('plan_id')!;

    final manager = $$WorkoutPlanTableTableTableManager(
      $_db,
      $_db.workoutPlanTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $WorkoutTableTable _workoutIdTable(_$AppDatabase db) =>
      db.workoutTable.createAlias(
        $_aliasNameGenerator(
          db.workoutPlanWorkoutTable.workoutId,
          db.workoutTable.id,
        ),
      );

  $$WorkoutTableTableProcessedTableManager get workoutId {
    final $_column = $_itemColumn<int>('workout_id')!;

    final manager = $$WorkoutTableTableTableManager(
      $_db,
      $_db.workoutTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_workoutIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WorkoutPlanWorkoutTableTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutPlanWorkoutTableTable> {
  $$WorkoutPlanWorkoutTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  $$WorkoutPlanTableTableFilterComposer get planId {
    final $$WorkoutPlanTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.workoutPlanTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutPlanTableTableFilterComposer(
            $db: $db,
            $table: $db.workoutPlanTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorkoutTableTableFilterComposer get workoutId {
    final $$WorkoutTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workoutTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutTableTableFilterComposer(
            $db: $db,
            $table: $db.workoutTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutPlanWorkoutTableTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutPlanWorkoutTableTable> {
  $$WorkoutPlanWorkoutTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  $$WorkoutPlanTableTableOrderingComposer get planId {
    final $$WorkoutPlanTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.workoutPlanTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutPlanTableTableOrderingComposer(
            $db: $db,
            $table: $db.workoutPlanTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorkoutTableTableOrderingComposer get workoutId {
    final $$WorkoutTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workoutTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutTableTableOrderingComposer(
            $db: $db,
            $table: $db.workoutTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutPlanWorkoutTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutPlanWorkoutTableTable> {
  $$WorkoutPlanWorkoutTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  $$WorkoutPlanTableTableAnnotationComposer get planId {
    final $$WorkoutPlanTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planId,
      referencedTable: $db.workoutPlanTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutPlanTableTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutPlanTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$WorkoutTableTableAnnotationComposer get workoutId {
    final $$WorkoutTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.workoutId,
      referencedTable: $db.workoutTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkoutTableTableAnnotationComposer(
            $db: $db,
            $table: $db.workoutTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WorkoutPlanWorkoutTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutPlanWorkoutTableTable,
          WorkoutPlanWorkoutTableData,
          $$WorkoutPlanWorkoutTableTableFilterComposer,
          $$WorkoutPlanWorkoutTableTableOrderingComposer,
          $$WorkoutPlanWorkoutTableTableAnnotationComposer,
          $$WorkoutPlanWorkoutTableTableCreateCompanionBuilder,
          $$WorkoutPlanWorkoutTableTableUpdateCompanionBuilder,
          (
            WorkoutPlanWorkoutTableData,
            $$WorkoutPlanWorkoutTableTableReferences,
          ),
          WorkoutPlanWorkoutTableData,
          PrefetchHooks Function({bool planId, bool workoutId})
        > {
  $$WorkoutPlanWorkoutTableTableTableManager(
    _$AppDatabase db,
    $WorkoutPlanWorkoutTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$WorkoutPlanWorkoutTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer:
              () => $$WorkoutPlanWorkoutTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer:
              () => $$WorkoutPlanWorkoutTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> planId = const Value.absent(),
                Value<int> workoutId = const Value.absent(),
              }) => WorkoutPlanWorkoutTableCompanion(
                id: id,
                planId: planId,
                workoutId: workoutId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int planId,
                required int workoutId,
              }) => WorkoutPlanWorkoutTableCompanion.insert(
                id: id,
                planId: planId,
                workoutId: workoutId,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          $$WorkoutPlanWorkoutTableTableReferences(
                            db,
                            table,
                            e,
                          ),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: ({planId = false, workoutId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                T extends TableManagerState<
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic,
                  dynamic
                >
              >(state) {
                if (planId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.planId,
                            referencedTable:
                                $$WorkoutPlanWorkoutTableTableReferences
                                    ._planIdTable(db),
                            referencedColumn:
                                $$WorkoutPlanWorkoutTableTableReferences
                                    ._planIdTable(db)
                                    .id,
                          )
                          as T;
                }
                if (workoutId) {
                  state =
                      state.withJoin(
                            currentTable: table,
                            currentColumn: table.workoutId,
                            referencedTable:
                                $$WorkoutPlanWorkoutTableTableReferences
                                    ._workoutIdTable(db),
                            referencedColumn:
                                $$WorkoutPlanWorkoutTableTableReferences
                                    ._workoutIdTable(db)
                                    .id,
                          )
                          as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WorkoutPlanWorkoutTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutPlanWorkoutTableTable,
      WorkoutPlanWorkoutTableData,
      $$WorkoutPlanWorkoutTableTableFilterComposer,
      $$WorkoutPlanWorkoutTableTableOrderingComposer,
      $$WorkoutPlanWorkoutTableTableAnnotationComposer,
      $$WorkoutPlanWorkoutTableTableCreateCompanionBuilder,
      $$WorkoutPlanWorkoutTableTableUpdateCompanionBuilder,
      (WorkoutPlanWorkoutTableData, $$WorkoutPlanWorkoutTableTableReferences),
      WorkoutPlanWorkoutTableData,
      PrefetchHooks Function({bool planId, bool workoutId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FoodItemTableTableManager get foodItem =>
      $$FoodItemTableTableManager(_db, _db.foodItem);
  $$UserSettingsTableTableManager get userSettings =>
      $$UserSettingsTableTableManager(_db, _db.userSettings);
  $$MealTableTableTableManager get mealTable =>
      $$MealTableTableTableManager(_db, _db.mealTable);
  $$MealFoodTableTableTableManager get mealFoodTable =>
      $$MealFoodTableTableTableManager(_db, _db.mealFoodTable);
  $$SearchCacheTableTableTableManager get searchCacheTable =>
      $$SearchCacheTableTableTableManager(_db, _db.searchCacheTable);
  $$WeightRecordTableTableManager get weightRecord =>
      $$WeightRecordTableTableManager(_db, _db.weightRecord);
  $$ExerciseTableTableTableManager get exerciseTable =>
      $$ExerciseTableTableTableManager(_db, _db.exerciseTable);
  $$WorkoutTableTableTableManager get workoutTable =>
      $$WorkoutTableTableTableManager(_db, _db.workoutTable);
  $$WorkoutExerciseTableTableTableManager get workoutExerciseTable =>
      $$WorkoutExerciseTableTableTableManager(_db, _db.workoutExerciseTable);
  $$WorkoutSetTableTableTableManager get workoutSetTable =>
      $$WorkoutSetTableTableTableManager(_db, _db.workoutSetTable);
  $$WorkoutPlanTableTableTableManager get workoutPlanTable =>
      $$WorkoutPlanTableTableTableManager(_db, _db.workoutPlanTable);
  $$WorkoutPlanWorkoutTableTableTableManager get workoutPlanWorkoutTable =>
      $$WorkoutPlanWorkoutTableTableTableManager(
        _db,
        _db.workoutPlanWorkoutTable,
      );
}

mixin _$FoodItemDaoMixin on DatabaseAccessor<AppDatabase> {
  $FoodItemTable get foodItem => attachedDatabase.foodItem;
}
mixin _$UserSettingsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UserSettingsTable get userSettings => attachedDatabase.userSettings;
}
mixin _$MealDaoMixin on DatabaseAccessor<AppDatabase> {
  $MealTableTable get mealTable => attachedDatabase.mealTable;
  $FoodItemTable get foodItem => attachedDatabase.foodItem;
  $MealFoodTableTable get mealFoodTable => attachedDatabase.mealFoodTable;
}
mixin _$SearchCacheDaoMixin on DatabaseAccessor<AppDatabase> {
  $SearchCacheTableTable get searchCacheTable =>
      attachedDatabase.searchCacheTable;
}
mixin _$WeightRecordDaoMixin on DatabaseAccessor<AppDatabase> {
  $WeightRecordTable get weightRecord => attachedDatabase.weightRecord;
}
mixin _$ExerciseDaoMixin on DatabaseAccessor<AppDatabase> {
  $ExerciseTableTable get exerciseTable => attachedDatabase.exerciseTable;
}
mixin _$WorkoutDaoMixin on DatabaseAccessor<AppDatabase> {
  $WorkoutTableTable get workoutTable => attachedDatabase.workoutTable;
  $ExerciseTableTable get exerciseTable => attachedDatabase.exerciseTable;
  $WorkoutExerciseTableTable get workoutExerciseTable =>
      attachedDatabase.workoutExerciseTable;
  $WorkoutSetTableTable get workoutSetTable => attachedDatabase.workoutSetTable;
}
mixin _$WorkoutPlanDaoMixin on DatabaseAccessor<AppDatabase> {
  $WorkoutPlanTableTable get workoutPlanTable =>
      attachedDatabase.workoutPlanTable;
  $WorkoutTableTable get workoutTable => attachedDatabase.workoutTable;
  $WorkoutPlanWorkoutTableTable get workoutPlanWorkoutTable =>
      attachedDatabase.workoutPlanWorkoutTable;
}
