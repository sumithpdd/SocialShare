import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post.dart';
import '../models/tag.dart';
import '../models/campaign.dart';
import '../models/team_member.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  CollectionReference<Map<String, dynamic>> get _postsCollection =>
      _firestore.collection('posts');
  CollectionReference<Map<String, dynamic>> get _tagsCollection =>
      _firestore.collection('tags');
  CollectionReference<Map<String, dynamic>> get _campaignsCollection =>
      _firestore.collection('campaigns');
  CollectionReference<Map<String, dynamic>> get _teamMembersCollection =>
      _firestore.collection('team_members');

  // Posts CRUD
  Future<List<Post>> getAllPosts() async {
    try {
      final querySnapshot =
          await _postsCollection.orderBy('date', descending: true).get();

      return querySnapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  Future<Post?> getPostById(String id) async {
    try {
      final doc = await _postsCollection.doc(id).get();
      if (doc.exists) {
        return Post.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch post: $e');
    }
  }

  Future<List<Post>> getPostsByDate(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final querySnapshot = await _postsCollection
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('date', isLessThan: Timestamp.fromDate(endOfDay))
          .get();

      return querySnapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch posts by date: $e');
    }
  }

  Future<Post> createPost(Post post) async {
    try {
      final docRef = await _postsCollection.add(post.toFirestore());
      return post.copyWith(id: docRef.id);
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  Future<Post> updatePost(Post post) async {
    try {
      await _postsCollection.doc(post.id).update(post.toFirestore());
      return post;
    } catch (e) {
      throw Exception('Failed to update post: $e');
    }
  }

  Future<bool> deletePost(String id) async {
    try {
      await _postsCollection.doc(id).delete();
      return true;
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }

  Future<Post> togglePostStatus(String id) async {
    try {
      final doc = await _postsCollection.doc(id).get();
      if (!doc.exists) {
        throw Exception('Post not found');
      }

      final post = Post.fromFirestore(doc);
      final updatedPost = post.copyWith(
        isPosted: !post.isPosted,
        postedAt: !post.isPosted ? DateTime.now() : null,
      );

      await _postsCollection.doc(id).update(updatedPost.toFirestore());
      return updatedPost;
    } catch (e) {
      throw Exception('Failed to toggle post status: $e');
    }
  }

  // Tags CRUD
  Future<List<Tag>> getAllTags() async {
    try {
      final querySnapshot =
          await _tagsCollection.orderBy('usageCount', descending: true).get();

      return querySnapshot.docs.map((doc) => Tag.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch tags: $e');
    }
  }

  Future<Tag> createTag(Tag tag) async {
    try {
      final docRef = await _tagsCollection.add(tag.toFirestore());
      return tag.copyWith(id: docRef.id);
    } catch (e) {
      throw Exception('Failed to create tag: $e');
    }
  }

  Future<Tag> updateTag(Tag tag) async {
    try {
      await _tagsCollection.doc(tag.id).update(tag.toFirestore());
      return tag;
    } catch (e) {
      throw Exception('Failed to update tag: $e');
    }
  }

  Future<bool> deleteTag(String id) async {
    try {
      await _tagsCollection.doc(id).delete();
      return true;
    } catch (e) {
      throw Exception('Failed to delete tag: $e');
    }
  }

  // Campaigns CRUD
  Future<List<Campaign>> getAllCampaigns() async {
    try {
      final querySnapshot = await _campaignsCollection
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Campaign.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch campaigns: $e');
    }
  }

  Future<Campaign> createCampaign(Campaign campaign) async {
    try {
      final docRef = await _campaignsCollection.add(campaign.toFirestore());
      return campaign.copyWith(id: docRef.id);
    } catch (e) {
      throw Exception('Failed to create campaign: $e');
    }
  }

  Future<Campaign> updateCampaign(Campaign campaign) async {
    try {
      await _campaignsCollection
          .doc(campaign.id)
          .update(campaign.toFirestore());
      return campaign;
    } catch (e) {
      throw Exception('Failed to update campaign: $e');
    }
  }

  Future<bool> deleteCampaign(String id) async {
    try {
      await _campaignsCollection.doc(id).delete();
      return true;
    } catch (e) {
      throw Exception('Failed to delete campaign: $e');
    }
  }

  // Team Members CRUD
  Future<List<TeamMember>> getAllTeamMembers() async {
    try {
      final querySnapshot = await _teamMembersCollection
          .where('isActive', isEqualTo: true)
          .orderBy('name')
          .get();

      return querySnapshot.docs
          .map((doc) => TeamMember.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch team members: $e');
    }
  }

  Future<TeamMember> createTeamMember(TeamMember member) async {
    try {
      final docRef = await _teamMembersCollection.add(member.toFirestore());
      return member.copyWith(id: docRef.id);
    } catch (e) {
      throw Exception('Failed to create team member: $e');
    }
  }

  Future<TeamMember> updateTeamMember(TeamMember member) async {
    try {
      await _teamMembersCollection.doc(member.id).update(member.toFirestore());
      return member;
    } catch (e) {
      throw Exception('Failed to update team member: $e');
    }
  }

  Future<bool> deleteTeamMember(String id) async {
    try {
      await _teamMembersCollection.doc(id).delete();
      return true;
    } catch (e) {
      throw Exception('Failed to delete team member: $e');
    }
  }

  // Advanced filtering methods
  Future<List<Post>> getPostsByCampaign(String campaignId) async {
    try {
      final querySnapshot = await _postsCollection
          .where('campaign', isEqualTo: campaignId)
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch posts by campaign: $e');
    }
  }

  Future<List<Post>> getPostsByTag(String tagName) async {
    try {
      final querySnapshot = await _postsCollection
          .where('tags', arrayContains: tagName)
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch posts by tag: $e');
    }
  }

  Future<List<Post>> getPostsByTeamMember(String memberName) async {
    try {
      final querySnapshot = await _postsCollection
          .where('postedBy', isEqualTo: memberName)
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch posts by team member: $e');
    }
  }

  Future<List<Post>> getUpcomingPosts() async {
    try {
      final now = DateTime.now();
      final querySnapshot = await _postsCollection
          .where('date', isGreaterThan: Timestamp.fromDate(now))
          .where('isPosted', isEqualTo: false)
          .orderBy('date')
          .get();

      return querySnapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch upcoming posts: $e');
    }
  }

  Future<List<Post>> getPostedPosts() async {
    try {
      final querySnapshot = await _postsCollection
          .where('isPosted', isEqualTo: true)
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs.map((doc) => Post.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch posted posts: $e');
    }
  }
}
