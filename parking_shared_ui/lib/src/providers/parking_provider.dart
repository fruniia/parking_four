import 'package:flutter/material.dart';
import 'package:parking_shared_logic/parking_shared_logic.dart';
import 'package:parking_shared_ui/parking_shared_ui.dart';

class ParkingProvider extends ChangeNotifier {
  final ParkingRepository parkingRepository;
  List<Parking> _parkings = [];

  List<Parking> _completedParkingSessions = [];
  List<Parking> _activeParkingSessions = [];

  bool _isLoading = false;
  bool _activeSessionsLoaded = false;
  bool _completedSessionsLoaded = false;

  bool isAdmin = false;

  List<Parking> get parkings => _parkings;
  List<Parking> get activeParkingSessions => _activeParkingSessions;
  List<Parking> get completedParkingSessions => _completedParkingSessions;
  bool get isLoading => _isLoading;

  ParkingProvider({required this.parkingRepository, this.isAdmin = false});

  Future<List<Parking>> loadParkings() async {
    if (_parkings.isNotEmpty) return _parkings;

    try {
      _parkings.clear();
      final parkings = await ParkingRepository().getAll();
      _parkings.addAll(parkings);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to load vehicles.');
    }
    return _parkings;
  }

  Future<List<Parking>> loadActiveParkingSessions(
      AuthProvider? authProvider) async {
    if (authProvider?.currentUser == null && !isAdmin) {
      throw Exception('User is not authenticated');
    }

    if (_activeSessionsLoaded) return _activeParkingSessions;

    _activeParkingSessions.clear();
    _activeSessionsLoaded = false;

    try {
      final allParkings = await loadParkings();

      if (isAdmin) {
        // get all active parking sessions
        _activeParkingSessions =
            allParkings.where((parking) => parking.stop == null).toList();
      } else {
        // get users active parking sessions
        _activeParkingSessions.addAll(
          allParkings
              .where((parking) =>
                  parking.stop == null &&
                  parking.vehicle.owner.id == authProvider?.currentUser?.id)
              .toList(),
        );
      }

      _activeSessionsLoaded = true;

      notifyListeners();
    } catch (e) {
      _activeParkingSessions = [];
      throw Exception('Could not load active parking sessions');
    }
    return _activeParkingSessions;
  }

  Future<List<Parking>> loadCompletedParkingSessions(
      AuthProvider? authProvider) async {
    if (authProvider?.currentUser == null && !isAdmin) {
      throw Exception('User is not authenticated');
    }

    if (_completedSessionsLoaded) return _completedParkingSessions;

    _completedParkingSessions.clear();
    _completedSessionsLoaded = false;

    try {
      final allParkings = await loadParkings();

      if (isAdmin) {
        _completedParkingSessions.addAll(
            allParkings.where((parking) => parking.stop != null).toList());
      } else {
        _completedParkingSessions.addAll(
          allParkings
              .where((parking) =>
                  parking.stop != null &&
                  parking.vehicle.owner.id == authProvider?.currentUser!.id)
              .toList(),
        );
      }
      _completedSessionsLoaded = true;
      notifyListeners();
    } catch (e) {
      _completedParkingSessions = [];
      throw Exception('Could not load completed parking sessions');
    }
    return _completedParkingSessions;
  }

  Future<void> loadActiveAndCompletedSessions(AuthProvider authProvider) async {
    try {
      _isLoading = true;
      if (authProvider.currentUser != null) {
        if (!_activeSessionsLoaded) {
          await loadActiveParkingSessions(authProvider);
        }
        if (!_completedSessionsLoaded) {
          await loadCompletedParkingSessions(authProvider);
        }
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> startParkingSession(Vehicle vehicle, ParkingSpace parkingSpace,
      AuthProvider authProvider) async {
    if (authProvider.currentUser == null) {
      throw Exception('User is not authenticated');
    }

    if (vehicle.owner.id != authProvider.currentUser?.id) {
      throw Exception('You are not authorized to park this vehicle');
    }

    try {
      final parking =
          Parking.withUUID(vehicle: vehicle, parkingSpace: parkingSpace);
      await ParkingRepository().add(parking);
      _activeParkingSessions.add(parking);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to start parking: $e');
    }
  }

  Future<void> stopParkingSession(
      String parkingId, AuthProvider authProvider) async {
    if (authProvider.currentUser == null) {
      throw Exception('User is not authenticated');
    }

    try {
      final parking = _activeParkingSessions.firstWhere(
        (p) => p.id == parkingId,
        orElse: () => throw Exception('Parking session not found'),
      );

      if (parking.vehicle.owner.id != authProvider.currentUser!.id) {
        throw Exception('You are not authorized to stop this parking');
      }

      parking.updateStop(DateTime.now());
      await ParkingRepository().update(parkingId, parking);

      _activeParkingSessions.remove(parking);
      _completedParkingSessions.add(parking);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to stop parking: $e');
    }
  }

  List<Map<String, dynamic>> get mostPopularParkingSpaces {
    final allParkingSessions = [
      ..._activeParkingSessions,
      ..._completedParkingSessions
    ];

    if (allParkingSessions.isEmpty) {
      return [];
    }

    return ParkingStatisticsService.getMostPopularParkingSpaces(
        allParkingSessions);
  }

  void clearActiveParkingSessions() {
    _activeParkingSessions.clear();
    notifyListeners();
  }

  void clearCompletedParkingSessions() {
    _completedParkingSessions.clear();
    notifyListeners();
  }

  void clearData() {
    activeParkingSessions.clear();
    completedParkingSessions.clear();
    _activeSessionsLoaded = false;
    _completedSessionsLoaded = false;
    notifyListeners();
  }
}
