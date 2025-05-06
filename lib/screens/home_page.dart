import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/light_controller.dart';

class HomeScreen extends StatelessWidget {
  final c = Get.put(LightController());
  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: Text('کنترل لامپ')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ۱٫ فیلد IP
            TextField(
              decoration: InputDecoration(
                labelText: 'IP دستگاه',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
              onChanged: (v) {
                c.ip.value = v.trim();
                c.sendCommand(''); // فقط برای ذخیره IP
              },
            ),
            SizedBox(height: 16),

            // ۲٫ روشن و خاموش دستی
            ElevatedButton(onPressed: c.turnOn,  child: Text('روشن')),
            SizedBox(height: 8),
            ElevatedButton(onPressed: c.turnOff, child: Text('خاموش')),
            SizedBox(height: 16),

            // ۳٫ سوییچ حالت اتوماتیک
            Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('حالت خودکار'),
                Switch(
                  value: c.isAuto.value,
                  onChanged: (_) => c.toggleAuto(),
                ),
              ],
            )),
            SizedBox(height: 16),

            // ۴٫ فرمان صوتی
            ElevatedButton.icon(
              onPressed: c.listen,
              icon: Icon(Icons.mic),
              label: Text('فرمان صوتی'),
            ),
            SizedBox(height: 16),

            // ۵٫ نمایش وضعیت
            Obx(() => Text(
              '${c.status.value}',
              style: TextStyle(color: Colors.blue),
            )),
          ],
        ),
      ),
    );
  }
}