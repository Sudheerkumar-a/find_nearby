import 'package:flutter/material.dart';

class LoadingSkeleton extends StatefulWidget {
  const LoadingSkeleton({
    super.key,
    this.width,
    this.height = 16,
    this.radius = 12,
  });

  final double? width;
  final double height;
  final double radius;

  @override
  State<LoadingSkeleton> createState() => _LoadingSkeletonState();
}

class _LoadingSkeletonState extends State<LoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest;
    final highlight = Theme.of(context).colorScheme.surfaceContainerLowest;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment(-1.5 + 2 * _controller.value, 0),
              end: Alignment(-0.5 + 2 * _controller.value, 0),
              colors: [base, highlight, base],
            ),
          ),
        );
      },
    );
  }
}

class PlaceCardSkeleton extends StatelessWidget {
  const PlaceCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LoadingSkeleton(width: 72, height: 72, radius: 12),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LoadingSkeleton(width: 180, height: 16),
                  SizedBox(height: 8),
                  LoadingSkeleton(width: 120, height: 12),
                  SizedBox(height: 8),
                  LoadingSkeleton(width: 200, height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceDetailsSkeleton extends StatelessWidget {
  const PlaceDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 260,
            leading: const BackButton(),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: LoadingSkeleton(width: 40, height: 40, radius: 20),
              ),
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: LoadingSkeleton(width: 40, height: 40, radius: 20),
              ),
            ],
            flexibleSpace: const FlexibleSpaceBar(
              background: LoadingSkeleton(height: 300, radius: 0),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            sliver: SliverList.list(
              children: const [
                LoadingSkeleton(width: 260, height: 28, radius: 8),
                SizedBox(height: 8),
                LoadingSkeleton(width: 120, height: 18, radius: 8),
                SizedBox(height: 8),
                LoadingSkeleton(width: 100, height: 16, radius: 8),
                SizedBox(height: 16),
                _InfoRowSkeleton(width: 280),
                SizedBox(height: 8),
                LoadingSkeleton(width: 90, height: 16, radius: 8),
                SizedBox(height: 6),
                LoadingSkeleton(width: 180, height: 14, radius: 8),
                SizedBox(height: 16),
                _InfoRowSkeleton(width: 160),
                SizedBox(height: 8),
                _InfoRowSkeleton(width: 220),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: LoadingSkeleton(height: 48, radius: 24),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: LoadingSkeleton(height: 48, radius: 24),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                LoadingSkeleton(height: 48, radius: 24),
                SizedBox(height: 28),
                LoadingSkeleton(width: 60, height: 20, radius: 8),
                SizedBox(height: 8),
                LoadingSkeleton(height: 14, radius: 8),
                SizedBox(height: 6),
                LoadingSkeleton(width: 300, height: 14, radius: 8),
                SizedBox(height: 6),
                LoadingSkeleton(width: 240, height: 14, radius: 8),
                SizedBox(height: 28),
                LoadingSkeleton(width: 40, height: 20, radius: 8),
                SizedBox(height: 12),
                LoadingSkeleton(height: 160, radius: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRowSkeleton extends StatelessWidget {
  const _InfoRowSkeleton({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const LoadingSkeleton(width: 20, height: 20, radius: 6),
        const SizedBox(width: 10),
        LoadingSkeleton(width: width, height: 16, radius: 8),
      ],
    );
  }
}
