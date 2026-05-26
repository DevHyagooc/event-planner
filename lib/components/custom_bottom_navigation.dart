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
    const muted = Color(0xFF8D7F78);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              BottomNavigationBar(
                currentIndex: currentIndex,
                onTap: onTap,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                selectedItemColor: coral,
                unselectedItemColor: muted,
                selectedFontSize: 11,
                unselectedFontSize: 11,
                elevation: 0,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined, size: 26),
                    activeIcon: Icon(Icons.home, size: 26),
                    label: 'Início',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_today_outlined, size: 22),
                    activeIcon: Icon(Icons.calendar_today, size: 22),
                    label: 'Agenda',
                  ),
                  BottomNavigationBarItem(icon: SizedBox.shrink(), label: ''),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.check_box_outlined, size: 24),
                    activeIcon: Icon(Icons.check_box, size: 24),
                    label: 'Tarefas',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline, size: 26),
                    activeIcon: Icon(Icons.person, size: 26),
                    label: 'Perfil',
                  ),
                ],
              ),
              Positioned(
                top: -30,
                child: GestureDetector(
                  onTap: onAddTap,
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
        ),
      ),
    );
  }
}
