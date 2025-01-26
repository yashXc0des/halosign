import 'package:esign/core/models/agreement.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/aggrement_provider.dart';

class AgreementScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agreements = ref.watch(agreementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Agreements'),
      ),
      body: agreements.isEmpty
          ? Center(
        child: Text('No agreements found.'),
      )
          : SingleChildScrollView(
        child: Column(
          children: agreements.map((agreement) {
            return Card(
              margin: EdgeInsets.all(10),
              child: ListTile(
                title: Text(agreement.title),
                subtitle: Text(
                  'Status: ${agreement.status.description}',
                ),
                onTap: () {
                  // Handle tap, e.g., navigate to details
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
