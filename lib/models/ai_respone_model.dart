class AiResponseModel {
  final String id;
  final String diaryEntryId;
  final String encryptedResponse;
  final DateTime createdAt;

  const AiResponseModel({
    required this.id,
    required this.diaryEntryId,
    required this.encryptedResponse,
    required this.createdAt,
  });
}
