import 'package:flutter/material.dart';

class EmptyStateHome extends StatelessWidget {
  final VoidCallback onCreateEvent;

  const EmptyStateHome({super.key, required this.onCreateEvent});

  @override
  Widget build(BuildContext context) {
    const coral = Color(0xFFE76E50);
    const textDark = Color(0xFF111111);

    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 80),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFAE2DC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.calendar_today_outlined,
                color: coral,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Nenhum evento ainda',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Comece criando seu primeiro evento para organizar suas tarefas.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Color(0xFF666666),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onCreateEvent,
              style: ElevatedButton.styleFrom(
                backgroundColor: coral,
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size(180, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.add, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Criar Evento',
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
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
