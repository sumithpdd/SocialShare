import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import '../services/ai_service.dart';
import '../providers/json_post_provider.dart';

class AIPostCreator extends StatefulWidget {
  const AIPostCreator({super.key});

  @override
  State<AIPostCreator> createState() => _AIPostCreatorState();
}

class _AIPostCreatorState extends State<AIPostCreator> {
  final _formKey = GlobalKey<FormState>();
  final _topicController = TextEditingController();
  final _additionalContextController = TextEditingController();
  final _styleController = TextEditingController();

  Uint8List? _selectedImage;
  String? _uploadedImageUrl;
  bool _isGenerating = false;
  bool _isUploading = false;
  String? _error;

  // Upload progress tracking
  double _uploadProgress = 0.0;

  // AI Generation Results
  List<String> _generatedTitles = [];
  List<String> _generatedContents = [];
  List<List<String>> _generatedTags = [];
  List<List<String>> _generatedMentions = [];

  // Selected Variants
  int _selectedTitleIndex = 0;
  int _selectedContentIndex = 0;
  int _selectedTagsIndex = 0;
  int _selectedMentionsIndex = 0;

  // Current Step
  int _currentStep =
      0; // 0: Input, 1: AI Generation, 2: Variant Selection, 3: Final Review

  final AIService _aiService = AIService();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void dispose() {
    _topicController.dispose();
    _additionalContextController.dispose();
    _styleController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedImage = bytes;
          _uploadedImageUrl = null;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error picking image: $e';
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isUploading = true;
      _error = null;
    });

    try {
      final filename = 'post_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final url = await _aiService.uploadImage(_selectedImage!, filename);

      if (url != null) {
        setState(() {
          _uploadedImageUrl = url;
          _isUploading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to upload image';
          _isUploading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error uploading image: $e';
        _isUploading = false;
      });
    }
  }

  Future<void> _generateWithAI() async {
    if (_topicController.text.trim().isEmpty) {
      setState(() {
        _error = 'Please enter a topic';
      });
      return;
    }

    setState(() {
      _isGenerating = true;
      _error = null;
    });

    try {
      // Generate all variants
      final titles = await _aiService.generatePostTitles(
        _topicController.text.trim(),
        style: _styleController.text.trim().isNotEmpty
            ? _styleController.text.trim()
            : null,
      );

      final contents = await _aiService.generatePostContent(
        _topicController.text.trim(),
        style: _styleController.text.trim().isNotEmpty
            ? _styleController.text.trim()
            : null,
      );

      final tags =
          await _aiService.generatePostTags(_topicController.text.trim());
      final mentions =
          await _aiService.generatePostMentions(_topicController.text.trim());

      setState(() {
        _generatedTitles = titles;
        _generatedContents = contents;
        _generatedTags = tags;
        _generatedMentions = mentions;
        _isGenerating = false;
        _currentStep = 2; // Move to variant selection
      });
    } catch (e) {
      setState(() {
        _error = 'Error generating content: $e';
        _isGenerating = false;
      });
    }
  }

  Future<void> _createPost() async {
    if (_generatedTitles.isEmpty || _generatedContents.isEmpty) return;

    final post = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _generatedTitles[_selectedTitleIndex],
      content: _generatedContents[_selectedContentIndex],
      date: DateTime.now(),
      isPosted: false,
      postedBy: 'GDG London Team',
      imageUrl: _uploadedImageUrl,
      tags: _generatedTags.isNotEmpty ? _generatedTags[_selectedTagsIndex] : [],
      platforms: [SocialPlatform.linkedin, SocialPlatform.twitter],
      additionalLinks: [],
      campaign: null,
      mentions: _generatedMentions.isNotEmpty
          ? _generatedMentions[_selectedMentionsIndex]
          : [],
    );

    try {
      final provider = context.read<JsonPostProvider>();
      await provider.addPost(post);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post created successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Reset and go back to start
        _resetForm();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating post: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _resetForm() {
    setState(() {
      _topicController.clear();
      _additionalContextController.clear();
      _styleController.clear();
      _selectedImage = null;
      _uploadedImageUrl = null;
      _generatedTitles = [];
      _generatedContents = [];
      _generatedTags = [];
      _generatedMentions = [];
      _selectedTitleIndex = 0;
      _selectedContentIndex = 0;
      _selectedTagsIndex = 0;
      _selectedMentionsIndex = 0;
      _currentStep = 0;
      _error = null;
    });
  }

  void _goToStep(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  Widget _buildInputScreen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        const Text(
          'Create AI-Powered Social Media Post',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'Let AI help you create engaging content for your tech community',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        // Topic Input
        TextFormField(
          controller: _topicController,
          decoration: const InputDecoration(
            labelText: 'Topic/Subject *',
            hintText: 'e.g., Flutter Development, AI Workshop, Tech Meetup',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.topic),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a topic';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Style Input
        TextFormField(
          controller: _styleController,
          decoration: const InputDecoration(
            labelText: 'Style (Optional)',
            hintText: 'e.g., Professional, Casual, Technical, Inspirational',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.style),
          ),
        ),
        const SizedBox(height: 16),

        // Additional Context
        TextFormField(
          controller: _additionalContextController,
          decoration: const InputDecoration(
            labelText: 'Additional Context (Optional)',
            hintText: 'Any specific details or context for the post',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.info),
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 24),

        // Image Upload Section
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.image,
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    const Text(
                      'Image Upload (Optional)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_selectedImage != null) ...[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        _selectedImage!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.image),
                        label: const Text('Pick Image'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    if (_selectedImage != null && _uploadedImageUrl == null)
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isUploading ? null : _uploadImage,
                          icon: _isUploading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.cloud_upload),
                          label: Text(_isUploading ? 'Uploading...' : 'Upload'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                  ],
                ),
                if (_uploadedImageUrl != null) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Image uploaded successfully!',
                            style: TextStyle(color: Colors.green.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Display uploaded image from Firebase Storage
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.shade300),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        _uploadedImageUrl!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 200,
                            width: double.infinity,
                            color: Colors.grey.shade200,
                            child: Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 200,
                            width: double.infinity,
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.error,
                                      size: 48, color: Colors.grey),
                                  SizedBox(height: 8),
                                  Text(
                                    'Failed to load uploaded image',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],

                // Error Display
                if (_error != null && _error!.contains('Upload')) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.error, color: Colors.red),
                            const SizedBox(width: 8),
                            const Text(
                              'Upload Error',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'You can still create posts without images.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Upload Progress Indicator
                if (_isUploading && _uploadedImageUrl == null) ...[
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Upload Progress:'),
                          Text(
                              '${(_uploadProgress * 100).toStringAsFixed(1)}%'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: _uploadProgress,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Generate Button
        ElevatedButton.icon(
          onPressed: _isGenerating ? null : _generateWithAI,
          icon: _isGenerating
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.auto_awesome, size: 28),
          label: Text(
            _isGenerating ? 'Generating with AI...' : 'Generate with AI ✨',
            style: const TextStyle(fontSize: 18),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 20),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildVariantSelectionScreen() {
    // Safety check: if no content was generated, show error message
    if (_generatedTitles.isEmpty && _generatedContents.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'No Content Generated',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'AI generation failed or returned no results. Please try again.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _goToStep(0),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Go Back and Try Again'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        const Text(
          'Select Your Preferred Variants',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'Choose the best title, content, tags, and mentions for your post',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        // Title Selection
        if (_generatedTitles.isNotEmpty)
          _buildVariantSection(
            title: 'Post Title',
            variants: _generatedTitles,
            selectedIndex: _selectedTitleIndex,
            onSelectionChanged: (index) =>
                setState(() => _selectedTitleIndex = index),
            icon: Icons.title,
          ),
        if (_generatedTitles.isNotEmpty) const SizedBox(height: 24),

        // Content Selection
        if (_generatedContents.isNotEmpty)
          _buildVariantSection(
            title: 'Post Content',
            variants: _generatedContents,
            selectedIndex: _selectedContentIndex,
            onSelectionChanged: (index) =>
                setState(() => _selectedContentIndex = index),
            icon: Icons.description,
          ),
        if (_generatedContents.isNotEmpty) const SizedBox(height: 24),

        // Tags Selection
        if (_generatedTags.isNotEmpty)
          _buildVariantSection(
            title: 'Hashtags',
            variants: _generatedTags.map((tags) => tags.join(', ')).toList(),
            selectedIndex: _selectedTagsIndex,
            onSelectionChanged: (index) =>
                setState(() => _selectedTagsIndex = index),
            icon: Icons.tag,
          ),
        if (_generatedTags.isNotEmpty) const SizedBox(height: 24),

        // Mentions Selection
        if (_generatedMentions.isNotEmpty)
          _buildVariantSection(
            title: 'Mentions',
            variants: _generatedMentions
                .map((mentions) => mentions.join(', '))
                .toList(),
            selectedIndex: _selectedMentionsIndex,
            onSelectionChanged: (index) =>
                setState(() => _selectedMentionsIndex = index),
            icon: Icons.alternate_email,
          ),
        const SizedBox(height: 32),

        // Navigation Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _goToStep(0),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _goToStep(3),
                icon: const Icon(Icons.preview),
                label: const Text('Preview Post'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVariantSection({
    required String title,
    required List<String> variants,
    required int selectedIndex,
    required Function(int) onSelectionChanged,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Side-by-side variant comparison
            Row(
              children: variants.asMap().entries.map((entry) {
                final index = entry.key;
                final variant = entry.value;
                final isSelected = index == selectedIndex;

                return Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      right: index < variants.length - 1 ? 8.0 : 0,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: isSelected
                          ? Theme.of(context)
                              .colorScheme
                              .primaryContainer
                              .withOpacity(0.1)
                          : Colors.grey.shade50,
                    ),
                    child: InkWell(
                      onTap: () => onSelectionChanged(index),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Radio button and variant number
                            Row(
                              children: [
                                Radio<int>(
                                  value: index,
                                  groupValue: selectedIndex,
                                  onChanged: (value) =>
                                      onSelectionChanged(value!),
                                  activeColor:
                                      Theme.of(context).colorScheme.primary,
                                ),
                                Text(
                                  'Variant ${index + 1}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Variant content
                            Text(
                              variant,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.4,
                                color: isSelected
                                    ? Colors.black87
                                    : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFinalReviewScreen() {
    final selectedTitle = _generatedTitles[_selectedTitleIndex];
    final selectedContent = _generatedContents[_selectedContentIndex];
    final selectedTags =
        _generatedTags.isNotEmpty ? _generatedTags[_selectedTagsIndex] : [];
    final selectedMentions = _generatedMentions.isNotEmpty
        ? _generatedMentions[_selectedMentionsIndex]
        : [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        const Text(
          'Final Review',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          'Review your AI-generated post before creating',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),

        // Post Preview Card
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Preview
                if (_uploadedImageUrl != null) ...[
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade200,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        _uploadedImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child:
                                Icon(Icons.image, size: 64, color: Colors.grey),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Title
                Text(
                  selectedTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),

                // Content
                Text(
                  selectedContent,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 20),

                // Tags
                if (selectedTags.isNotEmpty) ...[
                  Wrap(
                    spacing: 8,
                    children: selectedTags.map((tag) {
                      return Chip(
                        label: Text(tag),
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],

                // Mentions
                if (selectedMentions.isNotEmpty) ...[
                  Wrap(
                    spacing: 8,
                    children: selectedMentions.map((mention) {
                      return Chip(
                        label: Text('@$mention'),
                        backgroundColor:
                            Theme.of(context).colorScheme.secondaryContainer,
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Navigation Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _goToStep(2),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Selection'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _createPost,
                icon: const Icon(Icons.save),
                label: const Text('Create Post'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Post Creator'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          if (_currentStep > 0)
            TextButton.icon(
              onPressed: _resetForm,
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text('Start Over',
                  style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: _currentStep == 0
              ? _buildInputScreen()
              : _currentStep == 2
                  ? _buildVariantSelectionScreen()
                  : _buildFinalReviewScreen(),
        ),
      ),
    );
  }
}
