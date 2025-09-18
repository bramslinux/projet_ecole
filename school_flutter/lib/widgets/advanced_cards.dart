import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class AdvancedStatsCard extends StatefulWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool showTrend;
  final double? trendValue;

  const AdvancedStatsCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    this.onTap,
    this.showTrend = false,
    this.trendValue,
  }) : super(key: key);

  @override
  State<AdvancedStatsCard> createState() => _AdvancedStatsCardState();
}

class _AdvancedStatsCardState extends State<AdvancedStatsCard>
    with TickerProviderStateMixin {
  late AnimationController _hoverController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _hoverController.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _hoverController.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withOpacity(_isHovered ? 0.3 : 0.1),
                      blurRadius: _isHovered ? 20 : 10,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: GlassmorphicContainer(
                  width: double.infinity,
                  height: 160,
                  borderRadius: 24,
                  linearGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(_isHovered ? 0.25 : 0.15),
                      Colors.white.withOpacity(_isHovered ? 0.15 : 0.05),
                    ],
                  ),
                  border: _isHovered ? 2 : 1.5,
                  blur: _isHovered ? 15 : 10,
                  borderGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.color.withOpacity(_isHovered ? 0.8 : 0.6),
                      Colors.white.withOpacity(_isHovered ? 0.4 : 0.2),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  colors: [
                                    widget.color.withOpacity(0.8),
                                    widget.color.withOpacity(0.4),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.color.withOpacity(0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: AnimatedBuilder(
                                animation: _pulseAnimation,
                                builder: (context, child) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: widget.color.withOpacity(
                                            0.3 * _pulseAnimation.value,
                                          ),
                                          blurRadius: 20,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      widget.icon,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (widget.showTrend && widget.trendValue != null)
                              _buildTrendIndicator(),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          widget.value,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.1),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.title,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (widget.subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.subtitle!,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTrendIndicator() {
    final isPositive = (widget.trendValue ?? 0) > 0;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: (isPositive ? Colors.green : Colors.red).withOpacity(0.2),
        border: Border.all(
          color: (isPositive ? Colors.green : Colors.red).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.trending_up : Icons.trending_down,
            color: isPositive ? Colors.green : Colors.red,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            '${widget.trendValue!.abs().toStringAsFixed(1)}%',
            style: TextStyle(
              color: isPositive ? Colors.green : Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedProgressCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final double progress;
  final Color color;
  final IconData icon;

  const AnimatedProgressCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.color,
    required this.icon,
  }) : super(key: key);

  @override
  State<AnimatedProgressCard> createState() => _AnimatedProgressCardState();
}

class _AnimatedProgressCardState extends State<AnimatedProgressCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    
    // Démarrer l'animation après un petit délai
    Future.delayed(const Duration(milliseconds: 300), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 120,
      borderRadius: 20,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.15),
          Colors.white.withOpacity(0.05),
        ],
      ),
      border: 1.5,
      blur: 10,
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          widget.color.withOpacity(0.6),
          Colors.white.withOpacity(0.2),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    widget.color.withOpacity(0.8),
                    widget.color.withOpacity(0.4),
                  ],
                ),
              ),
              child: Icon(
                widget.icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: widget.color.withOpacity(0.2),
                                ),
                                child: Text(
                                  '${(_progressAnimation.value * 100).toInt()}%',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: _progressAnimation.value,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                widget.color,
                              ),
                              minHeight: 6,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class FloatingActionMenu extends StatefulWidget {
  final List<FloatingActionItem> items;
  final IconData mainIcon;
  final Color? backgroundColor;
  final String? tooltip;

  const FloatingActionMenu({
    Key? key,
    required this.items,
    this.mainIcon = Icons.add,
    this.backgroundColor,
    this.tooltip,
  }) : super(key: key);

  @override
  State<FloatingActionMenu> createState() => _FloatingActionMenuState();
}

