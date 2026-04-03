import 'package:flutter/material.dart';

class InputDemoScreen extends StatelessWidget {
  const InputDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Input Fields')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _SectionTitle('Basic Fields'),
            CustomTextField(
              label: 'Full Name',
              hint: 'Shafqat Ullah',
              icon: Icons.person,
            ),
            CustomTextField(
              label: 'Email',
              hint: 'you@example.com',
              icon: Icons.email,
            ),

            _SectionTitle('Password'),
            PasswordField(),

            _SectionTitle('Search'),
            SearchField(),

            _SectionTitle('OTP'),
            OTPField(),
          ],
        ),
      ),
    );
  }
}

// ─── Base Field ─────────────────────────────
class CustomTextField extends StatelessWidget {
  final String label, hint;
  final IconData? icon;
  final bool obscure;
  final Widget? suffix;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hint,
    this.icon,
    this.obscure = false,
    this.suffix,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: icon != null ? Icon(icon) : null,
          suffixIcon: suffix,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
      ),
    );
  }
}

// ─── Password ───────────────────────────────
class PasswordField extends StatefulWidget {
  const PasswordField({super.key});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool hide = true;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: 'Password',
      hint: 'Enter password',
      icon: Icons.lock,
      obscure: hide,
      suffix: IconButton(
        icon: Icon(hide ? Icons.visibility_off : Icons.visibility),
        onPressed: () => setState(() => hide = !hide),
      ),
    );
  }
}

// ─── Search ────────────────────────────────
class SearchField extends StatefulWidget {
  const SearchField({super.key});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final c = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: 'Search',
      hint: 'Search...',
      icon: Icons.search,
      controller: c,
      onChanged: (_) => setState(() {}),
      suffix: c.text.isNotEmpty
          ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => setState(() => c.clear()),
            )
          : null,
    );
  }
}

// ─── OTP ───────────────────────────────────
class OTPField extends StatefulWidget {
  const OTPField({super.key});

  @override
  State<OTPField> createState() => _OTPFieldState();
}

class _OTPFieldState extends State<OTPField> {
  final c = List.generate(6, (_) => TextEditingController());
  final f = List.generate(6, (_) => FocusNode());

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (i) {
        return SizedBox(
          width: 45,
          height: 45,
          child: TextField(
            controller: c[i],
            focusNode: f[i],
            maxLength: 1,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              counterText: '',

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey),
              ),

              filled: true,
              fillColor: Colors.grey.shade100,
            ),
            onChanged: (v) {
              if (v.isNotEmpty && i < 5) f[i + 1].requestFocus();
              if (v.isEmpty && i > 0) f[i - 1].requestFocus();
            },
          ),
        );
      }),
    );
  }
}

// ─── Title ────────────────────────────────
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
