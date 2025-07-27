// lib/presentation/screens/barcode/barcode_scanner_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_mobile/config/router/app_route_constants.dart';
import 'package:flutter_mobile/config/theme/theme_data_config.dart';
import 'package:flutter_mobile/presentation/bloc/services/services_cubit.dart';
import 'package:flutter_mobile/presentation/widgets/base_widgets/simple_custom_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  late MobileScannerController cameraController;
  bool _hasScanned = false;
  bool _isTorchOn = false;

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController(
      formats: [BarcodeFormat.all],
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasScanned) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
      setState(() {
        _hasScanned = true;
      });

      final String barcode = barcodes.first.rawValue!;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Code scanné: $barcode'),
          duration: const Duration(seconds: 1),
        ),
      );

      context.read<ServicesCubit>().fetchMedicineByBarcode(barcode);
      context.pushReplacementNamed(AppRouteName.medicineSearchResult);
    }
  }

  void _toggleTorch() async {
    try {
      await cameraController.toggleTorch();
      setState(() {
        _isTorchOn = !_isTorchOn;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur avec la lampe: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _switchCamera() async {
    try {
      await cameraController.switchCamera();
      setState(() {
        _isTorchOn = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur changement caméra: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildScanningOverlay() {
    return Center(
      child: Container(
        width: 280.w,
        height: 180.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white.withOpacity(0.8),
            width: 2.w,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Stack(
          children: [
            // Corner brackets
            ...List.generate(4, (index) {
              final positions = [
                {'top': 0.0, 'left': 0.0}, // Top-left
                {'top': 0.0, 'right': 0.0}, // Top-right
                {'bottom': 0.0, 'left': 0.0}, // Bottom-left
                {'bottom': 0.0, 'right': 0.0}, // Bottom-right
              ];

              final pos = positions[index];
              return Positioned(
                top: pos['top']?.toDouble(),
                left: pos['left']?.toDouble(),
                right: pos['right']?.toDouble(),
                bottom: pos['bottom']?.toDouble(),
                child: Container(
                  width: 24.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    border: Border(
                      top: index < 2
                          ? BorderSide(color: theme().colorScheme.secondary, width: 4.w)
                          : BorderSide.none,
                      bottom: index >= 2
                          ? BorderSide(color: theme().colorScheme.secondary, width: 4.w)
                          : BorderSide.none,
                      left: index == 0 || index == 2
                          ? BorderSide(color: theme().colorScheme.secondary, width: 4.w)
                          : BorderSide.none,
                      right: index == 1 || index == 3
                          ? BorderSide(color: theme().colorScheme.secondary, width: 4.w)
                          : BorderSide.none,
                    ),
                  ),
                ),
              );
            }),

            // Scanning line animation
            Center(
              child: Container(
                width: double.infinity,
                height: 2.h,
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      theme().colorScheme.secondary.withOpacity(0.8),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionPanel() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28.r),
          topRight: Radius.circular(28.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10.r,
            offset: Offset(0, -2.h),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag indicator
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),

            // Main instruction
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: theme().colorScheme.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.qr_code_scanner,
                    size: 24.sp,
                    color: theme().colorScheme.secondary,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Scanner le code-barres',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Centrez le code dans le cadre',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 16.h),

            // Status indicator
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: Colors.green.withOpacity(0.3),
                  width: 1.w,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.camera_alt,
                    size: 18.sp,
                    color: Colors.green[600],
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Caméra active - Prêt à scanner',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.green[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleCustomAppBar(title: "Scanner Code-barres"),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera view (full screen)
          Positioned.fill(
            child: MobileScanner(
              controller: cameraController,
              onDetect: _onDetect,
              errorBuilder: (context, error) {
                return Container(
                  color: Colors.black,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48.sp,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Erreur de caméra',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.w),
                          child: Text(
                            error.errorDetails?.message ?? 'Impossible d\'accéder à la caméra',
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: 14.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Scanning overlay
          _buildScanningOverlay(),

          // Torch indicator
          if (_isTorchOn)
            Positioned(
              top: 20.h,
              right: 20.w,
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.yellow.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(
                  Icons.flash_on,
                  color: Colors.black,
                  size: 20.sp,
                ),
              ),
            ),

          // Bottom instruction panel
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildInstructionPanel(),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 120.h), // Above the instruction panel
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: "torch",
              onPressed: _toggleTorch,
              backgroundColor: _isTorchOn
                  ? Colors.yellow[600]
                  : Colors.white.withOpacity(0.9),
              elevation: 8,
              child: Icon(
                _isTorchOn ? Icons.flash_on : Icons.flash_off,
                color: _isTorchOn ? Colors.black : Colors.grey[700],
              ),
            ),
            SizedBox(width: 12.w),
            FloatingActionButton(
              heroTag: "camera",
              onPressed: _switchCamera,
              backgroundColor: Colors.white.withOpacity(0.9),
              elevation: 8,
              child: Icon(
                Icons.flip_camera_android,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}