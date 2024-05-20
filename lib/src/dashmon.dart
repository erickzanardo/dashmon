import 'dart:io';
import 'dart:convert';

import '../src/device_selection.dart';

class Dashmon {
  late Process _process;
  final List<String> args;

  Future? _throttler;

  final List<String> _proxiedArgs = [];
  bool _isFvm = false;
  bool _isAttach = false;

  Dashmon(this.args) {
    _parseArgs();
  }

  void _parseArgs() {
    for (String arg in args) {
      if (arg == '--fvm') {
        _isFvm = true;
        continue;
      }

      if (arg == 'attach') {
        _isAttach = true;
        continue;
      }

      _proxiedArgs.add(arg);
    }
  }

  Future<void> _runUpdate() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _process.stdin.write('r');
  }

  void _print(String line) {
    final trim = line.trim();
    if (trim.isNotEmpty) {
      print(trim);
    }
  }

  void _processLine(String line) {
    _print(line);
  }

  void _processError(String line) {
    _print(line);
  }

  Future<void> start() async {
    Device? selectedDevice;
    final devices = await getDevices();

    if (devices.length > 1) {
      selectedDevice = await selectDevice(devices);

      if (selectedDevice == null) {
        print('No device selected.');
        exit(1);
      }

      _proxiedArgs.add('--device-id=${selectedDevice.id}');
    }

    _process = await (_isFvm
        ? Process.start('fvm', ['flutter', _isAttach ? 'attach' : 'run', ..._proxiedArgs])
        : Process.start('flutter', [_isAttach ? 'attach' : 'run', ..._proxiedArgs]));

    _process.stdout.transform(utf8.decoder).forEach(_processLine);
    _process.stderr.transform(utf8.decoder).forEach(_processError);

    final currentDir = File('.');

    currentDir.watch(recursive: true).listen((event) {
      if (event.path.startsWith('./lib')) {
        if (_throttler == null) {
          _throttler = _runUpdate();
          _throttler?.then((_) {
            print('Sent reload request...');
            _throttler = null;
          });
        }
      }
    });

    stdin.lineMode = false;
    stdin.echoMode = false;

    stdin.transform(utf8.decoder).listen((input) {
      switch (input.trim()) {
        case 'c':
          for (int i = 0; i < stdout.terminalLines; i++) {
            stdout.writeln();
          }
          break;
        default:
          _process.stdin.write(input);
      }
    });

    final exitCode = await _process.exitCode;
    exit(exitCode);
  }
}
