// lib/pages/journal_detail_page.dart
import 'package:flutter/material.dart';
import '../services/journal_service.dart';

class JournalDetailPage extends StatefulWidget {
  final Map<String, dynamic> journal;
  final VoidCallback? onJournalUpdated;
  final VoidCallback? onJournalDeleted;

  const JournalDetailPage({
    required this.journal,
    this.onJournalUpdated,
    this.onJournalDeleted,
  });

  @override
  _JournalDetailPageState createState() => _JournalDetailPageState();
}

class _JournalDetailPageState extends State<JournalDetailPage> {
  late TextEditingController _contentController;
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(
      text: widget.journal['content'] ?? '',
    );
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveJournal() async {
    final newContent = _contentController.text.trim();
    final originalContent = widget.journal['content'] ?? '';

    if (newContent.isEmpty) {
      _showError('Journal content cannot be empty');
      return;
    }

    if (newContent == originalContent) {
      setState(() => _isEditing = false);
      return;
    }

    setState(() => _isSaving = true);

    try {
      await JournalService.updateJournal(
        id: widget.journal['id'].toString(),
        content: newContent,
        type: widget.journal['type'] ?? 'reflection',
        mood: widget.journal['mood'] ?? '',
      );

      _showSuccess('Journal updated successfully!');

      // Update the journal data
      widget.journal['content'] = newContent;

      if (widget.onJournalUpdated != null) {
        widget.onJournalUpdated!();
      }

      setState(() {
        _isEditing = false;
        _isSaving = false;
      });
    } catch (e) {
      _showError('Failed to update: $e');
      setState(() => _isSaving = false);
    }
  }

  Future<void> _deleteJournal() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Journal?'),
        content: Text(
          'Are you sure you want to delete this journal? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await JournalService.deleteJournal(widget.journal['id'].toString());
        _showSuccess('Journal deleted successfully!');

        if (widget.onJournalDeleted != null) {
          widget.onJournalDeleted!();
        }

        Navigator.pop(context); // Go back to list
      } catch (e) {
        _showError('Failed to delete: $e');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
        border: Border(bottom: BorderSide(color: Colors.deepPurple[100]!)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Journal Entry',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple[800],
                  ),
                ),
                Text(
                  _formatDate(widget.journal['created_at'] ?? ''),
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          if (!_isEditing)
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: () => setState(() => _isEditing = true),
              tooltip: 'Edit',
            ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: _deleteJournal,
            tooltip: 'Delete',
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _isEditing
            ? TextField(
                controller: _contentController,
                maxLines: null,
                autofocus: true,
                style: TextStyle(fontSize: 16, height: 1.6),
                decoration: InputDecoration(
                  hintText: 'Write your thoughts...',
                  border: InputBorder.none,
                ),
              )
            : SingleChildScrollView(
                child: Text(
                  widget.journal['content'] ?? '',
                  style: TextStyle(fontSize: 16, height: 1.6),
                ),
              ),
      ),
    );
  }

  Widget _buildFooter() {
    if (!_isEditing) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => setState(() => _isEditing = false),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text('Cancel'),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: _isSaving ? null : _saveJournal,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: _isSaving
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text('Save Changes'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [_buildHeader(), _buildContent(), _buildFooter()]),
    );
  }
}
