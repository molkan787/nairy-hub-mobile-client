class Thingy {
  int id;
  int type;
  String summary;
  String content;
  int status;
  late DateTime createdAt;
  late DateTime updatedAt;

  bool get isCompleted => _isWithinStatus(ThingyStatus.completed);

  Thingy({
    required this.id,
    required this.type,
    required this.summary,
    required this.content,
    this.status = ThingyStatus.initial,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    this.createdAt = createdAt ?? DateTime.now();
    this.updatedAt = updatedAt ?? DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'summary': summary,
      'content': content,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static Thingy fromMap(Map<String, dynamic> map) {
    return Thingy(
      id: map["id"],
      type: map["type"],
      summary: map["summary"],
      content: map["content"],
      status: map["status"] ?? ThingyStatus.initial,
      createdAt: DateTime.parse(map["createdAt"]),
      updatedAt: DateTime.parse(map["updatedAt"]),
    );
  }

  @override
  String toString() {
    return 'Thingy{id: $id, type: $type, summary: $summary, content: $content, status: $status}';
  }

  void copyTo(Thingy other, {bool includeId = false}) {
    if (includeId) {
      other.id = id;
    }
    other.type = type;
    other.summary = summary;
    other.content = content;
    other.status = status;
    other.createdAt = createdAt;
    other.updatedAt = updatedAt;
  }

  bool _isWithinStatus(int checkStatus) {
    return status >= checkStatus && status < checkStatus + 1000;
  }
}

class ThingyType {
  static const int todoItem = 1;
  static const int reminder = 2;
  static const int note = 3;
}

class ThingyStatus {
  // range of 1 - 999 is reseved for initial sub-statuses
  static const int initial = 1;

  // range of 1000 - 1999 is reseved for completed sub-statuses
  static const int completed = 1000;

  // start other status from 2000

}
