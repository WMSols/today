import 'package:today/data/models/schedule_display_model.dart';
import 'package:today/domain/entities/calendar_chat_response_entity.dart';

class CalendarChatResponseModel extends CalendarChatResponseEntity {
  const CalendarChatResponseModel({
    required super.assistantText,
    required super.state,
    required super.scheduleVersion,
    super.scheduleDisplay,
    super.pendingProposalId,
  });

  factory CalendarChatResponseModel.fromJson(Map<String, dynamic> json) {
    final displayRaw = json['schedule_display'];
    return CalendarChatResponseModel(
      assistantText: json['assistant_text'] as String? ?? '',
      state: json['state'] as String? ?? 'idle',
      scheduleVersion: (json['schedule_version'] as num?)?.toInt() ?? 0,
      scheduleDisplay:
          displayRaw is Map<String, dynamic> && displayRaw.isNotEmpty
          ? ScheduleDisplayModel.fromJson(displayRaw)
          : null,
      pendingProposalId: json['pending_proposal_id'] as String?,
    );
  }
}
