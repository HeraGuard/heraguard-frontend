import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:heraguard_frontend/core/providers/auth_provider.dart';
import 'package:heraguard_frontend/core/routes/app_routes.dart';
import 'package:heraguard_frontend/core/widgets/appbar_widget.dart';
import 'package:heraguard_frontend/core/widgets/navbar_bottom.dart';
import 'package:heraguard_frontend/features/elder/domain/entities/elder.dart';
import 'package:heraguard_frontend/features/elder/presentation/bloc/elder_bloc.dart';
import 'package:provider/provider.dart';

class ElderList extends StatefulWidget {
  const ElderList({super.key});

  @override
  State<ElderList> createState() => _ElderListState();
}

class _ElderListState extends State<ElderList> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<ElderBloc>(),
      child: Scaffold(
        appBar: AppbarWidget(title: 'Pacientes'),
        body: _ElderListBody(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.addElder);
          },
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          child: Icon(Icons.person_add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        bottomNavigationBar: NavbarBottom(),
      ),
    );
  }
}

class _ElderListBody extends StatefulWidget {
  const _ElderListBody();

  @override
  State<_ElderListBody> createState() => __ElderListBodyState();
}

class __ElderListBodyState extends State<_ElderListBody> {
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
          return Center(child: CircularProgressIndicator());
        } else if (state is ElderError) {
          return _buildEmptyState();
        } else if (state is ElderLoaded) {
          if (state.elders.isEmpty) {
            return _buildEmptyState();
          }
          return _buildElderList(state.elders);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 80, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No tienes pacientes vinculados',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Presiona el botón + para agregar uno',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildElderList(List<Elder> elders) {
    return ListView.builder(
      itemCount: elders.length,
      itemBuilder: (context, index) {
        final elder = elders[index];
        return ListTile(
          leading: CircleAvatar(backgroundColor: Colors.grey.shade300,child: Icon(Icons.person, color: Colors.blue,),),
          title: Text('${elder.name} ${elder.lastName}'),
          subtitle: Text(elder.email),
          onTap: () {},
        );
      },
    );
  }
}
