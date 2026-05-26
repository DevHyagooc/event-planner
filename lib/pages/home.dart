import 'package:flutter/material.dart';
import '../components/header_home.dart';
import '../components/empty_state_home.dart';
import '../components/custom_bottom_navigation.dart';
import '../components/card_evento.dart';
import '../models/evento.dart';
import 'editar_evento.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Evento> _eventosMock = [
    Evento(
      id: '1',
      titulo: 'Aniversário de João',
      descricao: 'Celebração de 10 anos',
      data: DateTime(2026, 3, 28),
      local: 'Salão de festas',
      status: EventoStatus.planejando,
      totalTarefas: 3,
      tarefasConcluidas: 1,
    ),
    Evento(
      id: '2',
      titulo: 'Arraia do Povo',
      descricao: 'Festa junina tradicional',
      data: DateTime(2026, 6, 1),
      local: 'Arena de Eventos',
      status: EventoStatus.cancelado,
      totalTarefas: 3,
      tarefasConcluidas: 0,
    ),
    Evento(
      id: '3',
      titulo: 'Pre-Caju',
      descricao: 'Maior pré-carnaval do Brasil',
      data: DateTime(2026, 10, 12),
      local: 'Orla de Atalaia',
      status: EventoStatus.concluido,
      totalTarefas: 3,
      tarefasConcluidas: 3,
    ),
    Evento(
      id: '4',
      titulo: 'Aniversário de Carla',
      descricao: 'Festa surpresa',
      data: DateTime(2025, 3, 31),
      local: 'Salão de festas',
      status: EventoStatus.planejando,
      totalTarefas: 3,
      tarefasConcluidas: 1,
    ),
  ];

  void _irParaEditar({Evento? evento}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditarEvento(evento: evento),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF8F6F4);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            const HeaderHome(),
            Expanded(
              child: _currentIndex == 0
                  ? _buildHomeContent()
                  : Center(
                      child: Text('Página ${_currentIndex + 1}'),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index != 2) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        onAddTap: () => _irParaEditar(),
      ),
    );
  }

  Widget _buildHomeContent() {
    if (_eventosMock.isEmpty) {
      return EmptyStateHome(
        onCreateEvent: () => _irParaEditar(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 24, 18, 12),
          child: Text(
            '${_eventosMock.length} eventos',
            style: const TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF111111),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 40),
            itemCount: _eventosMock.length,
            itemBuilder: (context, index) {
              final evento = _eventosMock[index];
              return CardEvento(
                evento: evento,
                onEdit: () => _irParaEditar(evento: evento),
              );
            },
          ),
        ),
      ],
    );
  }
}
