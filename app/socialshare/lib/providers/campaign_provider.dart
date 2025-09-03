import 'package:flutter/foundation.dart';
import '../models/campaign.dart';
import '../services/firebase_service.dart';

class CampaignProvider with ChangeNotifier {
  final FirebaseService _firebaseService;
  
  List<Campaign> _campaigns = [];
  bool _isLoading = false;
  String? _error;

  CampaignProvider({FirebaseService? firebaseService})
      : _firebaseService = firebaseService ?? FirebaseService() {
    _loadCampaigns();
  }

  List<Campaign> get campaigns => _campaigns;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Campaign> get activeCampaigns => 
      _campaigns.where((c) => c.status == 'active').toList();

  List<Campaign> get draftCampaigns => 
      _campaigns.where((c) => c.status == 'draft').toList();

  List<Campaign> get completedCampaigns => 
      _campaigns.where((c) => c.status == 'completed').toList();

  Future<void> _loadCampaigns() async {
    _setLoading(true);
    try {
      _campaigns = await _firebaseService.getAllCampaigns();
      _error = null;
    } catch (e) {
      _error = 'Failed to load campaigns: $e';
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> refreshCampaigns() async {
    await _loadCampaigns();
  }

  Future<void> addCampaign(Campaign campaign) async {
    _setLoading(true);
    try {
      final newCampaign = await _firebaseService.createCampaign(campaign);
      _campaigns.add(newCampaign);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to create campaign: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateCampaign(Campaign campaign) async {
    _setLoading(true);
    try {
      final updatedCampaign = await _firebaseService.updateCampaign(campaign);
      final index = _campaigns.indexWhere((c) => c.id == updatedCampaign.id);
      if (index != -1) {
        _campaigns[index] = updatedCampaign;
      }
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to update campaign: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteCampaign(String id) async {
    _setLoading(true);
    try {
      final success = await _firebaseService.deleteCampaign(id);
      if (success) {
        _campaigns.removeWhere((campaign) => campaign.id == id);
      }
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to delete campaign: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Campaign? getCampaignById(String id) {
    try {
      return _campaigns.firstWhere((campaign) => campaign.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Campaign> getCampaignsByName(String name) {
    return _campaigns.where((campaign) => 
        campaign.name.toLowerCase().contains(name.toLowerCase())).toList();
  }

  List<Campaign> getCampaignsByStatus(String status) {
    return _campaigns.where((campaign) => campaign.status == status).toList();
  }

  List<Campaign> getCampaignsByDateRange(DateTime startDate, DateTime endDate) {
    return _campaigns.where((campaign) => 
        campaign.startDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
        campaign.startDate.isBefore(endDate.add(const Duration(days: 1)))).toList();
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
