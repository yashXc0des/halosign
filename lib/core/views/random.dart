import 'package:esign/core/providers/aggrement_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class randomvala extends ConsumerWidget {
  const randomvala({super.key});

  @override
  
  Widget build(BuildContext context, WidgetRef ref) {
   final currentUserEmail= ref.watch(currentUserEmailProvider);
    return Scaffold(
      body: Center(
        child: Text(
          currentUserEmail !=null?'Email: $currentUserEmail' : 'Not logged in',
          style: TextStyle(fontSize: 20),
        ),
      ),
    ) ;
  }
}
