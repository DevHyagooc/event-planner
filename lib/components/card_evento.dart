import 'package:flutter/material.dart';
import '../models/evento.dart';
import 'package:intl/intl.dart';

class CardEvento extends StatelessWidget {
  final Evento evento;
  final VoidCallback onEdit;

  const CardEvento({
    super.key,
    required this.evento,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    const coral = Color(0xFFE76E50);
    const textDark = Color(0xFF111111);
    const textLight = Color(0xFFBCBCBC);
    const bgGray = Color(0xFFE8E2DE);

    final dataFormatada = DateFormat('dd MMM yyyy', 'pt_BR').format(evento.data);

    return GestureDetector(
      onTap: onEdit,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    evento.titulo,
                    style: const TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textDark,
                    ),
                  ),
                ),
                _buildStatusBadge(evento.status),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: 16, color: textLight),
                const SizedBox(width: 6),
                Text(
                  dataFormatada,
                  style: const TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontSize: 14,
                    color: textLight,
                  ),
                ),
                const SizedBox(width: 20),
                Icon(Icons.location_on_outlined, size: 16, color: textLight),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    evento.local,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontSize: 14,
                      color: textLight,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${evento.tarefasConcluidas}/${evento.totalTarefas} tarefas',
                  style: const TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontSize: 13,
                    color: textLight,
                  ),
                ),
                Text(
                  '${(evento.progresso * 100).toInt()}%',
                  style: const TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontSize: 13,
                    color: textLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: evento.progresso,
                backgroundColor: bgGray,
                valueColor: const AlwaysStoppedAnimation<Color>(coral),
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(EventoStatus status) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case EventoStatus.planejando:
        bgColor = const Color(0xFFFEF4E8);
        textColor = const Color(0xFFF2C94C);
        label = 'Planejando';
        break;
      case EventoStatus.concluido:
        bgColor = const Color(0xFFE8F5E9);
        textColor = const Color(0xFF27AE60);
        label = 'Concluído';
        break;
      case EventoStatus.cancelado:
        bgColor = const Color(0xFFFFEBEE);
        textColor = const Color(0xFFEB5757);
        label = 'Cancelado';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
    );
  }
}
