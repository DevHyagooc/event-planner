import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onAddTap;

  const CustomBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    const coral = Color(0xFFE76E50);
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final totalHeight = 86 + bottomInset;

    return SizedBox(
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 30,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(bottom: bottomInset),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                height: 56,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(
                      0,
                      Icons.home_outlined,
                      Icons.home,
                      'Início',
                      26,
                    ),
                    _buildNavItem(
                      1,
                      Icons.calendar_today_outlined,
                      Icons.calendar_today,
                      'Agenda',
                      22,
                    ),
                    const SizedBox(width: 60),
                    _buildNavItem(
                      3,
                      Icons.check_box_outlined,
                      Icons.check_box,
                      'Tarefas',
                      24,
                    ),
                    _buildNavItem(
                      4,
                      Icons.person_outline,
                      Icons.person,
                      'Perfil',
                      26,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: GestureDetector(
              onTap: onAddTap,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: coral,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 36),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    IconData activeIcon,
    String label,
    double size,
  ) {
    final isSelected = currentIndex == index;
    final color = isSelected
        ? const Color(0xFFE76E50)
        : const Color(0xFF8D7F78);

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isSelected ? activeIcon : icon, color: color, size: size),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontSize: 11,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
