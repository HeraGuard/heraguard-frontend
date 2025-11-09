import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:heraguard_frontend/core/providers/auth_provider.dart';
import 'package:heraguard_frontend/core/routes/app_routes.dart';
import 'package:heraguard_frontend/core/widgets/appbar_widget.dart';
import 'package:heraguard_frontend/core/widgets/custom_button.dart';
import 'package:heraguard_frontend/core/widgets/custom_text_field.dart';
import 'package:heraguard_frontend/core/widgets/navbar_bottom.dart';
import 'package:heraguard_frontend/features/elder/presentation/bloc/elder_bloc.dart';

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

  int _convertRoleToTypeId(String? role) {
    switch (role?.toLowerCase()) {
      case 'caregiver':
        return 2;
      case 'doctor':
        return 3;
      default:
        return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<ElderBloc>(),
      child: Scaffold(
        appBar: AppbarWidget(title: 'Agregar Paciente'),
        body: BlocListener<ElderBloc, ElderState>(
          listener: (context, state) {
            if (state is ElderLinkSuccess) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.elderList,
                (route) => false,
              );
            } else if (state is ElderError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Código de vinculación inválido',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text(
                      'Ingresa el código',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[A-Za-z0-9]'),
                          ),
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
                    BlocBuilder<ElderBloc, ElderState>(
                      builder: (context, state) {
                        return CustomButton(
                          text: state is ElderLoading
                              ? 'Vinculando...'
                              : 'Vincular',
                          onPressed:
                              _codeController.text.length == 6 &&
                                  state is! ElderLoading
                              ? () {
                                  final authProvider =
                                      Provider.of<AuthProvider>(
                                        context,
                                        listen: false,
                                      );
                                  final userId = authProvider.authData?.user.id;
                                  final userType = _convertRoleToTypeId(
                                    authProvider.authData?.user.role,
                                  );

                                  context.read<ElderBloc>().add(
                                    LinkElder(
                                      _codeController.text,
                                      userId!,
                                      userType,
                                    ),
                                  );
                                }
                              : null,
                          width: 250,
                          height: 60,
                          fontSize: 22,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: NavbarBottom(),
      ),
    );
  }
}
