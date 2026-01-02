import '../models/chapter.dart';

final List<Chapter> chapters = [
  Chapter(id: 'prologue', title: '프롤로그', startEp: 1, endEp: 1),

  Chapter(id: 'chapter1', title: 'Chapter 1. 시작', startEp: 2, endEp: 10),
  Chapter(id: 'chapter2', title: 'Chapter 2. 관계', startEp: 11, endEp: 20),
  Chapter(id: 'chapter3', title: 'Chapter 3. 도전', startEp: 21, endEp: 30),
  Chapter(id: 'chapter4', title: 'Chapter 4. 감정', startEp: 31, endEp: 40),
  Chapter(id: 'chapter5', title: 'Chapter 5. 성장', startEp: 41, endEp: 49),

  Chapter(
    id: 'final',
    title: 'Final Chapter. 나에게',
    startEp: 50,
    endEp: 50,
    isFinal: true,
  ),
];
