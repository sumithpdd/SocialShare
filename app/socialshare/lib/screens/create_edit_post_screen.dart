import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/post_provider.dart';
import '../models/post.dart';
import '../widgets/organization_header.dart';
import '../widgets/navigation_rail.dart';
import '../utils/theme.dart';

// Team members constant
const List<String> teamMembers = [
  'Renuka Kelkar',
  'Sumith Damodaran',
  'Goran Minov',
  'Chris Bouloumpasis',
  'Inès Rigaud',
  'Stefan Cornea',
  'Mihaela Peneva',
];

class CreateEditPostScreen extends StatefulWidget {
  final Post? postToEdit; // Add this parameter for editing

  const CreateEditPostScreen({super.key, this.postToEdit});

  @override
  State<CreateEditPostScreen> createState() => _CreateEditPostScreenState();
}

class _CreateEditPostScreenState extends State<CreateEditPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _videoUrlController = TextEditingController();
  final _tagController = TextEditingController();
  final _additionalLinkController = TextEditingController();
  final _campaignController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  final List<SocialPlatform> _selectedPlatforms = [];
  final List<String> _tags = [];
  final List<String> _additionalLinks = [];
  final List<String> _selectedTeamMembers = []; // New field for multi-select

  @override
  void initState() {
    super.initState();
    _initializeFormData();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _imageUrlController.dispose();
    _videoUrlController.dispose();
    _tagController.dispose();
    _additionalLinkController.dispose();
    _campaignController.dispose();
    super.dispose();
  }

  void _initializeFormData() {
    if (widget.postToEdit != null) {
      // Populate form with existing post data
      final post = widget.postToEdit!;
      _titleController.text = post.title;
      _contentController.text = post.content;
      _imageUrlController.text = post.imageUrl ?? '';
      _videoUrlController.text = post.videoUrl ?? '';
      // Parse postedBy string into selected team members
      _selectedTeamMembers.clear();
      if (post.postedBy.isNotEmpty) {
        _selectedTeamMembers.addAll(post.postedBy.split(', '));
      }
      _selectedDate = post.date;
      _selectedPlatforms.clear();
      _selectedPlatforms.addAll(post.platforms);
      _tags.clear();
      _tags.addAll(post.tags);
      _additionalLinks.clear();
      _additionalLinks.addAll(post.additionalLinks);
      _campaignController.text = post.campaign ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const CustomNavigationRail(),
          Expanded(
            child: Column(
              children: [
                const OrganizationHeader(),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () => context.go('/'),
                                icon: const Icon(Icons.arrow_back),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                widget.postToEdit != null ? 'Edit Post' : 'Create New Post',
                                style: AppTheme.headlineLarge,
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  _buildBasicInfoSection(),
                                  const SizedBox(height: 24),
                                  _buildContentSection(),
                                  const SizedBox(height: 24),
                                  _buildMediaSection(),
                                  const SizedBox(height: 24),
                                  _buildPlatformsSection(),
                                  const SizedBox(height: 24),
                                  _buildTagsSection(),
                                  const SizedBox(height: 24),
                                  _buildAdditionalLinksSection(),
                                  const SizedBox(height: 32),
                                  _buildActionButtons(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Basic Information',
              style: AppTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Post Title *',
                      hintText: 'Enter post title',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _titleController.text.isNotEmpty
                      ? () => _copyToClipboard(_titleController.text, 'Title')
                      : null,
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copy title',
                  color: _titleController.text.isNotEmpty
                      ? AppTheme.primaryBlue
                      : Colors.grey,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Posted By *',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: teamMembers.map((member) {
                            final isSelected = _selectedTeamMembers.contains(member);
                            return FilterChip(
                              label: Text(member),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedTeamMembers.add(member);
                                  } else {
                                    _selectedTeamMembers.remove(member);
                                  }
                                });
                              },
                              selectedColor: AppTheme.primaryBlue.withValues(alpha: 0.2),
                              checkmarkColor: AppTheme.primaryBlue,
                            );
                          }).toList(),
                        ),
                      ),
                      if (_selectedTeamMembers.isEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            'Please select at least one team member',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _selectedTeamMembers.isNotEmpty
                      ? () => _copyToClipboard(
                          _selectedTeamMembers.join(', '), 'Posted By')
                      : null,
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copy posted by',
                  color: _selectedTeamMembers.isNotEmpty
                      ? AppTheme.primaryBlue
                      : Colors.grey,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _campaignController,
                    decoration: const InputDecoration(
                      labelText: 'Campaign/Event',
                      hintText: 'e.g., IO Extended 2025, DevFest 2025',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _campaignController.text.isNotEmpty
                      ? () =>
                          _copyToClipboard(_campaignController.text, 'Campaign')
                      : null,
                  icon: const Icon(Icons.copy),
                  tooltip: 'Copy campaign',
                  color: _campaignController.text.isNotEmpty
                      ? AppTheme.primaryBlue
                      : Colors.grey,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey.withValues(alpha: 0.3)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.grey),
                          const SizedBox(width: 12),
                          Text(
                            'Scheduled Date: ${_formatDate(_selectedDate)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Post Content',
              style: AppTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _contentController,
                    maxLines: 6,
                    decoration: const InputDecoration(
                      labelText: 'Post Content *',
                      hintText: 'Write your post content here...',
                      alignLabelWithHint: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter post content';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                if (_contentController.text.isNotEmpty)
                  IconButton(
                    onPressed: () =>
                        _copyToClipboard(_contentController.text, 'Content'),
                    icon: const Icon(Icons.copy),
                    tooltip: 'Copy content',
                    color: AppTheme.primaryBlue,
                  ),
              ],
            ),
            if (_contentController.text.isNotEmpty)
              IconButton(
                onPressed: () =>
                    _copyToClipboard(_contentController.text, 'Content'),
                icon: const Icon(Icons.copy),
                tooltip: 'Copy content',
                color: AppTheme.primaryBlue,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Media (Optional)',
              style: AppTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _imageUrlController,
                    decoration: const InputDecoration(
                      labelText: 'Image URL',
                      hintText: 'https://example.com/image.jpg',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (_imageUrlController.text.isNotEmpty)
                  IconButton(
                    onPressed: () =>
                        _copyToClipboard(_imageUrlController.text, 'Image URL'),
                    icon: const Icon(Icons.copy),
                    tooltip: 'Copy image URL',
                    color: AppTheme.primaryBlue,
                  ),
                const SizedBox(width: 20),
                Expanded(
                  child: TextFormField(
                    controller: _videoUrlController,
                    decoration: const InputDecoration(
                      labelText: 'Video URL',
                      hintText: 'https://example.com/video.mp4',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (_videoUrlController.text.isNotEmpty)
                  IconButton(
                    onPressed: () =>
                        _copyToClipboard(_videoUrlController.text, 'Video URL'),
                    icon: const Icon(Icons.copy),
                    tooltip: 'Copy video URL',
                    color: AppTheme.primaryBlue,
                  ),
              ],
            ),
            if (_imageUrlController.text.isNotEmpty)
              IconButton(
                onPressed: () =>
                    _copyToClipboard(_imageUrlController.text, 'Image URL'),
                icon: const Icon(Icons.copy),
                tooltip: 'Copy image URL',
                color: AppTheme.primaryBlue,
              ),
            if (_videoUrlController.text.isNotEmpty)
              IconButton(
                onPressed: () =>
                    _copyToClipboard(_videoUrlController.text, 'Video URL'),
                icon: const Icon(Icons.copy),
                tooltip: 'Copy video URL',
                color: AppTheme.primaryBlue,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlatformsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Social Media Platforms *',
              style: AppTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: SocialPlatform.values.map((platform) {
                final isSelected = _selectedPlatforms.contains(platform);
                return FilterChip(
                  label: Text(platform.displayName),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _selectedPlatforms.add(platform);
                      } else {
                        _selectedPlatforms.remove(platform);
                      }
                    });
                  },
                  backgroundColor: Colors.grey[200],
                  selectedColor: AppTheme.primaryBlue.withValues(alpha: 0.2),
                  checkmarkColor: AppTheme.primaryBlue,
                );
              }).toList(),
            ),
            if (_selectedPlatforms.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 8),
                child: Text(
                  'Please select at least one platform',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tags',
              style: AppTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _tagController,
                    decoration: const InputDecoration(
                      labelText: 'Add Tag',
                      hintText: 'Enter a tag and press +',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (_tagController.text.isNotEmpty)
                  IconButton(
                    onPressed: () =>
                        _copyToClipboard(_tagController.text, 'Tag'),
                    icon: const Icon(Icons.copy),
                    tooltip: 'Copy tag',
                    color: AppTheme.primaryBlue,
                  ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _addTag,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            if (_tags.isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _tags
                    .map((tag) => Chip(
                          label: Text(tag),
                          onDeleted: () => _removeTag(tag),
                          deleteIcon: const Icon(Icons.close, size: 18),
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalLinksSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Additional Links',
              style: AppTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _additionalLinkController,
                    decoration: const InputDecoration(
                      labelText: 'Add Link',
                      hintText: 'https://example.com',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (_additionalLinkController.text.isNotEmpty)
                  IconButton(
                    onPressed: () => _copyToClipboard(
                        _additionalLinkController.text, 'Link'),
                    icon: const Icon(Icons.copy),
                    tooltip: 'Copy link',
                    color: AppTheme.primaryBlue,
                  ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _addAdditionalLink,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            if (_additionalLinks.isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _additionalLinks
                    .map((link) => Chip(
                          label: Text(link),
                          onDeleted: () => _removeAdditionalLink(link),
                          deleteIcon: const Icon(Icons.close, size: 18),
                        ))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => context.go('/'),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 16),
                  ElevatedButton(
            onPressed: _submitPost,
            child: Text(widget.postToEdit != null ? 'Update Post' : 'Create Post'),
          ),
      ],
    );
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  void _addAdditionalLink() {
    final link = _additionalLinkController.text.trim();
    if (link.isNotEmpty && !_additionalLinks.contains(link)) {
      setState(() {
        _additionalLinks.add(link);
        _additionalLinkController.clear();
      });
    }
  }

  void _removeAdditionalLink(String link) {
    setState(() {
      _additionalLinks.remove(link);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _copyToClipboard(String text, String fieldName) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$fieldName copied to clipboard'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _submitPost() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedTeamMembers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one team member'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedPlatforms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one platform'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (widget.postToEdit != null) {
      // Update existing post
      final updatedPost = widget.postToEdit!.copyWith(
        title: _titleController.text,
        content: _contentController.text,
        date: _selectedDate,
        postedBy: _selectedTeamMembers.join(', '),
        imageUrl: _imageUrlController.text.isNotEmpty ? _imageUrlController.text : null,
        videoUrl: _videoUrlController.text.isNotEmpty ? _videoUrlController.text : null,
        tags: _tags,
        platforms: _selectedPlatforms,
        additionalLinks: _additionalLinks,
        campaign: _campaignController.text.isNotEmpty ? _campaignController.text : null,
      );

      context.read<PostProvider>().updatePost(updatedPost);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Create new post
      final post = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        content: _contentController.text,
        date: _selectedDate,
        isPosted: false,
        postedBy: _selectedTeamMembers.join(', '),
        imageUrl: _imageUrlController.text.isNotEmpty ? _imageUrlController.text : null,
        videoUrl: _videoUrlController.text.isNotEmpty ? _videoUrlController.text : null,
        tags: _tags,
        platforms: _selectedPlatforms,
        additionalLinks: _additionalLinks,
        campaign: _campaignController.text.isNotEmpty ? _campaignController.text : null,
      );

      context.read<PostProvider>().addPost(post);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }

    context.go('/');
  }
}
