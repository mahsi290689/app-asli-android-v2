import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LightController extends GetxController {
  final ip = RxString('192.168.1.100');
  final isAuto = false.obs;
  final status = ''.obs;
  late SpeechToText _speech;

  @override
  void onInit() {
    super.onInit();
    _speech = SpeechToText();
    _loadIp();
  }

  Future<void> _loadIp() async {
    final p = await SharedPreferences.getInstance();
    ip.value = p.getString('esp_ip') ?? ip.value;
  }
  Future<void> _saveIp(String v) async {
    final p = await SharedPreferences.getInstance();
    await p.setString('esp_ip', v);
  }

  Future<void> sendCommand(String path) async {
    final url = Uri.parse('http://${ip.value}/$path');
    try {
      final r = await http.get(url);
      status.value = (r.statusCode == 200)
          ? 'OK: $path'
          : 'HTTP ${r.statusCode}';
    } catch (e) {
      status.value = 'ERR';
    }
  }

  void turnOn()    => sendCommand('on');
  void turnOff()   => sendCommand('off');
  void toggleAuto(){
    isAuto.value = !isAuto.value;
    sendCommand(isAuto.value ? 'auto/on' : 'auto/off');
  }

  Future<void> listen() async {
    final ok = await _speech.initialize();
    if (!ok) { status.value = 'Voice init ERR'; return; }
    _speech.listen(onResult: (r) {
      final txt = r.recognizedWords;
      if (txt.contains('روشن'))       turnOn();
      else if (txt.contains('خاموش')) turnOff();
      else if (txt.contains('خودکار')) {
        if (!isAuto.value) toggleAuto();
      } else if (txt.contains('دستی')) {
        if (isAuto.value) toggleAuto();
      }
      _speech.stop();
    });
  }
}