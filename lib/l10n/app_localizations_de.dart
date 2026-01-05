// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get male => 'Männlich';

  @override
  String get female => 'Weiblich';

  @override
  String get other => 'Andere';

  @override
  String get sedentary => 'Sitzend';

  @override
  String get lightlyActive => 'Leicht aktiv';

  @override
  String get moderatelyActive => 'Mäßig aktiv';

  @override
  String get veryActive => 'Sehr aktiv';

  @override
  String get extremelyActive => 'Extrem aktiv';

  @override
  String get weightLoss => 'Gewichtsverlust';

  @override
  String get muscleGain => 'Muskelaufbau';

  @override
  String get maintenance => 'Erhaltung';

  @override
  String get dashboard => 'Übersicht';

  @override
  String get food => 'Essen';

  @override
  String get gym => 'Fitnessstudio';

  @override
  String get progress => 'Fortschritt';

  @override
  String get settings => 'Einstellungen';

  @override
  String get age => 'Alter';

  @override
  String get heightCm => 'Größe (cm)';

  @override
  String get dailyCalorieGoal => 'Tägliches Kalorienziel';

  @override
  String get save => 'Speichern';

  @override
  String get saveCalorieGoal => 'Kalorienziel gespeichert';

  @override
  String addFood(Object category) {
    return '$category';
  }

  @override
  String get scanBarcode => 'Barcode scannen';

  @override
  String get nutritionProgress => 'Ernährungsfortschritt';

  @override
  String get foodDetails => 'Lebensmitteldetails';

  @override
  String searchFailed(Object error) {
    return 'Suche fehlgeschlagen: $error';
  }

  @override
  String get pleaseEnterValidAgeAndHeight =>
      'Bitte gültiges Alter und Größe eingeben';

  @override
  String get pleaseEnterValidNumber => 'Bitte eine gültige Zahl eingeben';

  @override
  String get calculatedAndSavedCalorieGoal =>
      'Kalorienziel berechnet und gespeichert';

  @override
  String failedToSaveProfile(Object error) {
    return 'Profil konnte nicht gespeichert werden: $error';
  }

  @override
  String failedToUpdateCalorieGoal(Object error) {
    return 'Kalorienziel konnte nicht aktualisiert werden: $error';
  }

  @override
  String failedToLoadData(Object error) {
    return 'Daten konnten nicht geladen werden: $error';
  }

  @override
  String get sex => 'Geschlecht';

  @override
  String get activity => 'Aktivität';

  @override
  String get goal => 'Ziel';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get addCustomFood => 'Eigenes Lebensmittel hinzufügen';

  @override
  String get foodName => 'Lebensmittelname';

  @override
  String get calories => 'Kalorien';

  @override
  String get protein => 'Protein (g)';

  @override
  String get carbs => 'Kohlenhydrate (g)';

  @override
  String get fat => 'Fett (g)';

  @override
  String get addedSuccessfully => 'erfolgreich hinzugefügt!';

  @override
  String get pleaseEnterAName => 'Bitte einen Namen eingeben';

  @override
  String get pleaseEnterCalories => 'Bitte Kalorien eingeben';

  @override
  String get foodTracker => 'Tracker';

  @override
  String get proteinLabel => 'Protein';

  @override
  String get carbsLabel => 'Kohlenhydrate';

  @override
  String get fatLabel => 'Fett';

  @override
  String get ok => 'OK';

  @override
  String get addFailed => 'Hinzufügen fehlgeschlagen';

  @override
  String get nutritionInformation => 'Nährwertinformationen';

  @override
  String get portionSize => 'Portionsgröße';

  @override
  String get quantityInGrams => 'Menge in Gramm';

  @override
  String get addToTodayLog => 'Zum heutigen Protokoll hinzufügen';

  @override
  String get mealCategory => 'Mahlzeitenkategorie';

  @override
  String get addToLog => 'Zum Protokoll hinzufügen';

  @override
  String get mealBreakfast => 'Frühstück';

  @override
  String get mealLunch => 'Mittagessen';

  @override
  String get mealDinner => 'Abendessen';

  @override
  String get mealSnacks => 'Snacks';

  @override
  String get searchForFood => 'Nach Lebensmitteln suchen';

  @override
  String get recentlyAdded => 'Kürzlich hinzugefügt';

  @override
  String addedToRecentFoods(Object name) {
    return '$name wurde zu den kürzlich hinzugefügten Lebensmitteln hinzugefügt';
  }

  @override
  String get noFoodAdded => 'Noch nichts hinzugefügt';

  @override
  String get calculateAndSave => 'Kalorienziel berechnet und gespeichert';

  @override
  String get workoutName => 'Workout Name';

  @override
  String get createWorkout => 'Training erstellen';

  @override
  String get workoutSavedSuccessfully => 'Training erfolgreich gespeichert';

  @override
  String get pleaseEnterWorkoutName =>
      'Bitte geben Sie einen Trainingsnamen ein';

  @override
  String get pleaseEnterAtLeastOneWorkoutDay =>
      'Bitte fügen Sie mindestens einen Trainingstag zum Zyklus hinzu';

  @override
  String get pleaseSelectStartDate => 'Bitte wählen Sie ein Startdatum';

  @override
  String dayRestDay(int day) {
    return 'Tag $day: Ruhetag';
  }

  @override
  String dayWorkout(int day, String workout) {
    return 'Tag $day: $workout';
  }

  @override
  String get noExercisesYet => 'Noch keine Übungen';

  @override
  String get addWorkout => 'Training hinzufügen';

  @override
  String get addRestDay => 'Ruhetag hinzufügen';

  @override
  String get workoutNameLabel => 'Trainingsname';

  @override
  String get add => 'Hinzufügen';

  @override
  String get selectStartDate => 'Startdatum wählen';

  @override
  String get back => 'Zurück';

  @override
  String get next => 'Weiter';

  @override
  String stepXofY(int current, int total) {
    return 'Schritt $current von $total';
  }

  @override
  String get noScheduledWorkouts => 'Keine geplanten Trainings';

  @override
  String get unknownWorkout => 'Unbekanntes Training';

  @override
  String get workouts => 'Trainings';

  @override
  String get seedWorkoutTemplates => 'Trainingsvorlagen laden (Debug)';

  @override
  String get seedingTemplates => 'Lade Vorlagen...';

  @override
  String seedingFailed(Object error) {
    return 'Laden fehlgeschlagen: $error';
  }

  @override
  String get createOrEditWorkouts => 'Trainings erstellen oder bearbeiten';

  @override
  String get newWorkout => 'Neues Training';

  @override
  String get viewWorkouts => 'Trainings ansehen';

  @override
  String minutesShort(int minutes) {
    return '$minutes Min';
  }

  @override
  String get noSetTemplates => 'Keine Sätze konfiguriert';

  @override
  String setTemplatesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Sätze',
      one: '1 Satz',
    );
    return '$_temp0';
  }

  @override
  String get copyToAll => 'Auf alle kopieren';

  @override
  String get repsHelperText => 'z.B. 8-12 oder 10';

  @override
  String get addSet => 'Satz hinzufügen';

  @override
  String get noSetsConfigured => 'Keine Sätze konfiguriert';

  @override
  String get sets => 'Sätze';

  @override
  String get reps => 'Wiederholungen';

  @override
  String get removeSet => 'Satz entfernen';

  @override
  String get setLabel => 'Set';

  @override
  String get previous => 'Vorheriges';

  @override
  String get kg => 'KG';

  @override
  String get weight => 'Gewicht';

  @override
  String get noExercisesForWorkout =>
      'Keine Übungen für dieses Training konfiguriert';

  @override
  String errorLoadingExercises(Object error) {
    return 'Fehler beim Laden der Übungen: $error';
  }

  @override
  String get target => 'Ziel';

  @override
  String get saveWorkout => 'Workout Speichern';

  @override
  String get workoutSaved => 'Training wurde gespeichert.';

  @override
  String get restDay => 'Ruhetag';

  @override
  String get editWorkout => 'Training bearbeiten';

  @override
  String get workoutUpdatedSuccessfully => 'Training erfolgreich aktualisiert';

  @override
  String saveFailed(Object error) {
    return 'Speichern fehlgeschlagen: $error';
  }

  @override
  String get addExercise => 'Übung hinzufügen';

  @override
  String editSet(int setNumber) {
    return 'Satz $setNumber bearbeiten';
  }

  @override
  String get noExercisesInWorkout => 'Keine Übungen in diesem Training';

  @override
  String get setsLabel => 'Sätze';

  @override
  String get noSetsFound => 'Keine Sätze für diese Übung gefunden';

  @override
  String get exerciseName => 'Übungsname';

  @override
  String get description => 'Beschreibung';

  @override
  String get duration => 'Dauer';

  @override
  String get difficulty => 'Schwierigkeit';

  @override
  String get repsLabel => 'Wiederholungen';

  @override
  String get weightLabel => 'Gewicht';

  @override
  String get unit => 'Einheit';

  @override
  String get delete => 'Löschen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get addButton => 'Hinzufügen';

  @override
  String get saveButton => 'Speichern';

  @override
  String get exercises => 'Übungen';
}
