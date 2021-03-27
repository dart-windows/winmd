@TestOn('windows')

import 'package:test/test.dart';
import 'package:winmd/winmd.dart';

void main() {
  final scope = MetadataStore.getWin32Scope();

  test('Struct has expected number of fields', () {
    final xform = scope['Windows.Win32.Gdi.XFORM']!;
    expect(xform.fields.length, equals(6));
  });

  test('Struct primitive field has expected name and type', () {
    final xform = scope['Windows.Win32.Gdi.XFORM']!;
    expect(xform.fields.first.name, equals('eM11'));
    expect(xform.fields.first.typeIdentifier.corType,
        equals(CorElementType.ELEMENT_TYPE_R4));
  });

  test('Struct valuetype field has expected name and type', () {
    final procInfo = scope['Windows.Win32.SystemServices.PROCESS_INFORMATION']!;
    expect(procInfo.fields.first.name, equals('hProcess'));
    expect(procInfo.fields.first.typeIdentifier.corType,
        equals(CorElementType.ELEMENT_TYPE_VALUETYPE));
    expect(procInfo.fields.first.typeIdentifier.name, endsWith('HANDLE'));
  });

  test('Struct array field has expected name and type', () {
    final procInfo = scope['Windows.Win32.Gdi.BITMAPINFO']!;
    expect(procInfo.fields.last.name, equals('bmiColors'));
    expect(procInfo.fields.last.typeIdentifier.corType,
        equals(CorElementType.ELEMENT_TYPE_ARRAY));
    expect(procInfo.fields.last.typeIdentifier.name, endsWith('RGBQUAD'));
  });

  test('Struct array field projects correctly', () {
    final procInfo = scope['Windows.Win32.Gdi.BITMAPINFO']!;
    final bmiColors = procInfo.fields.last.typeIdentifier;

    final nativeType = TypeProjector(bmiColors).nativeType;
    final dartType = TypeProjector(bmiColors).dartType;
    expect(nativeType, equals('RGBQUAD'));
    expect(dartType, equals('RGBQUAD'));
  });
}
