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
    'address': 'Ariana, Tunisia',
    'dateOfBirth': '02/08/1998',
    'userStatus': 'Active',
    'createdAt': '09/03/2025',
    'lastLogin': '2024-03-09 14:30',
    'skills': ['Flutter', 'Dart', 'System Administration'],
    'certifications': ['Google Cloud Certified', 'AWS Solutions Architect'],
    'language': 'English',
    'timezone': 'GMT+1',
  };

  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _departmentController;
  late TextEditingController _addressController;
  late TextEditingController _dobController;
  late TextEditingController _languageController;
  late TextEditingController _timezoneController;

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
    _languageController = TextEditingController(text: userData['language']);
    _timezoneController = TextEditingController(text: userData['timezone']);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _departmentController.dispose();
    _addressController.dispose();
    _dobController.dispose();
    _languageController.dispose();
    _timezoneController.dispose();
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
        userData['language'] = _languageController.text;
        userData['timezone'] = _timezoneController.text;
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
      _phoneController.text = _originalData['phone'];
      _departmentController.text = _originalData['departmentName'];
      _addressController.text = _originalData['address'];
      _dobController.text = _originalData['dateOfBirth'];
      _languageController.text = _originalData['language'];
      _timezoneController.text = _originalData['timezone'];
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF0CC0DF); // Bright cyan
    const Color accentColor = Color(0xFF01579B); // Deep blue
    const Color textColor = Color(0xFF212121); // Dark grey

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;
        final bool isTablet = constraints.maxWidth < 900;

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isMobile ? double.infinity : 900),
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 16.0 : 32.0),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(isMobile ? 20.0 : 40.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with Avatar and Actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: isMobile ? 30 : 40,
                                  backgroundColor: primaryColor.withOpacity(0.1),
                                  child: Text(
                                    userData['fullName'][0].toUpperCase(),
                                    style: TextStyle(
                                      fontSize: isMobile ? 24 : 32,
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                                SizedBox(width: isMobile ? 12 : 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userData['fullName'],
                                      style: TextStyle(
                                        fontSize: isMobile ? 24 : 16,
                                        fontWeight: FontWeight.w700,
                                        color: accentColor,
                                      ),
                                    ),
                                    Text(
                                      userData['departmentName'],
                                      style: TextStyle(
                                        fontSize: isMobile ? 14 : 18,
                                        color: Colors.grey.shade600,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: Icon(_isEditing ? Icons.save : Icons.edit, size: isMobile ? 24 : 28),
                                color: primaryColor,
                                onPressed: _toggleEditMode,
                                tooltip: _isEditing ? 'Save Changes' : 'Edit Profile',
                                hoverColor: primaryColor.withOpacity(0.2),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isMobile ? 16 : 32),
                        Divider(color: Colors.grey.shade200, thickness: 1.5),

                        // Personal Information
                        _buildSectionHeader('Personal Information', accentColor, isMobile),
                        SizedBox(height: isMobile ? 12 : 20),
                        _buildFieldRow('Full Name', _fullNameController, primaryColor, textColor, isMobile),
                        _buildFieldRow('Email', _emailController, primaryColor, textColor, isMobile),
                        _buildFieldRow('Phone', _phoneController, primaryColor, textColor, isMobile),
                        _buildFieldRow('Department', _departmentController, primaryColor, textColor, isMobile),
                        _buildFieldRow('Address', _addressController, primaryColor, textColor, isMobile),
                        _buildFieldRow('Date of Birth', _dobController, primaryColor, textColor, isMobile),

                        // Security & Status
                        SizedBox(height: isMobile ? 24 : 40),
                        _buildSectionHeader('Security & Status', accentColor, isMobile),
                        SizedBox(height: isMobile ? 12 : 20),
                        _buildTextRow('Status', userData['userStatus'], primaryColor, textColor, isMobile),
                        _buildTextRow('Joined', userData['createdAt'].substring(0, 10), primaryColor, textColor, isMobile),

                        // Recent Activity
                        SizedBox(height: isMobile ? 24 : 40),
                        _buildSectionHeader('Recent Activity', accentColor, isMobile),
                        SizedBox(height: isMobile ? 12 : 20),
                        _buildTextRow('Last Login', userData['lastLogin'], primaryColor, textColor, isMobile),

                        SizedBox(height: isMobile ? 24 : 48),

                        // Action Buttons
                        if (_isEditing)
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            padding: EdgeInsets.only(top: isMobile ? 12 : 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedButton(
                                  onPressed: _cancelEdit,
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.grey.shade700,
                                    side: BorderSide(color: Colors.grey.shade400, width: 1.5),
                                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32, vertical: isMobile ? 10 : 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(fontSize: isMobile ? 14 : 16, fontWeight: FontWeight.w600),
                                  ),
                                ),
                                SizedBox(width: isMobile ? 12 : 20),
                                ElevatedButton(
                                  onPressed: _toggleEditMode,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 32, vertical: isMobile ? 10 : 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    elevation: 6,
                                    shadowColor: primaryColor.withOpacity(0.3),
                                  ),
                                  child: Text(
                                    'Save Changes',
                                    style: TextStyle(fontSize: isMobile ? 14 : 16, fontWeight: FontWeight.w600),
                                  ),
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
      },
    );
  }

  Widget _buildFieldRow(String label, TextEditingController controller, Color primaryColor, Color textColor, bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 12),
      child: _isEditing
          ? TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: primaryColor.withOpacity(0.8), fontWeight: FontWeight.w500),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 20, vertical: isMobile ? 12 : 16),
          hoverColor: primaryColor.withOpacity(0.05),
        ),
        style: TextStyle(fontSize: isMobile ? 14 : 16, color: textColor, fontWeight: FontWeight.w500),
      )
          : _buildTextRow(label, controller.text, primaryColor, textColor, isMobile),
    );
  }

  Widget _buildTextRow(String label, String value, Color primaryColor, Color textColor, bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: isMobile ? 100 : 180,
            child: Text(
              label,
              style: TextStyle(
                fontSize: isMobile ? 14 : 15,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color accentColor, bool isMobile) {
    return Padding(
      padding: EdgeInsets.only(top: isMobile ? 16 : 24, bottom: isMobile ? 8 : 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: isMobile ? 20 : 24,
            color: accentColor,
            margin: EdgeInsets.only(right: isMobile ? 8 : 12),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: isMobile ? 20 : 24,
              fontWeight: FontWeight.w700,
              color: accentColor,
            ),
          ),
        ],
      ),
    );
  }
}