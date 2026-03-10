import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../model/feature_item.dart';

class FeatureCard extends StatefulWidget {
  final FeatureItem feature;
  final VoidCallback onTap;

  const FeatureCard({
    super.key,
    required this.feature,
    required this.onTap,
  });

  @override
  State<FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<FeatureCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feature = widget.feature;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: (_) {
          setState(() => _isPressed = true);
          _controller.forward();
        },
        onTapUp: (_) {
          setState(() => _isPressed = false);
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () {
          setState(() => _isPressed = false);
          _controller.reverse();
        },
        child: _buildCard(feature),
      ),
    );
  }

  Widget _buildCard(FeatureItem feature) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: feature.isAvailable
            ? Border.all(
                color: feature.gradientColors[0].withOpacity(0.12),
                width: 1.5,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: feature.isAvailable
                ? feature.gradientColors[0]
                    .withOpacity(_isPressed ? 0.15 : 0.08)
                : Colors.black.withOpacity(0.03),
            blurRadius: _isPressed ? 20 : 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (feature.isAvailable) _buildDecorativeCircle(feature),
          _buildContent(feature),
          if (!feature.isAvailable) _buildComingSoonBadge(),
          if (feature.isAvailable) _buildArrowIndicator(feature),
        ],
      ),
    );
  }

  Widget _buildDecorativeCircle(FeatureItem feature) {
    return Positioned(
      top: -20,
      right: -20,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: feature.gradientColors[0].withOpacity(0.06),
        ),
      ),
    );
  }

  Widget _buildContent(FeatureItem feature) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: feature.isAvailable
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: feature.gradientColors,
                    )
                  : null,
              color: feature.isAvailable ? null : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(15),
              boxShadow: feature.isAvailable
                  ? [
                      BoxShadow(
                        color: feature.gradientColors[0].withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              feature.icon,
              color: feature.isAvailable ? Colors.white : Colors.grey.shade400,
              size: 26,
            ),
          ),
          const Spacer(),
          // Title
          Text(
            feature.title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: feature.isAvailable
                  ? AppColors.darkText
                  : Colors.grey.shade400,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),
          // Subtitle
          Text(
            feature.subtitle,
            style: TextStyle(
              fontSize: 11.5,
              color: feature.isAvailable
                  ? Colors.grey.shade500
                  : Colors.grey.shade400,
              fontWeight: FontWeight.w400,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComingSoonBadge() {
    return Positioned(
      top: 12,
      right: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          'Soon',
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildArrowIndicator(FeatureItem feature) {
    return Positioned(
      bottom: 16,
      right: 16,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: feature.gradientColors[0].withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          Icons.arrow_forward_rounded,
          color: feature.gradientColors[0],
          size: 16,
        ),
      ),
    );
  }
}
