import 'package:flutter/material.dart';

// HOME SCREEN
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String result = 'Tap a button';

  void setResult(String msg) => setState(() => result = msg);

  final shape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  );

  Future<T?> showSheet<T>(Widget child, {bool scroll = false}) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: scroll,
      shape: shape,
      builder: (_) => Padding(padding: const EdgeInsets.all(16), child: child),
    );
  }

  // SIMPLE SHEET
  void simpleSheet() {
    showSheet(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const DragHandle(),
          const Text('Simple Sheet'),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setResult('Closed ');
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // SCROLLABLE SHEET
  void scrollSheet() {
    showSheet(
      DraggableScrollableSheet(
        expand: false,
        builder: (_, c) => Column(
          children: [
            const DragHandle(),
            Expanded(
              child: ListView.builder(
                controller: c,
                itemCount: 15,
                itemBuilder: (_, i) => ListTile(
                  title: Text('Item ${i + 1}'),
                  onTap: () {
                    Navigator.pop(context);
                    setResult('Selected ${i + 1}');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      scroll: true,
    );
  }

  // ALERT
  void alert() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Alert'),
        content: const Text('Important message'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  //  CONFIRM
  void confirm() async {
    final res = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm'),
        content: const Text('Delete item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
    setResult(res == true ? 'Deleted' : 'Cancelled');
  }

  //  FORM DIALOG
  void formDialog() {
    final c = TextEditingController();
    final key = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit'),
        content: Form(
          key: key,
          child: TextFormField(
            controller: c,
            validator: (v) => v!.isEmpty ? 'Enter value' : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (key.currentState!.validate()) {
                Navigator.pop(context);
                setResult('Saved: ${c.text}');
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  //  FILTER SHEET
  void filterSheet() {
    showSheet(FilterSheet(), scroll: true).then((v) {
      if (v != null) setResult('Filters: $v');
    });
  }

  //  SETTINGS
  void settings() {
    showDialog(context: context, builder: (_) => const SettingsDialog()).then((
      v,
    ) {
      if (v == true) setResult('Settings saved ⚙️');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modals Demo'),
        backgroundColor: const Color(0xFF6C63FF),
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) => setResult(v),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'Profile', child: Text('Profile')),
              PopupMenuItem(value: 'Settings', child: Text('Settings')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(result),
          const SizedBox(height: 20),
          btn('Simple Sheet', simpleSheet),
          btn('Scrollable Sheet', scrollSheet),
          btn('Filter Sheet', filterSheet),
          btn('Alert', alert),
          btn('Confirm', confirm),
          btn('Form Dialog', formDialog),
          btn('Settings', settings),
        ],
      ),
    );
  }

  Widget btn(String t, VoidCallback f) => Card(
    child: ListTile(title: Text(t), onTap: f),
  );
}

// FILTER SHEET
class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  Map<String, bool> cat = {'A': false, 'B': false};
  double price = 500;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const DragHandle(),
        ...cat.keys.map(
          (k) => CheckboxListTile(
            title: Text(k),
            value: cat[k],
            onChanged: (v) => setState(() => cat[k] = v!),
          ),
        ),
        Slider(
          value: price,
          max: 1000,
          onChanged: (v) => setState(() => price = v),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, '$price'),
          child: const Text('Apply'),
        ),
      ],
    );
  }
}

// SETTINGS DIALOG

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({super.key});

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  bool dark = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Settings'),
      content: SwitchListTile(
        title: const Text('Dark Mode'),
        value: dark,
        onChanged: (v) => setState(() => dark = v),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Save'),
        ),
      ],
    );
  }
}

// DRAG HANDLE
class DragHandle extends StatelessWidget {
  const DragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      width: 40,
      height: 4,
      color: Colors.grey,
    );
  }
}
