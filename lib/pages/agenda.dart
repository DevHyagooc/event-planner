import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/evento.dart';
import '../services/firestore_service.dart';

class Agenda extends StatefulWidget {
  const Agenda({super.key});

  @override
  State<Agenda> createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  DateTime mesAtual = DateTime.now();
  DateTime dataSelecionada = DateTime.now();

  final FirestoreService firestoreService = FirestoreService();

  String get userId {
    return FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  List<Evento> filtrarEventosNaData(List<Evento> eventos) {
    return eventos.where((evento) {
      return evento.data.year == dataSelecionada.year &&
          evento.data.month == dataSelecionada.month &&
          evento.data.day == dataSelecionada.day;
    }).toList();
  }

  List<Evento> filtrarEventosNoMes(List<Evento> eventos) {
    return eventos.where((evento) {
      return evento.data.year == mesAtual.year &&
          evento.data.month == mesAtual.month;
    }).toList();
  }

  void voltarMes() {
    setState(() {
      mesAtual = DateTime(mesAtual.year, mesAtual.month - 1);
      dataSelecionada = DateTime(mesAtual.year, mesAtual.month, 1);
    });
  }

  void avancarMes() {
    setState(() {
      mesAtual = DateTime(mesAtual.year, mesAtual.month + 1);
      dataSelecionada = DateTime(mesAtual.year, mesAtual.month, 1);
    });
  }

  void selecionarData(DateTime data) {
    setState(() {
      dataSelecionada = data;
      mesAtual = DateTime(data.year, data.month);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userId.isEmpty) {
      return const Center(
        child: Text(
          'Usuário não está logado.',
          style: TextStyle(
            fontFamily: 'SpaceGrotesk',
            color: Color(0xFF9A948F),
            fontSize: 13,
          ),
        ),
      );
    }

    return StreamBuilder<List<Evento>>(
      stream: firestoreService.getEventos(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFE76E50),
            ),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Erro ao carregar os eventos.',
              style: TextStyle(
                fontFamily: 'SpaceGrotesk',
                color: Colors.red,
                fontSize: 13,
              ),
            ),
          );
        }

        final eventos = snapshot.data ?? [];
        final eventosNaData = filtrarEventosNaData(eventos);
        final eventosNoMes = filtrarEventosNoMes(eventos);

        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 390,
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    const Text(
                      'Agenda',
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _Calendario(
                      mesAtual: mesAtual,
                      dataSelecionada: dataSelecionada,
                      onVoltarMes: voltarMes,
                      onAvancarMes: avancarMes,
                      onSelecionarData: selecionarData,
                    ),

                    const SizedBox(height: 22),

                    const Text(
                      'EVENTOS NA DATA',
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        color: Color(0xFF2C2421),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 8),

                    if (eventosNaData.isEmpty)
                      const Text(
                        'Não há eventos para essa data.',
                        style: TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          color: Color(0xFF9A948F),
                          fontSize: 13,
                        ),
                      )
                    else
                      Column(
                        children: eventosNaData.map((evento) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: CardEventoAgenda(evento: evento),
                          );
                        }).toList(),
                      ),

                    const SizedBox(height: 18),

                    const Text(
                      'EVENTOS NO MÊS',
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        color: Color(0xFF2C2421),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 8),

                    if (eventosNoMes.isEmpty)
                      const Text(
                        'Não há eventos neste mês.',
                        style: TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          color: Color(0xFF9A948F),
                          fontSize: 13,
                        ),
                      )
                    else
                      Column(
                        children: eventosNoMes.map((evento) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: CardEventoAgenda(evento: evento),
                          );
                        }).toList(),
                      ),

                    const SizedBox(height: 90),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _Calendario extends StatelessWidget {
  final DateTime mesAtual;
  final DateTime dataSelecionada;
  final VoidCallback onVoltarMes;
  final VoidCallback onAvancarMes;
  final Function(DateTime data) onSelecionarData;

  const _Calendario({
    required this.mesAtual,
    required this.dataSelecionada,
    required this.onVoltarMes,
    required this.onAvancarMes,
    required this.onSelecionarData,
  });

  String nomeMes(int mes) {
    const meses = [
      'janeiro',
      'fevereiro',
      'março',
      'abril',
      'maio',
      'junho',
      'julho',
      'agosto',
      'setembro',
      'outubro',
      'novembro',
      'dezembro',
    ];

    return meses[mes - 1];
  }

  List<DateTime> gerarDiasDoCalendario() {
    final primeiroDiaDoMes = DateTime(mesAtual.year, mesAtual.month, 1);
    final primeiroDiaSemana = primeiroDiaDoMes.weekday % 7;

    final inicioCalendario = primeiroDiaDoMes.subtract(
      Duration(days: primeiroDiaSemana),
    );

    return List.generate(35, (index) {
      return inicioCalendario.add(Duration(days: index));
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> diasSemana = [
      'dom',
      'seg',
      'ter',
      'qua',
      'qui',
      'sex',
      'sáb',
    ];

    final diasCalendario = gerarDiasDoCalendario();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE6E1DC),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 34,
            child: Row(
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: onVoltarMes,
                  icon: const Icon(
                    Icons.chevron_left,
                    color: Colors.black,
                    size: 22,
                  ),
                ),

                Expanded(
                  child: Center(
                    child: Text(
                      '${nomeMes(mesAtual.month)} ${mesAtual.year}',
                      style: const TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),

                IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: onAvancarMes,
                  icon: const Icon(
                    Icons.chevron_right,
                    color: Colors.black,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: diasSemana.map((dia) {
              return SizedBox(
                width: 34,
                child: Center(
                  child: Text(
                    dia,
                    style: const TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      color: Color(0xFF9A948F),
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 12),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: diasCalendario.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 4,
              childAspectRatio: 1.15,
            ),
            itemBuilder: (context, index) {
              final dia = diasCalendario[index];

              final bool selecionado =
                  dia.year == dataSelecionada.year &&
                  dia.month == dataSelecionada.month &&
                  dia.day == dataSelecionada.day;

              final bool pertenceAoMesAtual =
                  dia.month == mesAtual.month && dia.year == mesAtual.year;

              return GestureDetector(
                onTap: () {
                  onSelecionarData(dia);
                },
                child: Center(
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: selecionado
                          ? const Color(0xFFE76E50)
                          : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        dia.day.toString(),
                        style: TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          color: selecionado
                              ? Colors.white
                              : pertenceAoMesAtual
                                  ? Colors.black
                                  : const Color(0xFF9A948F),
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CardEventoAgenda extends StatelessWidget {
  final Evento evento;

  const CardEventoAgenda({
    super.key,
    required this.evento,
  });

  String nomeMesCurto(int mes) {
    const meses = [
      'jan',
      'fev',
      'mar',
      'abr',
      'mai',
      'jun',
      'jul',
      'ago',
      'set',
      'out',
      'nov',
      'dez',
    ];

    return meses[mes - 1];
  }

  @override
  Widget build(BuildContext context) {
    final dataFormatada = '${evento.data.day} ${nomeMesCurto(evento.data.month)}';
    final horario = evento.hora ?? '';
    final progresso = (evento.progresso * 100).toInt();

    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE6E1DC),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFFADED6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.calendar_month_outlined,
              color: Color(0xFFE76E50),
              size: 20,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  evento.titulo,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  '$dataFormatada    $horario',
                  style: const TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    color: Color(0xFF9A948F),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          Text(
            '$progresso%',
            style: const TextStyle(
              fontFamily: 'SpaceGrotesk',
              color: Color(0xFFE76E50),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
