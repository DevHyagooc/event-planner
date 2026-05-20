import 'package:flutter/material.dart';

class Agenda extends StatefulWidget {
  const Agenda({super.key});

  @override
  State<Agenda> createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  int diaSelecionado = 18;

  final List<EventoAgenda> eventos = [
    EventoAgenda(
      titulo: 'Aniversário de João',
      data: '18 mar',
      horario: '21:00',
      progresso: 33,
      dia: 18,
    ),
    EventoAgenda(
      titulo: 'Aniversário de João',
      data: '18 mar',
      horario: '21:00',
      progresso: 33,
      dia: 18,
    ),
  ];

  List<EventoAgenda> get eventosNaData {
    return eventos.where((evento) => evento.dia == diaSelecionado).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3F1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 28),

              const Text(
                'Agenda',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  height: 1.0,
                ),
              ),

              const SizedBox(height: 18),

              _Calendario(
                diaSelecionado: diaSelecionado,
                onSelecionarDia: (dia) {
                  setState(() {
                    diaSelecionado = dia;
                  });
                },
              ),

              const SizedBox(height: 24),

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
                    fontWeight: FontWeight.w400,
                  ),
                )
              else
                Column(
                  children: eventosNaData.map((evento) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CardEvento(evento: evento),
                    );
                  }).toList(),
                ),

              const SizedBox(height: 20),

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

              if (eventos.isEmpty)
                const Text(
                  'Não há eventos neste mês.',
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    color: Color(0xFF9A948F),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                )
              else
                Column(
                  children: eventos.map((evento) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CardEvento(evento: evento),
                    );
                  }).toList(),
                ),

              const SizedBox(height: 90),
            ],
          ),
        ),
      ),
    );
  }
}

class _Calendario extends StatelessWidget {
  final int diaSelecionado;
  final Function(int dia) onSelecionarDia;

  const _Calendario({
    required this.diaSelecionado,
    required this.onSelecionarDia,
  });

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

    final List<int> diasMes = [
      1, 2, 3, 4, 5, 6, 7,
      8, 9, 10, 11, 12, 13, 14,
      15, 16, 17, 18, 19, 20, 21,
      22, 23, 24, 25, 26, 27, 28,
      29, 30, 31, 1, 2, 3, 4,
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE6E1DC),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.chevron_left,
                  color: Colors.black,
                  size: 22,
                ),
              ),

              const Expanded(
                child: Center(
                  child: Text(
                    'março 2026',
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),

              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.chevron_right,
                  color: Colors.black,
                  size: 22,
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: diasSemana.map((dia) {
              return SizedBox(
                width: 32,
                child: Center(
                  child: Text(
                    dia,
                    style: const TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      color: Color(0xFF9A948F),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
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
            itemCount: diasMes.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 4,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) {
              final dia = diasMes[index];
              final selecionado = dia == diaSelecionado && index < 31;

              return GestureDetector(
                onTap: () {
                  if (index < 31) {
                    onSelecionarDia(dia);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: selecionado
                        ? const Color(0xFFE76E50)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      dia.toString(),
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        color: selecionado ? Colors.white : Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
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

class CardEvento extends StatelessWidget {
  final EventoAgenda evento;

  const CardEvento({
    super.key,
    required this.evento,
  });

  @override
  Widget build(BuildContext context) {
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

                const SizedBox(height: 4),

                Text(
                  '${evento.data}    ${evento.horario}',
                  style: const TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    color: Color(0xFF9A948F),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          Text(
            '${evento.progresso}%',
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

class EventoAgenda {
  final String titulo;
  final String data;
  final String horario;
  final int progresso;
  final int dia;

  EventoAgenda({
    required this.titulo,
    required this.data,
    required this.horario,
    required this.progresso,
    required this.dia,
  });
}
