import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:halosign/views/dashboard/admin_dashboard/selectuser_screen.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../../core/models/agreement.dart';
import '../../../core/providers/aggrement_service_provider.dart';
import '../../../core/services/authentication.dart';
import '../../../core/services/cloudflare_r2_service.dart';

class NewAgreementScreen extends ConsumerStatefulWidget {
  @override
  _NewAgreementScreenState createState() => _NewAgreementScreenState();
}

class _NewAgreementScreenState extends ConsumerState<NewAgreementScreen> {
  File? _selectedFile;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _validFromController = TextEditingController();
  final TextEditingController _validUntilController = TextEditingController();
  List<String> _selectedSignatories = [];
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Set the "Valid From" date to the current date
    _validFromController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _selectSignatories() async {
    final selectedUsers = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectUsersScreen(selectedUsers: _selectedSignatories)),
    );
    if (selectedUsers != null) {
      setState(() {
        _selectedSignatories = selectedUsers;
      });
    }
  }

  Future<void> _pickValidFromDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              onSurface: Colors.deepPurple.shade900,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.deepPurple,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      setState(() {
        _validFromController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  Future<void> _pickValidUntilDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              onSurface: Colors.deepPurple.shade900,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.deepPurple,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      setState(() {
        _validUntilController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  Future<void> _uploadAndCreateAgreement() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedFile == null) {
        _showErrorSnackBar('Please select a PDF file');
        return;
      }

      if (_selectedSignatories.isEmpty) {
        _showErrorSnackBar('Please select at least one signatory');
        return;
      }

      try {
        setState(() {
          _isLoading = true;
        });

        // Show loading indicator
        _showLoadingDialog();

        // Upload PDF to Cloudflare R2
        final pdfUploadNotifier = PDFUploadNotifier();
        final pdfUrl = await pdfUploadNotifier.uploadPDF(_selectedFile!);

        if (pdfUrl == null) {
          throw Exception('PDF upload failed');
        }

        // Dismiss loading indicator
        Navigator.of(context).pop();

        // Get current user
        final user = AuthenticationService().currentUser;

        // Parse validFrom and validUntil dates
        DateTime? validFrom;
        DateTime? validUntil;
        if (_validFromController.text.isNotEmpty) {
          validFrom = DateTime.tryParse(_validFromController.text);
        }
        if (_validUntilController.text.isNotEmpty) {
          validUntil = DateTime.tryParse(_validUntilController.text);
        }

        // Create agreement object
        final newAgreement = Agreement(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
          createdBy: user!.uid,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          status: AgreementStatus.draft,
          signatories: _selectedSignatories,
          signedBy: [], // Empty initially
          pdfUrl: pdfUrl,
          validFrom: validFrom, // Set this field
          validUntil: validUntil, // Set this field
        );

        // Save to Firestore
        final agreementService = ref.read(agreementServiceProvider);
        await agreementService.createAgreement(newAgreement);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Agreement created successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Navigate back
        Navigator.of(context).pop();
      } catch (e) {
        // Dismiss loading dialog if it's showing
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
        _showErrorSnackBar('Error: ${e.toString()}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset("assets/lottie/upload_lotte.json"),
            SizedBox(height: 20),
            Text(
              'Uploading agreement...',
              style: TextStyle(fontFamily: 'Montserrat'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create New Agreement",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white,
            ],
          ),
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader("Agreement Information"),
                SizedBox(height: 16),
                _buildInputField(
                  controller: _titleController,
                  labelText: "Agreement Title",
                  prefixIcon: Icons.title,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                _buildInputField(
                  controller: _descriptionController,
                  labelText: "Description",
                  prefixIcon: Icons.description,
                  maxLines: 3,
                ),
                SizedBox(height: 24),

                _buildSectionHeader("Document"),
                SizedBox(height: 16),
                _buildDocumentSelector(),
                SizedBox(height: 24),

                _buildSectionHeader("Signatories"),
                SizedBox(height: 16),
                _buildSignatoriesSelector(),
                SizedBox(height: 24),

                _buildSectionHeader("Validity Period"),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildDateField(
                        controller: _validFromController,
                        labelText: "Valid From",
                        prefixIcon: Icons.calendar_today,
                        onTap: _pickValidFromDate,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildDateField(
                        controller: _validUntilController,
                        labelText: "Valid Until",
                        prefixIcon: Icons.event,
                        onTap: _pickValidUntilDate,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32),

                _buildSubmitButton(),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple.shade800,
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: 50,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          fontFamily: 'Montserrat',
          color: Colors.deepPurple.shade300,
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: Colors.deepPurple,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurple.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurple.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurple, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      maxLines: maxLines,
      validator: validator,
      style: TextStyle(fontFamily: 'Montserrat'),
    );
  }

  Widget _buildDocumentSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple.shade200),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.file_present,
              color: Colors.deepPurple,
              size: 28,
            ),
            title: Text(
              "Agreement Document",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: _selectedFile != null
                ? Text(
              _selectedFile!.path.split('/').last,
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.green.shade700,
              ),
            )
                : Text(
              "No PDF selected",
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.red.shade300,
              ),
            ),
            trailing: ElevatedButton.icon(
              onPressed: _pickFile,
              icon: Icon(Icons.upload_file),
              label: Text(_selectedFile == null ? "Select" : "Change"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignatoriesSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple.shade200),
      ),
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.people,
              color: Colors.deepPurple,
              size: 28,
            ),
            title: Text(
              "Agreement Signatories",
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: _selectedSignatories.isNotEmpty
                ? Text(
              "${_selectedSignatories.length} signatories selected",
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.green.shade700,
              ),
            )
                : Text(
              "No signatories selected",
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: Colors.red.shade300,
              ),
            ),
            trailing: ElevatedButton.icon(
              onPressed: _selectSignatories,
              icon: Icon(Icons.person_add),
              label: Text("Select"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          if (_selectedSignatories.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _selectedSignatories.map((signatory) {
                  return Chip(
                    label: Text(
                      signatory.split('@').first,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    backgroundColor: Colors.deepPurple.shade600,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    required VoidCallback onTap,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          fontFamily: 'Montserrat',
          color: Colors.deepPurple.shade300,
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: Colors.deepPurple,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurple.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurple.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurple, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      readOnly: true,
      onTap: onTap,
      validator: validator,
      style: TextStyle(fontFamily: 'Montserrat'),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : _uploadAndCreateAgreement,
        icon: _isLoading
            ? SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : Icon(Icons.cloud_upload,color: Colors.white,),
        label: Text(
          _isLoading ? "Processing..." : "Create Agreement",
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }
}