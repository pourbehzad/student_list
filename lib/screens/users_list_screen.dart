import 'package:flutter/material.dart';
import 'package:student_list/models/user.dart';
import 'package:student_list/screens/user_edit_screen.dart';
import 'package:student_list/services/api_service.dart';
import 'package:student_list/widgets/user_list_item.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  ApiService apiService = ApiService();
  List<User> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    if (!mounted) return;

    setState(() {
      isLoading = true;
    });

    try {
      users = await apiService.getUsers();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error fetching data: $e')));
      }
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _navigateAndRefresh(Widget screen) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
    if (result == true) {
      loadUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.blueGrey))
          : users.isEmpty
          ? Center(
              child: Column(
                children: [
                  Icon(Icons.people_outline, color: Colors.blueGrey),
                  const SizedBox(height: 16),
                  Text(
                    'No Users Found!',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.blueGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap + button to add a new student',
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: loadUsers,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    title: Text('Student List'),
                    floating: true,
                    snap: true,
                    pinned: false,
                  ),
                  SliverPadding(
                    padding: EdgeInsets.only(bottom: bottomPadding + 100),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        childCount: users.length,
                        (context, index) {
                          final user = users[index];
                          return UserListItem(
                            user: user,
                            onTap: () {
                              _navigateAndRefresh(UserEditScreen(user: user,));
                            },
                            onDismissed: () {},
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: FloatingActionButton.extended(
            onPressed: () {
              _navigateAndRefresh(UserEditScreen());
            },
            icon: Icon(Icons.add),
            label: Text('Add Student'),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
