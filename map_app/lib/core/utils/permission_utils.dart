import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../error/error_handler.dart';

final permissionHandlerProvider = Provider<PermissionHandler>((ref) {
  return PermissionHandler();
});

class PermissionHandler {
  Future<bool> requestPermission(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }

  Future<bool> checkPermission(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  Future<bool> requestCameraPermission() async {
    return await requestPermission(Permission.camera);
  }

  Future<bool> requestStoragePermission() async {
    return await requestPermission(Permission.storage);
  }

  Future<bool> requestLocationPermission() async {
    return await requestPermission(Permission.location);
  }

  Future<bool> requestNotificationPermission() async {
    return await requestPermission(Permission.notification);
  }

  Future<bool> checkCameraPermission() async {
    return await checkPermission(Permission.camera);
  }

  Future<bool> checkStoragePermission() async {
    return await checkPermission(Permission.storage);
  }

  Future<bool> checkLocationPermission() async {
    return await checkPermission(Permission.location);
  }

  Future<bool> checkNotificationPermission() async {
    return await checkPermission(Permission.notification);
  }

  Future<void> openAppSettings() async {
    await openAppSettings();
  }

  Future<bool> requestMultiplePermissions(List<Permission> permissions) async {
    final results = await permissions.request();
    return results.values.every((status) => status.isGranted);
  }

Future<bool> checkMultiplePermissions(List<Permission> permissions) async {
  for (final permission in permissions) {
    final status = await permission.status;
    if (!status.isGranted) {
      return false;
    }
  }
  return true;
}
} 