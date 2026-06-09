import 'package:flutter/material.dart';
import '../components/header_home.dart';
import '../components/empty_state_home.dart';
import '../components/custom_bottom_navigation.dart';
import '../components/card_evento.dart';
import '../models/evento.dart';
import '../models/event_task.dart';
import '../services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'editar_evento.dart';
import 'agenda.dart';
import 'tarefas/detalhe_tarefas_page.dart';
import 'tarefas/form_tarefa_page.dart';
import 'tarefas/tarefas_page.dart';
import 'tarefas/tarefas_shared.dart';
import 'profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final FirestoreService _firestoreService = FirestoreService();

  String get _currentUserId =>
      FirebaseAuth.instance.currentUser?.uid ?? 'user-teste-123';

  void _irParaEditar({Evento? evento}) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditarEvento(evento: evento)),
    );
  }

  void _irParaDetalheEvento(Evento evento) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetalheTarefasPage(event: evento)),
    );
  }

  Future<void> _handleAddTap() async {
    if (_currentIndex == 3) {
      await _adicionarTarefa();
      return;
    }

    _irParaEditar();
  }

  Future<void> _adicionarTarefa() async {
    if (_currentUserId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Usuário não autenticado.')));
      return;
    }

    try {
      final eventos = await _firestoreService.getEventosOnce(_currentUserId);

      if (!mounted) {
        return;
      }

      if (eventos.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Crie um evento antes de adicionar tarefas.'),
          ),
        );
        return;
      }

      final selectedEvent = eventos.length == 1
          ? eventos.first
          : await _selecionarEventoParaTarefa(eventos);

      if (selectedEvent == null || !mounted) {
        return;
      }

      final task = await Navigator.push<EventTask>(
        context,
        MaterialPageRoute(
          builder: (_) => FormTarefaPage(eventId: selectedEvent.id),
        ),
      );

      if (task == null) {
        return;
      }

      await _firestoreService.saveTask(task);
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao adicionar tarefa: $e')));
    }
  }

  Future<Evento?> _selecionarEventoParaTarefa(List<Evento> eventos) {
    return showModalBottomSheet<Evento>(
      context: context,
      backgroundColor: TaskPalette.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Adicionar tarefa em',
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: TaskPalette.text,
                  ),
                ),
                const SizedBox(height: 16),
                ...eventos.map(
                  (evento) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      evento.titulo,
                      style: const TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      TaskDateFormatter.eventDate(evento.data),
                      style: const TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontSize: 12,
                        color: TaskPalette.muted,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: () => Navigator.pop(context, evento),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFFF8F6F4);

    return Scaffold(
      backgroundColor: bg,
      body: _buildBody(),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index != 2) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        onAddTap: _handleAddTap,
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return SafeArea(
          child: Column(
            children: [
              const HeaderHome(),
              Expanded(child: _buildHomeContent()),
            ],
          ),
        );
      case 1:
        return const Agenda();
      case 3:
        return const TarefasPage();
      case 4:
        return const Profile();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildHomeContent() {
    if (_currentUserId.isEmpty) {
      return const Center(child: Text('Usuário não autenticado.'));
    }

    return StreamBuilder<List<Evento>>(
      stream: _firestoreService.getEventos(_currentUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFE76E50)),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Erro ao carregar eventos: ${snapshot.error}'),
          );
        }

        final eventos = snapshot.data ?? [];

        if (eventos.isEmpty) {
          return EmptyStateHome(onCreateEvent: () => _irParaEditar());
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 24, 18, 12),
              child: Text(
                '${eventos.length} eventos',
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
                itemCount: eventos.length,
                itemBuilder: (context, index) {
                  final evento = eventos[index];
                  return CardEvento(
                    evento: evento,
                    onTap: () => _irParaDetalheEvento(evento),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
