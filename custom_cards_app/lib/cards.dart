import 'package:flutter/material.dart';

/// BASE CARD (handles shadow, radius, tap animation)
class BaseCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double radius;
  final double elevation;
  final Color color;
  final Gradient? gradient;

  const BaseCard({
    super.key,
    required this.child,
    this.onTap,
    this.radius = 12,
    this.elevation = 4,
    this.color = Colors.white,
    this.gradient,
  });

  @override
  State<BaseCard> createState() => _BaseCardState();
}

class _BaseCardState extends State<BaseCard>
    with SingleTickerProviderStateMixin {
  late AnimationController c;

  @override
  void initState() {
    super.initState();
    c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => c.forward(),
      onTapUp: (_) {
        c.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => c.reverse(),
      child: ScaleTransition(
        scale: Tween(begin: 1.0, end: 0.96).animate(c),
        child: Container(
          decoration: BoxDecoration(
            color: widget.gradient == null ? widget.color : null,
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(widget.radius),
            boxShadow: [
              BoxShadow(
                blurRadius: widget.elevation * 2,
                offset: Offset(0, widget.elevation),
                color: Colors.black.withOpacity(0.1),
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

/// SHIMMER
class ShimmerBox extends StatefulWidget {
  final double w, h;
  const ShimmerBox({super.key, required this.w, required this.h});

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController c;

  @override
  void initState() {
    super.initState();
    c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: c,
      builder: (_, __) {
        return Container(
          width: widget.w,
          height: widget.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [Colors.grey[300]!, Colors.grey[100]!, Colors.grey[300]!],
              stops: [
                (c.value - 0.3).clamp(0, 1),
                c.value,
                (c.value + 0.3).clamp(0, 1),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// PRODUCT CARD
class ProductCard extends StatelessWidget {
  final String imageUrl, name;
  final double price;
  final String? badge;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    this.badge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      onTap: onTap,
      radius: 16,
      elevation: 6,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(imageUrl, height: 180, fit: BoxFit.cover),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '\$${price.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.green),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (badge != null)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// USER CARD
class UserCard extends StatelessWidget {
  final String name, email, avatarUrl, role;
  final VoidCallback? onTap;

  const UserCard({
    super.key,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.role,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      onTap: onTap,
      gradient: const LinearGradient(colors: [Colors.blue, Colors.purple]),
      child: ListTile(
        leading: CircleAvatar(backgroundImage: NetworkImage(avatarUrl)),
        title: Text(name, style: const TextStyle(color: Colors.white)),
        subtitle: Text(role, style: const TextStyle(color: Colors.white70)),
      ),
    );
  }
}

/// NEWS CARD
class NewsCard extends StatelessWidget {
  final String headline, imageUrl;
  final VoidCallback? onTap;

  const NewsCard({
    super.key,
    required this.headline,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      onTap: onTap,
      child: Row(
        children: [
          Image.network(imageUrl, width: 100, height: 80, fit: BoxFit.cover),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(headline),
            ),
          ),
        ],
      ),
    );
  }
}

/// STATS CARD
class StatsCard extends StatelessWidget {
  final IconData icon;
  final String title, value;

  const StatsCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return BaseCard(
      gradient: const LinearGradient(colors: [Colors.blue, Colors.purple]),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white70)),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
