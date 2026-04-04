import 'package:flutter/material.dart';
import 'cards.dart';

void main() => runApp(const CustomCardsApp());

class CustomCardsApp extends StatelessWidget {
  const CustomCardsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Custom Cards',
      theme: ThemeData(useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> news = [
    'Flutter 3.0 Released!',
    'Material UI Updated',
    'Mobile Trends 2026',
  ];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Cards')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Product Card',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          loading
              ? const ShimmerBox(w: double.infinity, h: 200)
              : ProductCard(
                  imageUrl:
                      'https://fastly.picsum.photos/id/0/5000/3333.jpg?hmac=_j6ghY5fCfSD6tvtcV74zXivkJSPIfR9B8w34XeQmvU',
                  name: 'Laptop',
                  price: 999.99,
                  badge: 'SALE',
                  onTap: () => msg('Product tapped'),
                ),

          const SizedBox(height: 20),

          const Text(
            'User Card',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          UserCard(
            name: 'Shafqat Ullah',
            email: 'shafqat@mail.com',
            avatarUrl: 'https://picsum.photos/100',
            role: 'Flutter Dev',
            onTap: () => msg('User tapped'),
          ),

          const SizedBox(height: 20),

          const Text(
            'Stats Card',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          Row(
            children: const [
              Expanded(
                child: StatsCard(
                  icon: Icons.shopping_cart,
                  title: 'Orders',
                  value: '1200',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: StatsCard(
                  icon: Icons.money,
                  title: 'Revenue',
                  value: '\$5K',
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          const Text(
            'News (Swipe to delete)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          ...news.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Dismissible(
                key: Key(e),
                onDismissed: (_) {
                  setState(() => news.remove(e));
                  msg('$e deleted');
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: NewsCard(
                  headline: e,
                  imageUrl: 'https://picsum.photos/300',
                  onTap: () => msg(e),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void msg(String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }
}
