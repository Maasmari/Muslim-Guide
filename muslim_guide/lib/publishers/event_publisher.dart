import 'dart:async';

class EventPublisher {
  static final EventPublisher _instance = EventPublisher._internal();
  final _streamController = StreamController.broadcast();

  factory EventPublisher() {
    return _instance;
  }

  EventPublisher._internal();

  Stream get onEvent => _streamController.stream;

  void publish(dynamic event) {
    _streamController.add(event);
  }

  void dispose() {
    _streamController.close();
  }
}
