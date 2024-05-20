import 'dart:io';

class Device {
  Device({
    required this.id,
    this.name,
  });

  final String id;
  final String? name;
}

Future<List<Device>> getDevices() async {
  final result = await Process.run('flutter', ['devices']);
  final devices = result.stdout.toString().split('\n');

  return devices.where((device) => device.contains('•')).map((device) {
    final parts = device.split('•');

    return Device(
      id: parts[1].trim(),
      name: parts[0].trim(),
    );
  }).toList();
}

Future<Device?> selectDevice(List<Device> devices) async {
  if (devices.isEmpty) {
    print('No devices found.');
    return null;
  }

  print('Available devices:');
  for (int i = 0; i < devices.length; i++) {
    print('${i + 1}. ${devices[i].name} (${devices[i].id})');
  }

  stdout.write('Select a device (enter the number): ');
  final input = stdin.readLineSync();
  if (input == null) {
    return null;
  }

  final index = int.tryParse(input);
  if (index == null || index < 1 || index > devices.length) {
    print('Invalid selection.');
    return null;
  }

  return devices[index - 1];
}
