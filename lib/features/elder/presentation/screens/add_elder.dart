import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heraguard_frontend/core/widgets/appbar_widget.dart';
import 'package:heraguard_frontend/core/widgets/custom_button.dart';
import 'package:heraguard_frontend/core/widgets/custom_text_field.dart';
import 'package:heraguard_frontend/core/widgets/navbar_bottom.dart';

class AddElder extends StatefulWidget {
  const AddElder({super.key});

  @override
  State<AddElder> createState() => _AddElderState();
}

class _AddElderState extends State<AddElder> {
  late TextEditingController _codeController;

  @override
  void initState() {
    super.initState();
    _codeController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _codeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(title: 'Agregar Paciente'),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(
                  'Ingresa el código',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  'Escribe el código de 6 caractéres que te compartió tu paciente',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 250,
                  child: CustomTextField(
                    controller: _codeController,
                    label: 'Código de vinculación',
                    icon: Icons.person_search,
                    keyboardType: TextInputType.text,
                    maxLength: 6,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(6),
                      FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                      TextInputFormatter.withFunction(
                        (oldValue, newValue) => TextEditingValue(
                          text: newValue.text.toUpperCase(),
                          selection: newValue.selection,
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(height: 50),
                CustomButton(
                  text: 'Vincular',
                  onPressed: _codeController.text.length == 6
                      ? () {
                          print('Código: ${_codeController.text}');
                        }
                      : null,
                  width: 250,
                  height: 60,
                  fontSize: 22,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavbarBottom(),
    );
  }
}
