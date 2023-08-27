import 'package:auth_with_provider/models/user/user.dart';
import 'package:auth_with_provider/providers/auth_provider.dart';
import 'package:auth_with_provider/providers/memo_provider.dart';
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
        actions: [
          IconButton(
            onPressed: () {
              context.push('/create-memo');
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Consumer2<AuthProvider, MemoProvider>(
        builder: (context, authProvider, memo, _) {
          return RefreshIndicator(
            onRefresh: () async {
              await memo.refreshMemo(authProvider.user.id);
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
                            Provider.of<MemoProvider>(context).getMemo(user.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            if (snapshot.hasData && snapshot.data != null) {
                              final memo = snapshot.data!;
                              return RefreshIndicator(
                                onRefresh: () async {
                                  await Provider.of<UsersListProvider>(context,
                                          listen: false)
                                      .refreshUsers();
                                },
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: memo.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      onTap: () {
                                        context.push(
                                            '/detail/${memo[index].id}',
                                            extra: memo[index]);
                                      },
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            memo[index].userAvatar),
                                      ),
                                      title: Text(memo[index].title),
                                      subtitle: Text(memo[index].content),
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
