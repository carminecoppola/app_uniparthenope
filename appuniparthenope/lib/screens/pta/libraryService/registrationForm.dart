import 'package:appuniparthenope/main.dart';
import 'package:appuniparthenope/widget/navbar.dart';
import 'package:flutter/material.dart';

import '../../../app_localizations.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _matricolaController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedDocumentType = '';

  late List<String> _documentTypes;

  @override
  void initState() {
    super.initState();
    // _documentTypes = [...] // Moved to build() method
  }

  bool get _isFormValid {
    return _nameController.text.isNotEmpty &&
        _surnameController.text.isNotEmpty &&
        _idController.text.isNotEmpty;
  }

  void _showWarning(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context).translate('registration_warning'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Load the localized strings in build() method instead of initState
    _documentTypes = [
      AppLocalizations.of(context).translate('document_type_identity_card'),
      AppLocalizations.of(context).translate('document_type_driver_license'),
      AppLocalizations.of(context).translate('document_type_passport'),
    ];
    _selectedDocumentType = _documentTypes.first;

    return Scaffold(
      appBar: const NavbarComponent(
        role: 'PTA',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Card(
          color: AppColors.backgroundColor,
          elevation: 15,
          margin: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Image.asset(
                  'assets/logo.png',
                  height: 70,
                ),
                const SizedBox(height: 5),
                Center(
                  child: Text(
                    AppLocalizations.of(context)
                        .translate('registration_title'),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: _buildInputDecoration(
                    AppLocalizations.of(context)
                        .translate('registration_name_label'),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _nameController.value = _nameController.value.copyWith(
                        text: _capitalize(value),
                        selection: TextSelection(
                          baseOffset: _nameController.text.length,
                          extentOffset: _nameController.text.length,
                        ),
                      );
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _surnameController,
                  decoration: _buildInputDecoration(
                    AppLocalizations.of(context)
                        .translate('registration_surname_label'),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _surnameController.value =
                          _surnameController.value.copyWith(
                        text: _capitalize(value),
                        selection: TextSelection(
                          baseOffset: _surnameController.text.length,
                          extentOffset: _surnameController.text.length,
                        ),
                      );
                    });
                  },
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedDocumentType,
                  decoration: _buildInputDecoration(
                    AppLocalizations.of(context)
                        .translate('registration_document_type_label'),
                  ),
                  items: _documentTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedDocumentType = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _idController,
                  decoration: _buildInputDecoration(
                    AppLocalizations.of(context)
                        .translate('registration_document_id_label'),
                  ),
                  textCapitalization: TextCapitalization.characters,
                  onChanged: (value) {
                    setState(() {
                      _idController.value = _idController.value.copyWith(
                        text: value.toUpperCase(),
                        selection: TextSelection(
                          baseOffset: value.length,
                          extentOffset: value.length,
                        ),
                      );
                    });
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _matricolaController,
                  decoration: _buildInputDecoration(
                    AppLocalizations.of(context)
                        .translate('registration_matricola_label'),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _phoneController,
                  decoration: _buildInputDecoration(
                    AppLocalizations.of(context)
                        .translate('registration_phone_label'),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _isFormValid
                      ? () {
                          // Aggiungi logica per registrare l'utente
                        }
                      : () {
                          _showWarning(context);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isFormValid ? AppColors.primaryColor : Colors.grey,
                  ),
                  child: Text(
                    AppLocalizations.of(context)
                        .translate('registration_button'),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: AppColors.primaryColor, fontSize: 12),
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primaryColor),
        borderRadius: BorderRadius.circular(10.0),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primaryColor),
      ),
    );
  }
}
