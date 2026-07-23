import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/company_model.dart';

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  final api = const ApiService();
  List<Company> companies = [];
  bool isLoading = true;
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    userId = await api.getUserId();
    if (userId != null) {
      final data = await api.getCompanies(userId!);
      setState(() {
        companies = data.map((e) => Company.fromJson(e)).toList();
        isLoading = false;
      });
    }
  }

  void _showAddDialog() {
    final nameCtrl = TextEditingController();
    String? searchedEmail;
    String? searchedContact;
    String? verificationStatus;
    bool isSearching = false;
    Timer? debounce;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Add Company', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Company Name',
                  hintText: 'e.g. Facebook',
                  suffixIcon: isSearching
                      ? const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : null,
                ),
                onChanged: (value) {
                  if (debounce?.isActive ?? false) debounce?.cancel();
                  debounce = Timer(const Duration(milliseconds: 1000), () async {
                    if (value.isNotEmpty) {
                      setDialogState(() => isSearching = true);
                      final result = await api.searchCompanyDetails(value);
                      setDialogState(() {
                        isSearching = false;
                        if (result['success']) {
                          searchedEmail = result['email'];
                          searchedContact = result['contact'];
                          verificationStatus = result['verification']?['status'];
                        }
                      });
                    }
                  });
                },
              ),
              if (isSearching)
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Center(child: Text('Searching & Verifying...', style: TextStyle(fontSize: 12, color: Colors.indigo))),
                ),
              if (!isSearching && (searchedEmail != null || searchedContact != null)) ...[
                const SizedBox(height: 20),
                if (searchedEmail != null)
                  _buildInfoRow(
                    Icons.mark_email_read_outlined, 
                    'Verified Email', 
                    searchedEmail!,
                    tag: verificationStatus == 'deliverable' ? 'VALID' : verificationStatus?.toUpperCase(),
                    tagColor: verificationStatus == 'deliverable' ? Colors.green : Colors.orange,
                  ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  Icons.phone_android_outlined, 
                  'Contact Number', 
                  searchedContact ?? 'Not found',
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                debounce?.cancel();
                Navigator.pop(context);
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                print('--- Attempting to Add Company ---');
                if (nameCtrl.text.isEmpty) {
                   ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a company name')),
                  );
                  return;
                }
                
                if (userId == null) {
                  print('Error: userId is null');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('User session error. Please log in again.')),
                  );
                  return;
                }

                final res = await api.addCompany({
                  'user_id': userId,
                  'company_name': nameCtrl.text,
                  'email': searchedEmail ?? "",
                  'contact': searchedContact ?? "",
                });

                print('Add Company Response: $res');

                if (res['success']) {
                  if (mounted) {
                    Navigator.pop(context);
                    _loadData();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Company added successfully!'), backgroundColor: Colors.green),
                    );
                  }
                } else {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(res['message'] ?? 'Failed to add company'), backgroundColor: Colors.redAccent),
                    );
                  }
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    ).then((_) => debounce?.cancel());
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {String? tag, Color? tagColor}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.indigo.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.indigo),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                    if (tag != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: (tagColor ?? Colors.grey).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          tag.toUpperCase(),
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: tagColor),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Companies')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : companies.isEmpty
              ? const Center(child: Text('No companies added yet.'))
              : ListView.builder(
                  itemCount: companies.length,
                  itemBuilder: (context, index) {
                    final company = companies[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        title: Text(company.companyName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${company.email ?? ""}\n${company.contact ?? ""}'),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () async {
                            final res = await api.deleteCompany(company.id!);
                            if (res['success']) _loadData();
                          },
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
