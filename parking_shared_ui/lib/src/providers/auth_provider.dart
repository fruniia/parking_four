import 'package:flutter/material.dart';
import 'package:parking_shared_logic/parking_shared_logic.dart';

class AuthProvider extends ChangeNotifier {
  UserAuthStatus _status = UserAuthStatus.notAuthenticated;
  UserAuthStatus get status => _status;

  Person? _currentUser;
  Person? get currentUser => _currentUser;
  final List<Person> _persons = [];
  List<Person> get persons => _persons;

  Future<List<Person>> loadPersons() async {
    if (_persons.isNotEmpty) return _persons;

    try {
      _persons.clear();
      final persons = await PersonRepository().getAll();
      _persons.addAll(persons);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load persons.');
    }
    return _persons;
  }

  Future<void> login(String ssn) async {
    if (_status == UserAuthStatus.inProgress) return;

    _status = UserAuthStatus.inProgress;
    notifyListeners();

    try {
      var persons = await loadPersons();
      if (persons.isEmpty) {
        _resetAuthStatus();
        notifyListeners();
        throw 'No users registrered';
      }

      var existingPerson = persons.firstWhere(
          (person) => person.socialSecNumber == ssn,
          orElse: () => Person(id: '', name: 'Unknown', socialSecNumber: ''));

      if (existingPerson.socialSecNumber.isEmpty) {
        _resetAuthStatus();
        notifyListeners();
        throw 'User does not exist with provided SSN';
      }

      _currentUser = existingPerson;
      _status = UserAuthStatus.authenticated;
      notifyListeners();
    } catch (e) {
      _resetAuthStatus();
      notifyListeners();
      throw 'Login failed.\n$e';
    }
  }

  void _updateAuthStatus() {
    _status = _currentUser == null
        ? UserAuthStatus.notAuthenticated
        : UserAuthStatus.authenticated;
  }

  void _resetAuthStatus() {
    _currentUser = null;
    _updateAuthStatus();
  }

  void logout() {
    if (_status == UserAuthStatus.notAuthenticated) return;

    _currentUser = null;
    _updateAuthStatus();
  }

  Future<void> addUser(Person person) async {
    try {
      await PersonRepository().add(person);
      await loadPersons();
      _currentUser = person;
      _updateAuthStatus();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add person.');
    }
  }

  Future<void> register(String ssn, String name) async {
    if (_status == UserAuthStatus.inProgress) return;

    _status = UserAuthStatus.inProgress;
    notifyListeners();

    try {
      if (!isValidLuhn(ssn)) {
        throw 'Invalid SSN. Please use YYYYMMDDXXXX';
      }
      var persons = await loadPersons();

      if (persons.any((person) => person.socialSecNumber == ssn)) {
        throw 'SSN already registered';
      }

      Person newPerson = Person.withUUID(name: name, socialSecNumber: ssn);
      _persons.add(newPerson);
      await addUser(newPerson);

      await authenticateAfterRegistration(ssn);
      notifyListeners();
    } catch (e) {
      _resetAuthStatus();
      notifyListeners();
      throw 'Registrations failed:\n$e';
    }
  }

  Future<void> authenticateAfterRegistration(String ssn) async {
    try {
      await login(ssn);
    } catch (e) {
      throw 'Authentication failed after registration: $e';
    }
  }
}
