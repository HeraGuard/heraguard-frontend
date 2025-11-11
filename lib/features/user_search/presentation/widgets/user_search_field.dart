import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heraguard_frontend/features/auth/data/models/auth_response.dart';
import 'package:heraguard_frontend/core/utils/input_decoration_helper.dart';
import 'package:heraguard_frontend/core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/user_search_bloc.dart';
import '../bloc/user_search_event.dart';
import '../bloc/user_search_state.dart';

class UserSearchField extends StatefulWidget {
  final int roleId;
  final Function(User) onUserSelected;
  final InputDecoration? decoration;

  const UserSearchField({
    Key? key,
    required this.roleId,
    required this.onUserSelected,
    this.decoration,
  }) : super(key: key);

  @override
  State<UserSearchField> createState() => _UserSearchFieldState();
}

class _UserSearchFieldState extends State<UserSearchField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration:
              widget.decoration ??
              InputDecorationHelper.customDecoration(
                hint: 'Buscar usuario...',
                icon: Icons.search,
              ),
          onChanged: (query) {
            context.read<UserSearchBloc>().add(
              SearchUsersEvent(query: query, roleId: widget.roleId),
            );
          },
        ),
        const SizedBox(height: 8),
        BlocBuilder<UserSearchBloc, UserSearchState>(
          builder: (context, state) {
            if (state is UserSearchLoading) {
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
              );
            }

            if (state is UserSearchLoaded) {
              return Container(
                constraints: const BoxConstraints(maxHeight: 200),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      final user = state.users[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primaryBlue,
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                        title: Text(
                          '${user.name} ${user.lastName}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          user.email,
                          style: GoogleFonts.roboto(color: Colors.grey[600]),
                        ),
                        onTap: () {
                          widget.onUserSelected(user);
                          _controller.text = '${user.name} ${user.lastName}';
                          context.read<UserSearchBloc>().add(
                            ClearSearchEvent(),
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            }

            if (state is UserSearchEmpty) {
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'No se encontraron usuarios',
                    style: GoogleFonts.roboto(color: Colors.grey[600]),
                  ),
                ),
              );
            }

            if (state is UserSearchError) {
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Error: ${state.message}',
                    style: GoogleFonts.roboto(color: AppColors.accentRed),
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
