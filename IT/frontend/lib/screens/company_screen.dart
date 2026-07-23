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
    final emailCtrl = TextEditingController();
    final contactCtrl = TextEditingController();
    String? verificationStatus;
    bool isSearching = false;
    Timer? debounce;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Add Company', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
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
                            emailCtrl.text = result['email'] ?? "";
                            contactCtrl.text = result['contact'] ?? "";
                            verificationStatus = result['verification']?['status'];
                          }
                        });
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                if (isSearching)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Center(child: Text('Searching & Verifying...', style: TextStyle(fontSize: 12, color: Colors.indigo))),
                  ),
                // Email Field (Editable)
                TextField(
                  controller: emailCtrl,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: const Icon(Icons.email_outlined, size: 20),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: verificationStatus == 'deliverable' 
                          ? Colors.green 
                          : (verificationStatus == null ? Colors.transparent : Colors.orange),
                        width: 2,
                      ),
                    ),
                    suffixIcon: verificationStatus != null
                      ? Icon(
                          verificationStatus == 'deliverable' ? Icons.check_circle : Icons.warning_amber_rounded,
                          color: verificationStatus == 'deliverable' ? Colors.green : Colors.orange,
                        )
                      : null,
                  ),
                ),
                const SizedBox(height: 16),
                // Contact Field (Editable)
                TextField(
                  controller: contactCtrl,
                  decoration: InputDecoration(
                    labelText: 'Contact Number',
                    prefixIcon: const Icon(Icons.phone_android_outlined, size: 20),
                  ),
                ),
              ],
            ),
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
                if (nameCtrl.text.isEmpty) {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a company name')));
                  return;
                }
                
                final res = await api.addCompany({
                  'user_id': userId,
                  'company_name': nameCtrl.text,
                  'email': emailCtrl.text,
                  'contact': contactCtrl.text,
                });

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
