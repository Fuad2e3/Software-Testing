import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
  List<Company> filteredCompanies = [];
  bool isLoading = true;
  int? userId;
  final TextEditingController searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
    searchCtrl.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      filteredCompanies = companies
          .where((c) => c.companyName.toLowerCase().contains(searchCtrl.text.toLowerCase()))
          .toList();
    });
  }

  Future<void> _loadData() async {
    userId = await api.getUserId();
    if (userId != null) {
      final data = await api.getCompanies(userId!);
      setState(() {
        companies = data.map((e) => Company.fromJson(e)).toList();
        filteredCompanies = companies;
        isLoading = false;
      });
    }
  }

  void _showAddDialog() {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final contactCtrl = TextEditingController();
    final websiteCtrl = TextEditingController(); // Added controller for Website
    String? verificationStatus;
    bool isPhoneValid = false;
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
                    labelText: 'Company Name or Website URL',
                    hintText: 'e.g. Facebook or facebook.com',
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
                            websiteCtrl.text = result['website'] ?? ""; // Auto-fill website box
                            verificationStatus = result['verification']?['status'];
                            isPhoneValid = result['isPhoneValid'] ?? false;
                          }
                        });
                      } else {
                        // Reset everything if input is cleared
                        setDialogState(() {
                          emailCtrl.clear();
                          contactCtrl.clear();
                          websiteCtrl.clear();
                          verificationStatus = null;
                          isPhoneValid = false;
                          isSearching = false;
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
                // Website Field (Visible and Editable)
                const SizedBox(height: 8),
                const Text('Company Website', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.indigo)),
                const SizedBox(height: 4),
                TextField(
                  controller: websiteCtrl,
                  decoration: InputDecoration(
                    hintText: 'e.g. facebook.com',
                    prefixIcon: const Icon(Icons.language_rounded, size: 20, color: Colors.indigo),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                // Email Field (Editable)
                const Text('Email Address', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.indigo)),
                const SizedBox(height: 4),
                TextField(
                  controller: emailCtrl,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined, size: 20),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: verificationStatus == 'deliverable' 
                          ? Colors.green 
                          : (verificationStatus == null ? Colors.grey.shade300 : Colors.orange),
                        width: 2,
                      ),
                    ),
                    suffixIcon: verificationStatus != null
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              verificationStatus == 'deliverable' ? 'VERIFIED ' : 'RISKY ',
                              style: TextStyle(color: verificationStatus == 'deliverable' ? Colors.green : Colors.orange, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              verificationStatus == 'deliverable' ? Icons.check_circle : Icons.warning_amber_rounded,
                              color: verificationStatus == 'deliverable' ? Colors.green : Colors.orange,
                            ),
                            const SizedBox(width: 8),
                          ],
                        )
                      : null,
                  ),
                ),
                const SizedBox(height: 16),
                // Contact Number Field (Editable)
                const Text('Contact Number', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.indigo)),
                const SizedBox(height: 4),
                TextField(
                  controller: contactCtrl,
                  onChanged: (val) {
                    setDialogState(() {
                      isPhoneValid = val.length >= 7 && RegExp(r'^[0-9\-+ \s()]+$').hasMatch(val);
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone_android_outlined, size: 20),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: isPhoneValid ? Colors.green : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                    suffixIcon: isPhoneValid 
                      ? const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('VALID ', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                            Icon(Icons.check_circle, color: Colors.green),
                            const SizedBox(width: 8),
                          ],
                        )
                      : null,
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
                  'website': websiteCtrl.text, // Use the value from the editable website box
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
      appBar: AppBar(
        title: const Text('Directory', style: TextStyle(fontWeight: FontWeight.w900)),
        surfaceTintColor: Colors.transparent,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: searchCtrl,
                    decoration: InputDecoration(
                      hintText: 'Search companies...',
                      prefixIcon: const Icon(Icons.search, color: Colors.blueGrey),
                      filled: true,
                      fillColor: Colors.blueGrey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: filteredCompanies.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredCompanies.length,
                          itemBuilder: (context, index) {
                            final company = filteredCompanies[index];
                            return _buildCompanyCard(company);
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_business_rounded),
        label: const Text('Add New'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.business_center_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            companies.isEmpty ? 'No companies yet' : 'No matches found',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            companies.isEmpty 
                ? 'Tap "Add New" to get started' 
                : 'Try a different search term',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyCard(Company company) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo Placeholder
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF1E3A8A).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  company.companyName[0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E3A8A),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          company.companyName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final res = await api.deleteCompany(company.id!);
                          if (res['success']) _loadData();
                        },
                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 20),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  // Email Row
                  _buildContactItem(
                    Icons.email_rounded,
                    company.email ?? "",
                    onTap: () => launchUrl(Uri.parse('mailto:${company.email}')),
                  ),
                  const SizedBox(height: 8),
                  // Phone Row
                  _buildContactItem(
                    Icons.phone_rounded,
                    company.contact ?? "No Contact",
                    color: Colors.black87,
                  ),
                  if (company.website != null && company.website!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () => launchUrl(Uri.parse('https://${company.website}')),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.indigo.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.indigo.withOpacity(0.2)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.language_rounded, size: 16, color: Colors.indigo),
                            const SizedBox(width: 8),
                            Text(
                              company.website!,
                              style: const TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text, {VoidCallback? onTap, Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.blueGrey[200]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: color ?? const Color(0xFF1E3A8A),
                fontWeight: color != null ? FontWeight.w500 : FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
