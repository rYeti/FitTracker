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
  @override
  List<GeneratedColumn> get $columns => [id, dailyCalorieGoal];
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
  const UserSetting({required this.id, required this.dailyCalorieGoal});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['daily_calorie_goal'] = Variable<int>(dailyCalorieGoal);
    return map;
  }

  UserSettingsCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsCompanion(
      id: Value(id),
      dailyCalorieGoal: Value(dailyCalorieGoal),
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
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dailyCalorieGoal': serializer.toJson<int>(dailyCalorieGoal),
    };
  }

  UserSetting copyWith({int? id, int? dailyCalorieGoal}) => UserSetting(
    id: id ?? this.id,
    dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
  );
  UserSetting copyWithCompanion(UserSettingsCompanion data) {
    return UserSetting(
      id: data.id.present ? data.id.value : this.id,
      dailyCalorieGoal:
          data.dailyCalorieGoal.present
              ? data.dailyCalorieGoal.value
              : this.dailyCalorieGoal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSetting(')
          ..write('id: $id, ')
          ..write('dailyCalorieGoal: $dailyCalorieGoal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, dailyCalorieGoal);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSetting &&
          other.id == this.id &&
          other.dailyCalorieGoal == this.dailyCalorieGoal);
}

class UserSettingsCompanion extends UpdateCompanion<UserSetting> {
  final Value<int> id;
  final Value<int> dailyCalorieGoal;
  const UserSettingsCompanion({
    this.id = const Value.absent(),
    this.dailyCalorieGoal = const Value.absent(),
  });
  UserSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.dailyCalorieGoal = const Value.absent(),
  });
  static Insertable<UserSetting> custom({
    Expression<int>? id,
    Expression<int>? dailyCalorieGoal,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dailyCalorieGoal != null) 'daily_calorie_goal': dailyCalorieGoal,
    });
  }

  UserSettingsCompanion copyWith({
    Value<int>? id,
    Value<int>? dailyCalorieGoal,
  }) {
    return UserSettingsCompanion(
      id: id ?? this.id,
      dailyCalorieGoal: dailyCalorieGoal ?? this.dailyCalorieGoal,
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsCompanion(')
          ..write('id: $id, ')
          ..write('dailyCalorieGoal: $dailyCalorieGoal')
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FoodItemTable foodItem = $FoodItemTable(this);
  late final $UserSettingsTable userSettings = $UserSettingsTable(this);
  late final $MealTableTable mealTable = $MealTableTable(this);
  late final $MealFoodTableTable mealFoodTable = $MealFoodTableTable(this);
  late final FoodItemDao foodItemDao = FoodItemDao(this as AppDatabase);
  late final UserSettingsDao userSettingsDao = UserSettingsDao(
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
    });
typedef $$UserSettingsTableUpdateCompanionBuilder =
    UserSettingsCompanion Function({
      Value<int> id,
      Value<int> dailyCalorieGoal,
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
              }) => UserSettingsCompanion(
                id: id,
                dailyCalorieGoal: dailyCalorieGoal,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> dailyCalorieGoal = const Value.absent(),
              }) => UserSettingsCompanion.insert(
                id: id,
                dailyCalorieGoal: dailyCalorieGoal,
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
