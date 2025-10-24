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
}
