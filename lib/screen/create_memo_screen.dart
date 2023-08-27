import 'package:auth_with_provider/providers/auth_provider.dart';
import 'package:auth_with_provider/providers/memo_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CreateMemoScreen extends StatelessWidget {
  CreateMemoScreen({super.key});

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final createMemo = Provider.of<MemoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Memo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'Enter title',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      labelText: 'Content',
                      hintText: 'Enter content',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 10,
                  ),
                  const SizedBox(height: 16.0),
                  FilledButton.tonalIcon(
                      onPressed: () async {
                        var user =
                            Provider.of<AuthProvider>(context, listen: false)
                                .user;
                        await createMemo.createMemo(
                          userid: user.id,
                          userName: user.name,
                          userAvatar: user.avatar,
                          title: _titleController.text,
                          content: _contentController.text,
                        );
                        context.pop();
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('save'))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
