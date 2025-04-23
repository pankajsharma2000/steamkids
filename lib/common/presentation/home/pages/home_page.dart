import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steamkids/common/providers/user_provider.dart';
import 'package:steamkids/common/widgets/user_list_widget.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userStream = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: userStream.when(
        data: (users) => UserListWidget(users: users),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}