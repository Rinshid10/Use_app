import 'package:flutter/material.dart';
import '../widgets/animated_builder.dart';
import 'image_to_pdf_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final features = [
      _FeatureItem(
        icon: Icons.picture_as_pdf_rounded,
        title: 'Image to PDF',
        subtitle: 'Convert images to PDF',
        gradientColors: [const Color(0xFF6C63FF), const Color(0xFF8B83FF)],
        isAvailable: true,
        onTap: () => Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const ImageToPdfScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 350),
          ),
        ),
      ),
      _FeatureItem(
        icon: Icons.document_scanner_rounded,
        title: 'Text Scanner',
        subtitle: 'OCR text extraction',
        gradientColors: [const Color(0xFF00BFA6), const Color(0xFF26D9B8)],
        isAvailable: false,
        onTap: null,
      ),
      _FeatureItem(
        icon: Icons.compress_rounded,
        title: 'PDF Compressor',
        subtitle: 'Reduce file size',
        gradientColors: [const Color(0xFFFF6B35), const Color(0xFFFF8F65)],
        isAvailable: false,
        onTap: null,
      ),
      _FeatureItem(
        icon: Icons.call_merge_rounded,
        title: 'Merge PDFs',
        subtitle: 'Combine multiple PDFs',
        gradientColors: [const Color(0xFF2196F3), const Color(0xFF64B5F6)],
        isAvailable: false,
        onTap: null,
      ),
      _FeatureItem(
        icon: Icons.image_rounded,
        title: 'PDF to Image',
        subtitle: 'Extract pages as images',
        gradientColors: [const Color(0xFFE91E63), const Color(0xFFF06292)],
        isAvailable: false,
        onTap: null,
      ),
      _FeatureItem(
        icon: Icons.qr_code_scanner_rounded,
        title: 'QR Scanner',
        subtitle: 'Scan & generate QR',
        gradientColors: [const Color(0xFF4CAF50), const Color(0xFF81C784)],
        isAvailable: false,
        onTap: null,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _getGreeting(),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'My Toolkit',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                                color: Color(0xFF1A1A2E),
                              ),
                            ),
                          ],
                        ),
                        _DownloadButton(),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Search-like hint bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6C63FF).withOpacity(0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.auto_awesome_rounded, color: const Color(0xFF6C63FF).withOpacity(0.7), size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'What would you like to do today?',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Section title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 20,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Tools',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A2E),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${features.where((f) => f.isAvailable).length} available',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Grid
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _FeatureCard(feature: features[index], index: index),
                  childCount: features.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.95,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DownloadButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('PDFs are saved to your Documents folder'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.all(16),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.download_rounded,
            color: Color(0xFF6C63FF),
            size: 22,
          ),
        ),
      ),
    );
  }
}

class _FeatureItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final bool isAvailable;
  final VoidCallback? onTap;

  _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.isAvailable,
    required this.onTap,
  });
}

class _FeatureCard extends StatefulWidget {
  final _FeatureItem feature;
  final int index;

  const _FeatureCard({required this.feature, required this.index});

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
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

    return AnimatedBuilder2(
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
          if (feature.isAvailable) {
            feature.onTap?.call();
          } else {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.hourglass_top_rounded, color: Colors.white, size: 18),
                    const SizedBox(width: 10),
                    Text('${feature.title} coming soon!'),
                  ],
                ),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.all(16),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        onTapCancel: () {
          setState(() => _isPressed = false);
          _controller.reverse();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: feature.isAvailable
                ? Border.all(color: feature.gradientColors[0].withOpacity(0.12), width: 1.5)
                : null,
            boxShadow: [
              BoxShadow(
                color: feature.isAvailable
                    ? feature.gradientColors[0].withOpacity(_isPressed ? 0.15 : 0.08)
                    : Colors.black.withOpacity(0.03),
                blurRadius: _isPressed ? 20 : 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative circle
              if (feature.isAvailable)
                Positioned(
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
                ),
              // Content
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon container
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
                            ? const Color(0xFF1A1A2E)
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
              ),
              // Coming soon badge
              if (!feature.isAvailable)
                Positioned(
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
                ),
              // Arrow for available features
              if (feature.isAvailable)
                Positioned(
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
                ),
            ],
          ),
        ),
      ),
    );
  }
}

