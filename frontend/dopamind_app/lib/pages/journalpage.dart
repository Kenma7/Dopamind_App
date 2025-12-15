// lib/pages/journalpage.dart - UPDATED VERSION
import 'package:flutter/material.dart';
import '../services/journal_service.dart';
import 'journaldetailpage.dart'; // Import yang baru

class JournalPage extends StatefulWidget {
  @override
  _JournalPageState createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  List<Map<String, dynamic>> _journals = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadJournals();
  }

  Future<void> _loadJournals() async {
    setState(() => _isLoading = true);
    try {
      final data = await JournalService.fetchJournals();
      setState(() {
        _journals = data;
        _isLoading = false;
      });
      print('✅ Loaded ${_journals.length} journals');
    } catch (e) {
      print('❌ Error: $e');
      setState(() => _isLoading = false);
      _showError('Failed to load journals: $e');
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

  Future<void> _addJournal() async {
    final text = await _showTextDialog(
      'Add New Journal',
      'Enter your journal entry',
    );
    if (text != null && text.isNotEmpty) {
      try {
        await JournalService.createJournal(
          content: text,
          type: 'reflection',
          mood: '',
        );
        _showSuccess('Journal added successfully!');
        _loadJournals();
      } catch (e) {
        _showError('Failed to add journal: $e');
      }
    }
  }

  Future<String?> _showTextDialog(
    String title,
    String hint, {
    String initialText = '',
  }) async {
    final controller = TextEditingController(text: initialText);

    return await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                Navigator.pop(context, text);
              }
            },
            child: Text('Save', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  Future<void> _quickDelete(Map<String, dynamic> journal) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Journal?'),
        content: Text('Are you sure you want to delete this journal?'),
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
        await JournalService.deleteJournal(journal['id'].toString());
        _showSuccess('Journal deleted!');
        _loadJournals();
      } catch (e) {
        _showError('Failed to delete: $e');
      }
    }
  }

  void _navigateToDetail(Map<String, dynamic> journal) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalDetailPage(
          journal: journal,
          onJournalUpdated: _loadJournals,
          onJournalDeleted: _loadJournals,
        ),
      ),
    );
  }

  List<Map<String, dynamic>> get _filteredJournals {
    if (_searchQuery.isEmpty) return _journals;

    return _journals.where((journal) {
      final content = (journal['content'] ?? '').toLowerCase();
      return content.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  Widget _buildJournalCard(Map<String, dynamic> journal) {
    final content = journal['content'] ?? '';
    final date = journal['created_at'] ?? '';
    final type = journal['type'] ?? 'reflection';
    final mood = journal['mood'] ?? '';

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () => _navigateToDetail(journal),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Journal content (preview)
              Text(
                content.length > 150
                    ? '${content.substring(0, 150)}...'
                    : content,
                style: TextStyle(fontSize: 16, height: 1.5),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12),

              // Metadata and quick actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Left: Type, Mood, Date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: [
                            if (type.isNotEmpty)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: _getTypeColor(type),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  type,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (mood.isNotEmpty)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: _getMoodColor(mood),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  mood,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          _formatDate(date),
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  // Right: Quick action buttons
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, size: 18),
                        color: Colors.blue,
                        onPressed: () => _navigateToDetail(journal),
                        tooltip: 'Open in editor',
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, size: 18),
                        color: Colors.red,
                        onPressed: () => _quickDelete(journal),
                        tooltip: 'Delete',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'gratitude':
        return Colors.green;
      case 'reflection':
        return Colors.blue;
      case 'goal':
        return Colors.orange;
      case 'emotional':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Color _getMoodColor(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return Colors.yellow[800]!;
      case 'sad':
        return Colors.blue;
      case 'anxious':
        return Colors.orange;
      case 'calm':
        return Colors.green;
      case 'energetic':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final journalDate = DateTime(date.year, date.month, date.day);

      if (journalDate == today) {
        return 'Today, ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      } else if (journalDate == today.subtract(Duration(days: 1))) {
        return 'Yesterday, ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      } else {
        return '${date.day}/${date.month}/${date.year}';
      }
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('📓 Journal'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadJournals,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _addJournal,
            tooltip: 'Add New Journal',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search journals...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),

          // Statistics
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Total', '${_journals.length}', Icons.book),
                _buildStatCard(
                  'Showing',
                  '${_filteredJournals.length}',
                  Icons.visibility,
                ),
                _buildStatCard(
                  'Types',
                  '${_journals.map((j) => j['type']).toSet().length}',
                  Icons.category,
                ),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Journals list
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _filteredJournals.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _searchQuery.isEmpty ? Icons.book : Icons.search_off,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No journals yet'
                              : 'No journals found for "$_searchQuery"',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        if (_searchQuery.isEmpty)
                          ElevatedButton(
                            onPressed: _addJournal,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                            ),
                            child: Text('Add Your First Journal'),
                          ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadJournals,
                    child: ListView.builder(
                      padding: EdgeInsets.only(bottom: 80),
                      itemCount: _filteredJournals.length,
                      itemBuilder: (context, index) {
                        return _buildJournalCard(_filteredJournals[index]);
                      },
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addJournal,
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: Colors.deepPurple),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
