import 'dart:async';
import 'dart:math';

class ImageLogic {
  final List<String> universityImages = [
    'assets/university/uni_monte.jpg',
    'assets/university/uni_cdn.png',
    'assets/university/uni_centrale.png',
    'assets/university/uni_medina.jpeg',
    'assets/university/uni_nola.jpeg',
    'assets/university/uni_villadoria.jpeg',
  ];

  late String currentImage;
  late Random random;
  late Timer _timer;
  late Function()
      onImageChange; // Funzione callback per notificare il cambio di immagine

  ImageLogic(this.onImageChange) {
    random = Random();
    currentImage = universityImages[random.nextInt(universityImages.length)];
    _startTimer();
  }

  String getCurrentImage() {
    return currentImage;
  }

  String getNextImage() {
    currentImage = universityImages[random.nextInt(universityImages.length)];
    return currentImage;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      currentImage = getNextImage();
      onImageChange(); // Notifica al widget che l'immagine è cambiata
    });
  }

  void stopTimer() {
    _timer.cancel();
  }
}
