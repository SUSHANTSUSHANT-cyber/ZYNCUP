import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../profile/screens/scanned_profile_screen.dart';
import '../../profile/services/profile_service.dart';

class ScanZyncupScreen extends StatefulWidget {
  const ScanZyncupScreen({
    super.key,
  });

  @override
  State<ScanZyncupScreen> createState() => _ScanZyncupScreenState();
}

class _ScanZyncupScreenState extends State<ScanZyncupScreen> {
  final MobileScannerController _controller = MobileScannerController();

  bool _handledScan = false;
  bool _isLoadingProfile = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleDetection(BarcodeCapture capture) async {
    if (_handledScan || _isLoadingProfile) return;

    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue?.trim();

      if (value == null || value.isEmpty) {
        continue;
      }

      if (!value.startsWith('ZYNC-')) {
        continue;
      }

      _handledScan = true;
      _isLoadingProfile = true;

      await _controller.stop();

      if (!mounted) return;

      await _showProfile(value);

      return;
    }
  }

  Future<void> _showProfile(String zyncupId) async {
    try {
      final profile =
          await ProfileService.getProfileByZyncupId(zyncupId);

      if (!mounted) return;

      if (profile == null) {
        _handledScan = false;
        _isLoadingProfile = false;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No ZYNCUP profile found for $zyncupId.',
            ),
          ),
        );

        await _controller.start();
        return;
      }

      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ScannedProfileScreen(
            profile: profile,
          ),
        ),
      );

      if (!mounted) return;

      _handledScan = false;
      _isLoadingProfile = false;

      await _controller.start();
    } catch (_) {
      if (!mounted) return;

      _handledScan = false;
      _isLoadingProfile = false;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Unable to load this ZYNCUP profile. Please try again.',
          ),
        ),
      );

      await _controller.start();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan ZYNCUP Code'),
        actions: [
          IconButton(
            tooltip: 'Toggle flashlight',
            onPressed: () => _controller.toggleTorch(),
            icon: const Icon(Icons.flashlight_on_outlined),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _handleDetection,
          ),

          Center(
            child: Container(
              width: 270,
              height: 270,
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colorScheme.primary,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),

          if (_isLoadingProfile)
            Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 14),
                      Text(
                        'Finding ZYNCUP profile...',
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),

          Positioned(
            left: 24,
            right: 24,
            bottom: 40,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.qr_code_scanner,
                      color: theme.colorScheme.primary,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Scan a ZYNCUP Code',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Place the QR code inside the frame.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


