import '../models/post.dart';
import '../models/organization.dart';
import 'json_post_service.dart';

class DummyDataService {
  static final Organization gdgLondon = JsonPostService.gdgLondon;

  static Future<List<Post>> loadPosts() {
    return JsonPostService.loadPosts();
  }

  static Future<List<Post>> refreshPosts() {
    return JsonPostService.refreshPosts();
  }

  static List<Post> getPostsByDate(DateTime date) {
    return JsonPostService.getPostsByDate(date);
  }

  static List<Post> getUpcomingPosts() {
    return JsonPostService.getUpcomingPosts();
  }

  static List<Post> getPostedPosts() {
    return JsonPostService.getPostedPosts();
  }

  static List<Post> getRecentPosts() {
    return JsonPostService.getRecentPosts();
  }

  static List<Post> getPostsByPlatform(SocialPlatform platform) {
    return JsonPostService.getPostsByPlatform(platform);
  }

  static List<Post> getPostsByTag(String tag) {
    return JsonPostService.getPostsByTag(tag);
  }

  static List<Post> getPostsByCampaign(String campaign) {
    return JsonPostService.getPostsByCampaign(campaign);
  }

  static List<String> getAvailableCampaigns() {
    return JsonPostService.getAvailableCampaigns();
  }
}
