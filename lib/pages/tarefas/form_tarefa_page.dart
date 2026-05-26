import 'package:flutter/material.dart';

import '../../components/card_erro.dart';
import 'tarefas_models.dart';
import 'tarefas_shared.dart';

class FormTarefaPage extends StatefulWidget {
  const FormTarefaPage({
    super.key,
    this.initialTask,
  });

  final EventTask? initialTask;

  @override
  State<FormTarefaPage> createState() => _FormTarefaPageState();
}

class _FormTarefaPageState extends State<FormTarefaPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _responsibleController;
  late DateTime _selectedDate;

  bool get _isEditing => widget.initialTask != null;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTask?.title ?? '');
    _responsibleController = TextEditingController(
      text: widget.initialTask?.responsible ?? '',
    );
    _selectedDate = widget.initialTask?.dueDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _responsibleController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: TaskPalette.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submit() {
    if (_titleController.text.trim().isEmpty) {
      showDialog(
        context: context,
        builder: (_) => const CardErro(
          mensagem: 'Informe o título da tarefa.',
        ),
      );
      return;
    }

    final baseTask = widget.initialTask;
    final task = EventTask(
      id: baseTask?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      responsible: _responsibleController.text.trim().isEmpty
          ? 'Não definido'
          : _responsibleController.text.trim(),
      dueDate: _selectedDate,
      isCompleted: baseTask?.isCompleted ?? false,
    );

    Navigator.pop(context, task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TaskPalette.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 14),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, size: 24, color: TaskPalette.text),
              ),
              const SizedBox(height: 8),
              Text(
                _isEditing ? 'Editar Tarefa' : 'Nova Tarefa',
                style: const TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: TaskPalette.text,
                ),
              ),
              const SizedBox(height: 12),
              const Divider(color: TaskPalette.border),
              const SizedBox(height: 18),
              _TaskInputField(
                label: 'Título da tarefa *',
                controller: _titleController,
                hintText: 'Tarefa 1',
              ),
              const SizedBox(height: 14),
              _TaskInputField(
                label: 'Responsável',
                controller: _responsibleController,
                hintText: 'Carlos, João, etc.',
              ),
              const SizedBox(height: 14),
              _TaskDateField(
                label: 'Prazo *',
                value: TaskDateFormatter.fullDate(_selectedDate),
                onTap: _selectDate,
              ),
              const SizedBox(height: 18),
              TaskPrimaryButton(
                label: _isEditing ? 'Salvar Alterações' : 'Adicionar Tarefa',
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskInputField extends StatelessWidget {
  const _TaskInputField({
    required this.label,
    required this.controller,
    required this.hintText,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: TaskPalette.border),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: TaskPalette.text,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: 16,
            color: TaskPalette.text,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              fontFamily: 'SpaceGrotesk',
              color: TaskPalette.muted,
            ),
            filled: true,
            fillColor: TaskPalette.surface,
            border: border,
            enabledBorder: border,
            focusedBorder: border.copyWith(
              borderSide: const BorderSide(color: TaskPalette.primary),
            ),
          ),
        ),
      ],
    );
  }
}

class _TaskDateField extends StatelessWidget {
  const _TaskDateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: TaskPalette.border),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'SpaceGrotesk',
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: TaskPalette.text,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: InputDecorator(
            decoration: InputDecoration(
              suffixIcon: const Icon(
                Icons.calendar_today_outlined,
                size: 18,
                color: TaskPalette.text,
              ),
              filled: true,
              fillColor: TaskPalette.surface,
              border: border,
              enabledBorder: border,
            ),
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'SpaceGrotesk',
                fontSize: 16,
                color: TaskPalette.text,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
