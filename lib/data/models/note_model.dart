class NoteModel {
  final String id;
  final String title;
  final String content;
  final DateTime updatedAt;

  final List<NoteFile> files;

  NoteModel(
      {required this.id,
      required this.title,
      required this.content,
      required this.updatedAt,
      required this.files});

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
        id: json['_id'],
        title: json['title'],
        content: json['content'],
        updatedAt: DateTime.parse(json['updatedAt']),
        files: (json['files'] as List)
            .map((file) => NoteFile.fromJson(file))
            .toList());
  }
}

class NoteFile {
  final String fileId;
  final String fileName;
  final String fileType;

  NoteFile(
      {required this.fileId, required this.fileName, required this.fileType});

  factory NoteFile.fromJson(Map<String, dynamic> json) {
    return NoteFile(
        fileId: json['fileId'],
        fileName: json['fileName'],
        fileType: json['fileType']);
  }
}
