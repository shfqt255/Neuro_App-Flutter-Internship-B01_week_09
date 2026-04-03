import 'package:custom_buttons_app/custom_button.dart';
import 'package:flutter/material.dart';

class ButtonDemoScreen extends StatefulWidget {
  const ButtonDemoScreen({super.key});

  @override
  State<ButtonDemoScreen> createState() => _ButtonDemoScreenState();
}

class _ButtonDemoScreenState extends State<ButtonDemoScreen> {
  bool _primaryLoading = false;
  bool _secondaryLoading = false;
  String _lastTapped = 'Nothing yet';

  Future<void> _fakeApiCall(String buttonName, bool isPrimary) async {
    setState(() {
      if (isPrimary) {
        _primaryLoading = true;
      } else {
        _secondaryLoading = true;
      }
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _primaryLoading = false;
      _secondaryLoading = false;
      _lastTapped = '$buttonName finished!';
    });
  }

  void _setTapped(String name) => setState(() => _lastTapped = '$name tapped!');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Buttons Demo '),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.indigo.shade100),
              ),
              child: Text(
                ' $_lastTapped',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.indigo),
              ),
            ),
            const SizedBox(height: 32),

            _sectionTitle('1 · Basic Styles'),
            const SizedBox(height: 12),

            PrimaryButton(
              text: 'Primary Button',
              onPressed: () => _setTapped('Primary'),
            ),
            const SizedBox(height: 12),

            SecondaryButton(
              text: 'Secondary Button',
              onPressed: () => _setTapped('Secondary'),
            ),
            const SizedBox(height: 12),

            OutlineButton(
              text: 'Outline Button',
              onPressed: () => _setTapped('Outline'),
            ),
            const SizedBox(height: 12),

            TextOnlyButton(
              text: 'Text Button',
              onPressed: () => _setTapped('Text'),
            ),
            const SizedBox(height: 32),

            _sectionTitle('2 · With Icons'),
            const SizedBox(height: 12),

            PrimaryButton(
              text: 'Upload File',
              icon: Icons.upload_rounded,
              onPressed: () => _setTapped('Upload'),
            ),
            const SizedBox(height: 12),

            OutlineButton(
              text: 'Share',
              icon: Icons.share_rounded,
              onPressed: () => _setTapped('Share'),
            ),
            const SizedBox(height: 12),

            SecondaryButton(
              text: 'Favourite',
              icon: Icons.favorite_rounded,
              onPressed: () => _setTapped('Favourite'),
            ),
            const SizedBox(height: 32),

            _sectionTitle('3 · Loading State  (tap to try)'),
            const SizedBox(height: 12),

            PrimaryButton(
              text: 'Save Changes',
              icon: Icons.save_rounded,
              isLoading: _primaryLoading,
              onPressed: () => _fakeApiCall('Save', true),
            ),
            const SizedBox(height: 12),

            SecondaryButton(
              text: 'Sync Data',
              icon: Icons.sync_rounded,
              isLoading: _secondaryLoading,
              onPressed: () => _fakeApiCall('Sync', false),
            ),
            const SizedBox(height: 32),

            _sectionTitle('4 · Custom Colours'),
            const SizedBox(height: 12),

            CustomButton(
              text: 'Danger – Delete',
              icon: Icons.delete_rounded,
              color: Colors.red,
              onPressed: () => _setTapped('Delete'),
            ),
            const SizedBox(height: 12),

            CustomButton(
              text: 'Success – Confirm',
              icon: Icons.check_circle_rounded,
              color: Colors.green,
              onPressed: () => _setTapped('Confirm'),
            ),
            const SizedBox(height: 12),

            CustomButton(
              text: 'Warning – Review',
              icon: Icons.warning_rounded,
              color: Colors.orange,
              onPressed: () => _setTapped('Review'),
            ),
            const SizedBox(height: 32),

            _sectionTitle('5 · Disabled State'),
            const SizedBox(height: 12),

            PrimaryButton(text: 'Disabled Primary', onPressed: null),
            const SizedBox(height: 12),

            OutlineButton(text: 'Disabled Outline', onPressed: null),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Small helper to build a section title
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Colors.grey.shade600,
        letterSpacing: 0.5,
      ),
    );
  }
}
