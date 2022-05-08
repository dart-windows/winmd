@TestOn('windows')

import 'dart:io';

import 'package:test/test.dart';
import 'package:win32/win32.dart';
import 'package:winmd/winmd.dart';

void main() {
  test('MetadataStore explicit initialization', () {
    MetadataStore.initialize();
    final scope = MetadataStore.getWin32Scope();
    expect(scope.typeDefs.length, isPositive);
    MetadataStore.close();
  });

  test('MetadataStore implicit initialization', () {
    final scope = MetadataStore.getWin32Scope();

    expect(scope.typeDefs.length, isPositive);
    MetadataStore.close();
  });

  test('MetadataStore reinitialization', () {
    final scope = MetadataStore.getWin32Scope();

    expect(scope.typeDefs.length, isPositive);
    MetadataStore.close();

    MetadataStore.initialize();
    final scope2 = MetadataStore.getWin32Scope();

    expect(scope2.typeDefs.length, isPositive);
    MetadataStore.close();
  });

  test('MetadataStore scopes are successfully cached', () {
    final scope = MetadataStore.getWin32Scope();

    final scope2 = MetadataStore.getScopeForType('Windows.Win32.Shell.Apis');
    expect(scope, equals(scope2));
  });

  test('MetadataStore scope prints successfully', () {
    MetadataStore.getWin32Scope();
    MetadataStore.getScopeForType('Windows.Win32.Shell.Apis');
    expect(MetadataStore.cache.length, equals(1));
    expect(MetadataStore.cacheInfo, equals('[Windows.Win32.winmd]'));
  });

  test('MetadataStore can cache both WinRT and Win32 metadata', () {
    MetadataStore.getScopeForType('Windows.Globalization.Calendar');
    expect(MetadataStore.cache.length, equals(2));
    expect(
        MetadataStore.cacheInfo,
        anyOf(
          equals('[Windows.Globalization.winmd, Windows.Win32.winmd]'),
          equals('[Windows.Win32.winmd, Windows.Globalization.winmd]'),
        ));
  });

  test('Appropriate response to failure to find type', () {
    expect(
        () => MetadataStore.winmdFileContainingType(
            'Windows.Monetization.Dogecoin'),
        throwsA(isA<WindowsException>()));
  });

  test('Appropriate response to search for non-existent type', () {
    expect(() => MetadataStore.getScopeForType('Windows.Monetization.Dogecoin'),
        throwsA(isA<WindowsException>()));
  });

  test('Appropriate response to search for namespace that is not a type', () {
    expect(() => MetadataStore.getScopeForType('Windows.Foundation'),
        throwsA(isA<WindowsException>()));
  });

  test('Appropriate response to failure to find scope from non-winmd file', () {
    final cmdPath = File(r'c:\windows\cmd.exe');
    expect(() => MetadataStore.getScopeForFile(cmdPath),
        throwsA(isA<WindowsException>()));
  });
}
