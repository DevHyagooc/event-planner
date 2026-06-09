import 'package:flutter/material.dart';
import '../models/evento.dart';
import '../services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class EditarEvento extends StatefulWidget {
  final Evento? evento;

  const EditarEvento({super.key, this.evento});

  @override
  State<EditarEvento> createState() => _EditarEventoState();
}

class _EditarEventoState extends State<EditarEvento> {
  late TextEditingController _nomeController;
  late TextEditingController _localController;
  late TextEditingController _descricaoController;
  late DateTime _dataSelecionada;
  late EventoStatus _statusSelecionado;
  final FirestoreService _firestoreService = FirestoreService();
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.evento?.titulo ?? '');
    _localController = TextEditingController(text: widget.evento?.local ?? '');
    _descricaoController = TextEditingController(
      text: widget.evento?.descricao ?? '',
    );
    _dataSelecionada = widget.evento?.data ?? DateTime.now();
    _statusSelecionado = widget.evento?.status ?? EventoStatus.planejando;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _localController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _salvarEvento() async {
    if (_nomeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, informe o nome do evento')),
      );
      return;
    }

    final currentUserId =
        FirebaseAuth.instance.currentUser?.uid ?? 'user-teste-123';
    if (currentUserId.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Usuário não autenticado.')));
      return;
    }

    setState(() => _carregando = true);

    try {
      final evento = Evento(
        id: widget.evento?.id ?? '',
        userId: widget.evento?.userId ?? currentUserId,
        titulo: _nomeController.text.trim(),
        descricao: _descricaoController.text.trim(),
        local: _localController.text.trim(),
        data: _dataSelecionada,
        status: _statusSelecionado,
        totalTarefas: widget.evento?.totalTarefas ?? 0,
        tarefasConcluidas: widget.evento?.tarefasConcluidas ?? 0,
        createdAt: widget.evento?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestoreService.saveEvento(evento);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao salvar evento: $e')));
      }
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _selecionarData() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFE76E50),
              onPrimary: Colors.white,
              onSurface: Color(0xFF111111),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dataSelecionada = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const coral = Color(0xFFE76E50);
    const textDark = Color(0xFF111111);
    const bgInput = Color(0xFFF9F9F9);
    const borderGray = Color(0xFFE8E2DE);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.evento == null ? 'Novo Evento' : 'Editar Evento',
          style: const TextStyle(
            fontFamily: 'SpaceGrotesk',
            color: textDark,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Nome do evento *'),
            _buildTextField(
              _nomeController,
              'Aniversário de João',
              bgInput,
              borderGray,
            ),

            const SizedBox(height: 20),
            _buildLabel('Data *'),
            GestureDetector(
              onTap: _selecionarData,
              child: _buildPickerTile(
                DateFormat('dd/MM/yyyy').format(_dataSelecionada),
                Icons.calendar_today_outlined,
                bgInput,
                borderGray,
              ),
            ),

            const SizedBox(height: 20),
            _buildLabel('Local'),
            _buildTextField(
              _localController,
              'Salão de festas',
              bgInput,
              borderGray,
            ),

            const SizedBox(height: 20),
            _buildLabel('Descrição'),
            _buildTextField(
              _descricaoController,
              'Descrição',
              bgInput,
              borderGray,
              maxLines: 4,
            ),

            const SizedBox(height: 20),
            _buildLabel('Status'),
            _buildStatusDropdown(bgInput, borderGray),

            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _carregando ? null : _salvarEvento,
                style: ElevatedButton.styleFrom(
                  backgroundColor: coral,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _carregando
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        widget.evento == null
                            ? 'Criar Evento'
                            : 'Salvar Alterações',
                        style: const TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'SpaceGrotesk',
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Color(0xFF111111),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    Color bg,
    Color border, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFFBCBCBC),
          fontFamily: 'SpaceGrotesk',
        ),
        filled: true,
        fillColor: bg,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border),
        ),
      ),
    );
  }

  Widget _buildPickerTile(String value, IconData icon, Color bg, Color border) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'SpaceGrotesk',
              fontSize: 15,
              color: Color(0xFF111111),
            ),
          ),
          Icon(icon, color: Colors.black, size: 20),
        ],
      ),
    );
  }

  Widget _buildStatusDropdown(Color bg, Color border) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<EventoStatus>(
          value: _statusSelecionado,
          isExpanded: true,
          items: EventoStatus.values.map((status) {
            String label;
            switch (status) {
              case EventoStatus.planejando:
                label = 'Planejando';
                break;
              case EventoStatus.concluido:
                label = 'Concluído';
                break;
              case EventoStatus.cancelado:
                label = 'Cancelado';
                break;
            }
            return DropdownMenuItem(
              value: status,
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 15,
                ),
              ),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) setState(() => _statusSelecionado = val);
          },
        ),
      ),
    );
  }
}
