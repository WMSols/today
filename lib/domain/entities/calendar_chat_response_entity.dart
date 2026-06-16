import 'package:today/domain/entities/schedule_display_entity.dart';

class CalendarChatResponseEntity {
  const CalendarChatResponseEntity({
    required this.assistantText,
    required this.state,
    required this.scheduleVersion,
    this.scheduleDisplay,
    this.pendingProposalId,
  });

  final String assistantText;
  final String state;
  final int scheduleVersion;
  final ScheduleDisplayEntity? scheduleDisplay;
  final String? pendingProposalId;
}
