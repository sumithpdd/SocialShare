import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/tag_provider.dart';
import '../models/tag.dart';
import '../widgets/organization_header.dart';
import '../widgets/navigation_rail.dart';
import '../utils/theme.dart';

class TagManagementScreen extends StatefulWidget {
  const TagManagementScreen({super.key});

  @override
  State<TagManagementScreen> createState() => _TagManagementScreenState();
}

class _TagManagementScreenState extends State<TagManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _colorController = TextEditingController();
  Tag? _editingTag;

  @override
  void initState() {
    super.initState();
    _colorController.text = '#FF6B6B';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void _showTagDialog({Tag? tag}) {
    _editingTag = tag;
    if (tag != null) {
      _nameController.text = tag.name;
      _colorController.text = tag.color;
    } else {
      _nameController.clear();
      _colorController.text = '#FF6B6B';
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tag != null ? 'Edit Tag' : 'Create Tag'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Tag Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a tag name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(
                  labelText: 'Color (Hex)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a color';
                  }
                  if (!RegExp(r'^#[0-9A-Fa-f]{6}$').hasMatch(value)) {
                    return 'Please enter a valid hex color';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _saveTag();
                Navigator.of(context).pop();
              }
            },
            child: Text(tag != null ? 'Update' : 'Create'),
          ),
        ],
      ),
    );
  }

  void _saveTag() {
    final tagProvider = context.read<TagProvider>();
    final now = DateTime.now();

    if (_editingTag != null) {
      // Update existing tag
      final updatedTag = _editingTag!.copyWith(
        name: _nameController.text,
        color: _colorController.text,
        updatedAt: now,
      );
      tagProvider.updateTag(updatedTag);
    } else {
      // Create new tag
      final newTag = Tag(
        id: '',
        name: _nameController.text,
        color: _colorController.text,
        createdAt: now,
        updatedAt: now,
      );
      tagProvider.addTag(newTag);
    }
  }

  void _deleteTag(Tag tag) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Tag'),
        content: Text('Are you sure you want to delete "${tag.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TagProvider>().deleteTag(tag.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Tag Management',
                              style: AppTheme.headlineLarge,
                            ),
                            ElevatedButton.icon(
                              onPressed: () => _showTagDialog(),
                              icon: const Icon(Icons.add),
                              label: const Text('Create Tag'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Expanded(
                          child: Consumer<TagProvider>(
                            builder: (context, tagProvider, child) {
                              if (tagProvider.isLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (tagProvider.error != null) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.error, size: 64, color: Colors.red),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Error: ${tagProvider.error}',
                                        style: const TextStyle(color: Colors.red),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => tagProvider.refreshTags(),
                                        child: const Text('Retry'),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              if (tagProvider.tags.isEmpty) {
                                return const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.label_off, size: 64, color: Colors.grey),
                                      SizedBox(height: 16),
                                      Text(
                                        'No tags found',
                                        style: TextStyle(fontSize: 18, color: Colors.grey),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'Create your first tag to get started',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              return ListView.builder(
                                itemCount: tagProvider.tags.length,
                                itemBuilder: (context, index) {
                                  final tag = tagProvider.tags[index];
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    child: ListTile(
                                      leading: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: Color(int.parse(tag.color.replaceFirst('#', '0xFF'))),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      title: Text(tag.name),
                                      subtitle: Text('Used ${tag.usageCount} times'),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () => _showTagDialog(tag: tag),
                                            icon: const Icon(Icons.edit),
                                            tooltip: 'Edit tag',
                                          ),
                                          IconButton(
                                            onPressed: () => _deleteTag(tag),
                                            icon: const Icon(Icons.delete),
                                            tooltip: 'Delete tag',
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
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
}