class _FloatingActionMenuState extends State<FloatingActionMenu>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotateAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _rotateAnimation = Tween<double>(
      begin: 0.0,
      end: 0.75,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    if (_isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Background overlay
        AnimatedBuilder(
          animation: _expandAnimation,
          builder: (context, child) {
            return _isExpanded
                ? GestureDetector(
                    onTap: _toggle,
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black.withOpacity(
                        0.3 * _expandAnimation.value,
                      ),
                    ),
                  )
                : const SizedBox.shrink();
          },
        ),

        // Menu items
        ...List.generate(widget.items.length, (index) {
          return AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              final offset = (index + 1) * 70.0;
              return Transform.translate(
                offset: Offset(
                  0,
                  -offset * _expandAnimation.value,
                ),
                child: Transform.scale(
                  scale: _expandAnimation.value,
                  child: Opacity(
                    opacity: _expandAnimation.value,
                    child: _buildMenuItem(widget.items[index]),
                  ),
                ),
              );
            },
          );
        }),

        // Main FAB
        AnimatedBuilder(
          animation: _rotateAnimation,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotateAnimation.value * 2 * 3.14159,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    colors: [
                      widget.backgroundColor?.withOpacity(0.9) ?? 
                          Colors.purple.withOpacity(0.9),
                      widget.backgroundColor?.withOpacity(0.7) ?? 
                          Colors.purple.withOpacity(0.7),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (widget.backgroundColor ?? Colors.purple)
                          .withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(28),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(28),
                    onTap: _toggle,
                    child: Icon(
                      _isExpanded ? Icons.close : widget.mainIcon,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMenuItem(FloatingActionItem item) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (item.label != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.black.withOpacity(0.7),
            ),
            child: Text(
              item.label!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [
                item.backgroundColor?.withOpacity(0.9) ?? 
                    Colors.blue.withOpacity(0.9),
                item.backgroundColor?.withOpacity(0.7) ?? 
                    Colors.blue.withOpacity(0.7),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: (item.backgroundColor ?? Colors.blue)
                    .withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                _toggle();
                item.onTap();
              },
              child: Icon(
                item.icon,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FloatingActionItem {
  final IconData icon;
  final String? label;
  final VoidCallback onTap;
  final Color? backgroundColor;

  const FloatingActionItem({
    required this.icon,
    required this.onTap,
    this.label,
    this.backgroundColor,
  });
}

class AnimatedTabBar extends StatefulWidget {
  final List<TabItem> tabs;
  final int selectedIndex;
  final Function(int) onTabSelected;
  final Color? selectedColor;
  final Color? unselectedColor;

  const AnimatedTabBar({
    Key? key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    this.selectedColor,
    this.unselectedColor,
  }) : super(key: key);

  @override
  State<AnimatedTabBar> createState() => _AnimatedTabBarState();
}

class _AnimatedTabBarState extends State<AnimatedTabBar>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _indicatorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _indicatorAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.all(16),
      child: GlassmorphicContainer(
        width: double.infinity,
        height: 60,
        borderRadius: 30,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: 1.5,
        blur: 10,
        borderGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.6),
            Colors.white.withOpacity(0.2),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            children: List.generate(widget.tabs.length, (index) {
              final isSelected = index == widget.selectedIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => widget.onTabSelected(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      gradient: isSelected
                          ? LinearGradient(
                              colors: [
                                widget.selectedColor?.withOpacity(0.8) ?? 
                                    Colors.blue.withOpacity(0.8),
                                widget.selectedColor?.withOpacity(0.6) ?? 
                                    Colors.blue.withOpacity(0.6),
                              ],
                            )
                          : null,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: (widget.selectedColor ?? Colors.blue)
                                    .withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            widget.tabs[index].icon,
                            color: isSelected
                                ? Colors.white
                                : widget.unselectedColor ?? 
                                  Colors.white.withOpacity(0.6),
                            size: 20,
                          ),
                          if (isSelected && widget.tabs[index].title != null) ...[
                            const SizedBox(width: 8),
                            Flexible(
                              child: AnimatedBuilder(
                                animation: _indicatorAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _indicatorAnimation.value,
                                    child: Opacity(
                                      opacity: _indicatorAnimation.value,
                                      child: Text(
                                        widget.tabs[index].title!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class TabItem {
  final IconData icon;
  final String? title;

  const TabItem({
    required this.icon,
    this.title,
  });
}
