import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/agreement.dart';
import '../../providers/aggrement_provider.dart';

class AgreementDetailsPage extends ConsumerStatefulWidget {
  final Agreement agreement;

  AgreementDetailsPage({required this.agreement});

  @override
  _AgreementDetailsPageState createState() => _AgreementDetailsPageState();
}

class _AgreementDetailsPageState extends ConsumerState<AgreementDetailsPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Agreement Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${widget.agreement.title}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Description: ${widget.agreement.description}'),
            SizedBox(height: 10),
            Text('Status: ${widget.agreement.status}'),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    print('Reject button pressed');
                    await ref.read(agreementsProvider.notifier).rejectAgreement(ref as Ref<Object?>, widget.agreement.id);
                    Navigator.pop(context);
                  },
                  child: Text('Reject'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    print('Open PDF button pressed');
                    setState(() {
                      isLoading = true; // Start loading
                    });
                    await ref.read(agreementsProvider.notifier).openPdf(widget.agreement.pdfUrl!);
                    setState(() {
                      isLoading = false; // Stop loading
                    });
                  },
                  child: Text('Open PDF'),
                ),
              ],
            ),
            if (isLoading) // Show loader if isLoading is true
              Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
