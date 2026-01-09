import '../models/chapter.dart';

final List<Chapter> chapters = [
  Chapter(
    id: 'prologue',
    title: 'Prologue',
    description: '프롤로그:청춘기록',
    coverAssets: 'assets/images/chapters/프롤로그.jpeg',
    startEp: 1,
    endEp: 1,
  ),

  Chapter(
    id: 'chapter1',
    title: 'Chapter 1',
    description: '일상의 컷',
    coverAssets: 'assets/images/chapters/프롤로그.jpeg',
    startEp: 2,
    endEp: 10,
  ),
  Chapter(
    id: 'chapter2',
    title: 'Chapter 2',
    description: '관계의 장면',
    coverAssets: 'assets/images/chapters/프롤로그.jpeg',
    startEp: 11,
    endEp: 20,
  ),
  Chapter(
    id: 'chapter3',
    title: 'Chapter 3',
    description: '도전과 흔들림',
    coverAssets: 'assets/images/chapters/프롤로그.jpeg',
    startEp: 21,
    endEp: 30,
  ),
  Chapter(
    id: 'chapter4',
    title: 'Chapter 4',
    description: '감정의 클로즈업',
    coverAssets: 'assets/images/chapters/프롤로그.jpeg',
    startEp: 31,
    endEp: 40,
  ),
  Chapter(
    id: 'chapter5',
    title: 'Chapter 5',
    description: '성장과 회고',
    coverAssets: 'assets/images/chapters/프롤로그.jpeg',
    startEp: 41,
    endEp: 49,
  ),

  Chapter(
    id: 'final',
    title: 'Final Chapter',
    description: '나에게',
    coverAssets: 'assets/images/chapters/프롤로그.jpeg',
    startEp: 50,
    endEp: 50,
    isFinal: true,
  ),
];
