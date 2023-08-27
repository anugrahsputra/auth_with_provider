import 'package:auth_with_provider/models/user/user.dart';
import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  const Detail({super.key, required this.user, required this.id});
  static const routeName = '/detail:id';
  final String? id;
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail User'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                user!.avatar != ''
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(user!.avatar),
                        radius: 50,
                      )
                    : const CircleAvatar(
                        radius: 50,
                        child: Icon(Icons.person),
                      ),
                user!.name != ''
                    ? Text(
                        'Welcome ${user!.name}',
                        style: Theme.of(context).textTheme.titleLarge,
                      )
                    : Text(
                        'Scroll to refresh',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Back'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
