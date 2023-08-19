import 'package:auth_with_provider/models/user.dart';
import 'package:auth_with_provider/providers/auth_provider.dart';
import 'package:auth_with_provider/providers/user_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({Key? key, required this.user}) : super(key: key);
  static const String routeName = '/home';
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        centerTitle: true,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return RefreshIndicator(
            onRefresh: () async {
              await authProvider.refreshUser();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SafeArea(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      authProvider.user.avatar != ''
                          ? CircleAvatar(
                              backgroundImage:
                                  NetworkImage(authProvider.user.avatar),
                              radius: 50,
                            )
                          : const CircleAvatar(
                              radius: 50,
                              child: Icon(Icons.person),
                            ),
                      authProvider.user.name != ''
                          ? Text(
                              'Welcome ${authProvider.user.name}',
                              style: Theme.of(context).textTheme.titleLarge,
                            )
                          : Text(
                              'Scroll to refresh',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          authProvider.signOut();
                          context.go('/');
                        },
                        child: const Text('Sign Out'),
                      ),
                      const SizedBox(height: 16.0),
                      const Text('All Users'),
                      StreamBuilder(
                        stream:
                            Provider.of<UsersListProvider>(context).usersStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            if (snapshot.hasData && snapshot.data != null) {
                              final users = snapshot.data!;
                              return RefreshIndicator(
                                onRefresh: () async {
                                  await Provider.of<UsersListProvider>(context,
                                          listen: false)
                                      .refreshUsers();
                                },
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: users.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(users[index].avatar),
                                      ),
                                      title: Text(users[index].name),
                                      subtitle: Text(users[index].email),
                                    );
                                  },
                                ),
                              );
                            } else {
                              return const Center(
                                child: Text('No Users Found'),
                              );
                            }
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return const Center(
                            child: Text('No Users Found'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
