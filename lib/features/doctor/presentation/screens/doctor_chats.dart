import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:heraguard_frontend/core/widgets/navbar_bottom.dart';
import 'package:heraguard_frontend/features/chat/domain/entities/patient_chat_entity.dart';
import 'package:heraguard_frontend/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:heraguard_frontend/features/chat/presentation/screens/chat_conversation.dart';
import 'package:heraguard_frontend/features/elder/domain/entities/elder.dart';
import 'package:heraguard_frontend/features/elder/presentation/bloc/elder_bloc.dart';
import 'package:provider/provider.dart';
import 'package:heraguard_frontend/core/providers/auth_provider.dart';

class DoctorChats extends StatelessWidget {
  const DoctorChats({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<ElderBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Chats')),
        body: const _DoctorChatsBody(),
        bottomNavigationBar: const NavbarBottom(),
      ),
    );
  }
}

class _DoctorChatsBody extends StatefulWidget {
  const _DoctorChatsBody();

  @override
  State<_DoctorChatsBody> createState() => __DoctorChatsBodyState();
}

class __DoctorChatsBodyState extends State<_DoctorChatsBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.authData?.user.id;
      final userType = authProvider.authData?.user.role;
      final int typeId = _convertRoleToTypeId(userType);
      context.read<ElderBloc>().add(LoadEldersByUser(userId!, typeId));
    });
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
    return BlocBuilder<ElderBloc, ElderState>(
      builder: (context, state) {
        if (state is ElderLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ElderError) {
          return _buildEmptyState();
        } else if (state is ElderLoaded) {
          if (state.elders.isEmpty) {
            return _buildEmptyState();
          }
          return _buildElderList(state.elders);
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.chat_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'No tienes pacientes para chatear',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildElderList(List<Elder> elders) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentUserId = authProvider.authData?.user.id ?? '';

    return ListView.builder(
      itemCount: elders.length,
      itemBuilder: (context, index) {
        final elder = elders[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey.shade300,
            child: const Icon(Icons.person, color: Colors.blue),
          ),
          title: Text('${elder.name} ${elder.lastName}'),
          subtitle: Text(elder.email),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => GetIt.instance<ChatBloc>(),
                  child: ChatConversationPage(
                    patient: PatientChatEntity(
                      id: elder.id,
                      fullName: '${elder.name} ${elder.lastName}',
                      email: elder.email,
                      conversationId: '${currentUserId}_${elder.id}',
                    ),
                    currentUserId: currentUserId,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
