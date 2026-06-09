import 'package:flutter/material.dart';
import '../components/header_home.dart';
import '../components/empty_state_home.dart';
import '../components/custom_bottom_navigation.dart';
import '../components/card_evento.dart';
import '../models/evento.dart';
import '../services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'editar_evento.dart';
import 'agenda.dart';
import 'tarefas/tarefas_page.dart';
import 'profile.dart';
import 'login.dart';

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

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Login()),
        (route) => false,
      );
    }
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
        onAddTap: () => _irParaEditar(),
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
                    onEdit: () => _irParaEditar(evento: evento),
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
