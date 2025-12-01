import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:heraguard_frontend/core/widgets/appbar_widget.dart';
import 'package:heraguard_frontend/core/widgets/navbar_bottom.dart';
import 'package:heraguard_frontend/features/chat/domain/entities/patient_chat_entity.dart';
import 'package:heraguard_frontend/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:heraguard_frontend/features/chat/presentation/screens/chat_conversation.dart';
import 'package:heraguard_frontend/features/elder/domain/entities/elder.dart';
import 'package:heraguard_frontend/features/elder/presentation/bloc/elder_bloc.dart';
import 'package:provider/provider.dart';
import 'package:heraguard_frontend/core/providers/auth_provider.dart';

class ElderChats extends StatelessWidget {
  const ElderChats({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<ElderBloc>(),
      child: Scaffold(
        appBar: AppbarWidget(title: 'Mis Doctores/Cuidadores'),
        body: const _ElderChatsBody(),
        bottomNavigationBar: const NavbarBottom(),
      ),
    );
  }
}

class _ElderChatsBody extends StatefulWidget {
  const _ElderChatsBody();

  @override
  State<_ElderChatsBody> createState() => __ElderChatsBodyState();
}

class __ElderChatsBodyState extends State<_ElderChatsBody> {
  int _selectedType = 3;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDoctors();
    });
  }

  void _loadDoctors() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.authData?.user.id;

    print('=== LOADING ELDER CHATS ===');
    print('UserId: $userId');
    print(
      'Type: $_selectedType (${_selectedType == 2 ? 'Caregivers' : 'Doctors'})',
    );

    context.read<ElderBloc>().add(LoadEldersByUser(userId!, _selectedType));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.grey[50],
          child: Row(
            children: [
              const Text(
                'Mostrar:',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 12),
              ChoiceChip(
                label: const Text('Doctores'),
                selected: _selectedType == 3,
                onSelected: (selected) {
                  setState(() {
                    _selectedType = 3;
                  });
                  _loadDoctors();
                },
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Cuidadores'),
                selected: _selectedType == 2,
                onSelected: (selected) {
                  setState(() {
                    _selectedType = 2;
                  });
                  _loadDoctors();
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: BlocBuilder<ElderBloc, ElderState>(
            builder: (context, state) {
              print('=== ELDER CHATS STATE: $state ===');

              if (state is ElderLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ElderError) {
                return _buildEmptyState('Error: ${state.message}');
              } else if (state is ElderLoaded) {
                print('=== ELDERS RECEIVED: ${state.elders.length} ===');
                if (state.elders.isEmpty) {
                  return _buildEmptyState(
                    'No tienes ${_selectedType == 2 ? 'cuidadores' : 'doctores'} asignados',
                  );
                }
                return _buildDoctorList(state.elders);
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _selectedType == 2
                ? Icons.health_and_safety
                : Icons.medical_services,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loadDoctors,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorList(List<Elder> doctors) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUserId = authProvider.authData?.user.id ?? '';

    return ListView.builder(
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        final doctor = doctors[index];
        if (doctor.id == currentUserId) {
          print('=== ERROR: Mostrando usuario actual en lugar del doctor ===');
          return Container();
        }

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Text(
                '${doctor.name[0]}${doctor.lastName[0]}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            title: Text(
              '${doctor.name} ${doctor.lastName}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(doctor.email),
            trailing: const Icon(Icons.chat, color: Colors.blue),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) => GetIt.instance<ChatBloc>(),
                    child: ChatConversationPage(
                      patient: PatientChatEntity(
                        id: doctor.id,
                        fullName: '${doctor.name} ${doctor.lastName}',
                        email: doctor.email,
                        conversationId: '',
                      ),
                      currentUserId: currentUserId,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
