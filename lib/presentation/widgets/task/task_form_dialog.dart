import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_aiagent/domain/entities/task.dart';
import 'package:task_aiagent/domain/usecases/task/task_formatting_usecase.dart';
import 'package:task_aiagent/domain/usecases/task/task_management_usecase.dart';

class TaskFormDialog extends StatefulWidget {
  final Task? task;
  final Function(Task) onSave;

  const TaskFormDialog({
    super.key,
    this.task,
    required this.onSave,
  });

  @override
  State<TaskFormDialog> createState() => _TaskFormDialogState();
}

class _TaskFormDialogState extends State<TaskFormDialog> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _estimatedMinutesController;

  TaskPriority _priority = TaskPriority.medium;
  DateTime? _dueDate;
  bool _isToday = false;

  final _taskManagement = TaskManagementUseCase();
  final _taskFormatter = TaskFormattingUseCase();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _loadTaskData();
  }

  void _initializeControllers() {
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _estimatedMinutesController = TextEditingController(
      text: widget.task?.estimatedMinutes.toString() ?? '30',
    );
  }

  void _loadTaskData() {
    if (widget.task != null) {
      _priority = widget.task!.priority;
      _dueDate = widget.task!.dueDate;
      _isToday = widget.task!.isToday;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _estimatedMinutesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task == null ? 'タスクを追加' : 'タスクを編集'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitleField(),
            const SizedBox(height: 16),
            _buildDescriptionField(),
            const SizedBox(height: 16),
            _buildPriorityField(),
            const SizedBox(height: 16),
            _buildEstimatedTimeField(),
            const SizedBox(height: 16),
            _buildDueDateSection(),
            const SizedBox(height: 16),
            _buildTodayCheckbox(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('キャンセル'),
        ),
        ElevatedButton(
          onPressed: _saveTask,
          child: const Text('保存'),
        ),
      ],
    );
  }

  Widget _buildTitleField() {
    return TextField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'タスク名 *',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return TextField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: '説明',
        border: OutlineInputBorder(),
      ),
      maxLines: 3,
    );
  }

  Widget _buildPriorityField() {
    return DropdownButtonFormField<TaskPriority>(
      value: _priority,
      decoration: const InputDecoration(
        labelText: '優先度',
        border: OutlineInputBorder(),
      ),
      items: TaskPriority.values.map((priority) {
        final indicatorData = _taskFormatter.getPriorityIndicatorData(priority);
        return DropdownMenuItem(
          value: priority,
          child: Row(
            children: [
              Icon(
                indicatorData.icon,
                color: indicatorData.color,
              ),
              const SizedBox(width: 8),
              Text(_taskFormatter.getPriorityLabel(priority)),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _priority = value!;
        });
      },
    );
  }

  Widget _buildEstimatedTimeField() {
    return TextField(
      controller: _estimatedMinutesController,
      decoration: const InputDecoration(
        labelText: '所要時間（分）',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildDueDateSection() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _selectDueDate(context),
            icon: const Icon(Icons.calendar_today),
            label: Text(
              _dueDate == null
                  ? 'いつまで'
                  : DateFormat('M/d (E)', 'ja').format(_dueDate!),
            ),
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton(
          onPressed: _setDueDateToday,
          child: const Text('今日'),
        ),
        const SizedBox(width: 8),
        OutlinedButton(
          onPressed: _setDueDateTomorrow,
          child: const Text('明日'),
        ),
      ],
    );
  }

  Widget _buildTodayCheckbox() {
    return CheckboxListTile(
      title: const Text('今日のタスクにする'),
      value: _isToday,
      onChanged: (value) {
        setState(() {
          _isToday = value ?? false;
        });
      },
    );
  }

  void _setDueDateToday() {
    setState(() {
      final now = DateTime.now();
      _dueDate = DateTime(now.year, now.month, now.day);
    });
  }

  void _setDueDateTomorrow() {
    setState(() {
      final now = DateTime.now();
      _dueDate = DateTime(now.year, now.month, now.day + 1);
    });
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('ja'),
    );

    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  void _saveTask() {
    final estimatedMinutes = int.tryParse(_estimatedMinutesController.text) ?? 30;

    // バリデーション
    final validation = _taskManagement.validateTask(
      title: _titleController.text.trim(),
      estimatedMinutes: estimatedMinutes,
    );

    if (!validation.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validation.errors.first)),
      );
      return;
    }

    final task = widget.task?.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          priority: _priority,
          estimatedMinutes: estimatedMinutes,
          dueDate: _dueDate,
          isToday: _isToday,
        ) ??
        Task(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          priority: _priority,
          estimatedMinutes: estimatedMinutes,
          dueDate: _dueDate,
          isToday: _isToday,
        );

    widget.onSave(task);
    Navigator.of(context).pop();
  }
}