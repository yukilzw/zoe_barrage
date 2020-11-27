import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class ChangeMaskEvent {
  String time;
  ChangeMaskEvent(this.time);
}
