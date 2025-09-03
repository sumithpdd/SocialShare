import 'package:flutter/foundation.dart';
import '../models/team_member.dart';
import '../services/firebase_service.dart';

class TeamMemberProvider with ChangeNotifier {
  final FirebaseService _firebaseService;
  
  List<TeamMember> _teamMembers = [];
  bool _isLoading = false;
  String? _error;

  TeamMemberProvider({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseService() {
    _loadTeamMembers();
  }

  List<TeamMember> get teamMembers => _teamMembers;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<TeamMember> get activeMembers => 
      _teamMembers.where((m) => m.isActive).toList();

  List<TeamMember> get admins => 
      _teamMembers.where((m) => m.role == 'admin').toList();

  List<TeamMember> get editors => 
      _teamMembers.where((m) => m.permissions.contains('edit')).toList();

  Future<void> _loadTeamMembers() async {
    _setLoading(true);
    try {
      _teamMembers = await _firebaseService.getAllTeamMembers();
      _error = null;
    } catch (e) {
      _error = 'Failed to load team members: $e';
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> refreshTeamMembers() async {
    await _loadTeamMembers();
  }

  Future<void> addTeamMember(TeamMember member) async {
    _setLoading(true);
    try {
      final newMember = await _firebaseService.createTeamMember(member);
      _teamMembers.add(newMember);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to create team member: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateTeamMember(TeamMember member) async {
    _setLoading(true);
    try {
      final updatedMember = await _firebaseService.updateTeamMember(member);
      final index = _teamMembers.indexWhere((m) => m.id == updatedMember.id);
      if (index != -1) {
        _teamMembers[index] = updatedMember;
      }
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update team member: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteTeamMember(String id) async {
    _setLoading(true);
    try {
      final success = await _firebaseService.deleteTeamMember(id);
      if (success) {
        _teamMembers.removeWhere((member) => member.id == id);
      }
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete team member: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  TeamMember? getTeamMemberById(String id) {
    try {
      return _teamMembers.firstWhere((member) => member.id == id);
    } catch (e) {
      return null;
    }
  }

  TeamMember? getTeamMemberByEmail(String email) {
    try {
      return _teamMembers.firstWhere((member) => member.email == email);
    } catch (e) {
      return null;
    }
  }

  List<TeamMember> getTeamMembersByName(String name) {
    return _teamMembers.where((member) => 
        member.name.toLowerCase().contains(name.toLowerCase())).toList();
  }

  List<TeamMember> getTeamMembersByRole(String role) {
    return _teamMembers.where((member) => member.role == role).toList();
  }

  List<TeamMember> getTeamMembersByPermission(String permission) {
    return _teamMembers.where((member) => 
        member.permissions.contains(permission)).toList();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
