import 'package:flutter/material.dart';
import 'package:flareline/pages/layout.dart';
import 'package:flareline/flutter_gen/app_localizations.dart';

class ProfilePage extends LayoutWidget {
  const ProfilePage({super.key});

  @override
  String breakTabTitle(BuildContext context) {
    return AppLocalizations.of(context)!.profile;
  }

  @override
  Widget contentDesktopWidget(BuildContext context) {
    return const _ProfileContent();
  }
}

class _ProfileContent extends StatefulWidget {
  const _ProfileContent();

  @override
  State<_ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<_ProfileContent> {
  Map<String, dynamic> userData = {
    'fullName': 'Houssem Meguebli',
    'email': 'megbli.houssam@gmail.com',
    'phone': '+216 55562933',
    'departmentName': 'IT',
    'address': 'Ariana,Tunisia',
    'dateOfBirth': '02/08/1998',
    'userStatus': 'Active',
    'createdAt': '09/03/2025',
    'lastLogin': '2024-03-09 14:30',
  };

  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _departmentController;
  late TextEditingController _addressController;
  late TextEditingController _dobController;

  bool _isEditing = false;
  Map<String, dynamic> _originalData = {};

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: userData['fullName']);
    _emailController = TextEditingController(text: userData['email']);
    _phoneController = TextEditingController(text: userData['phone']);
    _departmentController = TextEditingController(text: userData['departmentName']);
    _addressController = TextEditingController(text: userData['address']);
    _dobController = TextEditingController(text: userData['dateOfBirth']);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _departmentController.dispose();
    _addressController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      if (_isEditing) {
        userData['fullName'] = _fullNameController.text;
        userData['email'] = _emailController.text;
        userData['phone'] = _phoneController.text;
        userData['departmentName'] = _departmentController.text;
        userData['address'] = _addressController.text;
        userData['dateOfBirth'] = _dobController.text;
      } else {
        _originalData = Map.from(userData);
      }
      _isEditing = !_isEditing;
    });
  }

  void _cancelEdit() {
    setState(() {
      _fullNameController.text = _originalData['fullName'];
      _emailController.text = _originalData['email'];
      _phoneController.text = _phoneController.text;
      _departmentController.text = _originalData['departmentName'];
      _addressController.text = _originalData['address'];
      _dobController.text = _originalData['dateOfBirth'];
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0CC0DF); // #0cc0df

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: Card(
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 6,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.grey.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.profile,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        IconButton(
                          icon: Icon(_isEditing ? Icons.save : Icons.edit, size: 28),
                          color: primaryColor,
                          onPressed: _toggleEditMode,
                          tooltip: _isEditing ? 'Save Changes' : 'Edit Profile',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Divider(color: primaryColor.withOpacity(0.2), thickness: 1),

                    // Personal Information
                    _buildSectionHeader('Personal Information', primaryColor),
                    const SizedBox(height: 12),
                    _buildFieldRow('Full Name', _fullNameController, primaryColor),
                    _buildFieldRow('Email', _emailController, primaryColor),
                    _buildFieldRow('Phone', _phoneController, primaryColor),
                    _buildFieldRow('Department', _departmentController, primaryColor),
                    _buildFieldRow('Address', _addressController, primaryColor),
                    _buildFieldRow('Date of Birth', _dobController, primaryColor),

                    const SizedBox(height: 24),

                    // Security & Status
                    _buildSectionHeader('Security & Status', primaryColor),
                    const SizedBox(height: 12),
                    _buildTextRow('Status', userData['userStatus'], primaryColor),
                    _buildTextRow('Joined', userData['createdAt'].substring(0, 10), primaryColor),

                    const SizedBox(height: 24),

                    // Recent Activity
                    _buildSectionHeader('Recent Activity', primaryColor),
                    const SizedBox(height: 12),
                    _buildTextRow('Last Login', userData['lastLogin'], primaryColor),

                    const SizedBox(height: 32),

                    // Action Buttons with Animation
                    if (_isEditing)
                      AnimatedOpacity(
                        opacity: _isEditing ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: _cancelEdit,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.grey,
                                side: BorderSide(color: Colors.grey.shade400),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Cancel', style: TextStyle(fontSize: 16)),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: _toggleEditMode,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                              ),
                              child: const Text('Save', style: TextStyle(fontSize: 16)),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldRow(String label, TextEditingController controller, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: _isEditing
          ? TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: primaryColor.withOpacity(0.7)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryColor.withOpacity(0.5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        style: const TextStyle(fontSize: 16),
      )
          : _buildTextRow(label, controller.text, primaryColor),
    );
  }

  Widget _buildTextRow(String label, String value, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
    );
  }
}