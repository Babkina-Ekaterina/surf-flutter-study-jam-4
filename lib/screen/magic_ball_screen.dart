import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MagicBallScreen extends StatefulWidget {
  const MagicBallScreen({Key? key}) : super(key: key);

  @override
  _MagicBallScreenState createState() => _MagicBallScreenState();
}

class _MagicBallScreenState extends State<MagicBallScreen> {
  ///возможные ответы шара
  final List<String> magicAnswers = [
    'Нет',
    'Да',
    'Спросите позже',
    'Возможно',
    'Скорее всего',
    'Не уверен',
  ];

  ///текущий ответ
  String currentAnswer = '';
  ///видимость ответа
  bool isAnswerVisible = false;

  ///функция, которая генерирует ответ шара
  void _shakeMagicBall() {
    ///если уже нажали на шар и текст скрылся, не обрабатываем новые нажатия
    if (!isAnswerVisible) {
      return;
    }

    ///делаем предыдущий ответ невидимым
    setState(() {
      isAnswerVisible = false;
    });

    ///после задержки выводим новый ответ
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        currentAnswer = magicAnswers[_getRandomAnswerIndex()];
        isAnswerVisible = true;
      });
    });
  }

  int _getRandomAnswerIndex() {
    return DateTime.now().millisecondsSinceEpoch % magicAnswers.length;
  }

  @override
  Widget build(BuildContext context) {
    ///убираем фон строки состояния
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 4, 15, 38),
            Color.fromARGB(255, 6, 9, 26),
            Color.fromARGB(255, 0, 0, 0)
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _shakeMagicBall,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ///картинка с магическим шаром
                Image.asset('assets/magic_ball.png'),
                Visibility(
                  visible: isAnswerVisible,
                  child: Transform.translate(
                    offset: const Offset(10, 0),
                    ///анимация печати
                    child: TypewriterAnimatedTextKit(
                      text: [currentAnswer],
                      textStyle: const TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.none,
                        fontSize: 35,
                      ),
                      textAlign: TextAlign.center,
                      speed: const Duration(milliseconds: 100),
                      isRepeatingAnimation: false,
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          ///тень под шаром
          ClipOval(
            child: Container(
              width: 300,
              height: 50,
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 4, 15, 38),
                    spreadRadius: 2,
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          const Text('Нажмите на шар',
              style: TextStyle(
                  color: Colors.white24,
                  decoration: TextDecoration.none,
                  fontSize: 25))
        ],
      ),
    );
  }
}
