@TestOn('windows')

import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';
import 'package:winmd/winmd.dart';

/// Exhaustively test a WinRT interface representation without generics
void main() {
  // .class interface public auto ansi abstract import windowsruntime Windows.Foundation.IAsyncInfo
  // {
  // 	.custom instance void [Windows.Foundation.winmd]Windows.Foundation.Metadata.GuidAttribute::.ctor(uint32, uint16, uint16, uint8, uint8, uint8, uint8, uint8, uint8, uint8, uint8) = (
  // 		01 00 36 00 00 00 00 00 00 00 c0 00 00 00 00 00
  // 		00 46 00 00
  // 	)
  // 	.custom instance void [Windows.Foundation.winmd]Windows.Foundation.Metadata.ContractVersionAttribute::.ctor(class [mscorlib]System.Type, uint32) = (
  // 		01 00 25 57 69 6e 64 6f 77 73 2e 46 6f 75 6e 64
  // 		61 74 69 6f 6e 2e 46 6f 75 6e 64 61 74 69 6f 6e
  // 		43 6f 6e 74 72 61 63 74 00 00 01 00 00 00
  // 	)
  // 	// Methods
  // 	.method public hidebysig specialname newslot abstract virtual
  // 		instance uint32 get_Id () runtime managed internalcall
  // 	{
  // 	} // end of method IAsyncInfo::get_Id

  // 	.method public hidebysig specialname newslot abstract virtual
  // 		instance valuetype [Windows.Foundation.winmd]Windows.Foundation.AsyncStatus get_Status () runtime managed internalcall
  // 	{
  // 	} // end of method IAsyncInfo::get_Status

  // 	.method public hidebysig specialname newslot abstract virtual
  // 		instance valuetype [System.Runtime]System.Exception get_ErrorCode () runtime managed internalcall
  // 	{
  // 	} // end of method IAsyncInfo::get_ErrorCode

  // 	.method public hidebysig newslot abstract virtual
  // 		instance void Cancel () runtime managed internalcall
  // 	{
  // 	} // end of method IAsyncInfo::Cancel

  // 	.method public hidebysig newslot abstract virtual
  // 		instance void Close () runtime managed internalcall
  // 	{
  // 	} // end of method IAsyncInfo::Close

  // 	// Properties
  // 	.property instance valuetype [System.Runtime]System.Exception ErrorCode()
  // 	{
  // 		.get instance valuetype [System.Runtime]System.Exception Windows.Foundation.IAsyncInfo::get_ErrorCode()
  // 	}
  // 	.property instance uint32 Id()
  // 	{
  // 		.get instance uint32 Windows.Foundation.IAsyncInfo::get_Id()
  // 	}
  // 	.property instance valuetype [Windows.Foundation.winmd]Windows.Foundation.AsyncStatus Status()
  // 	{
  // 		.get instance valuetype [Windows.Foundation.winmd]Windows.Foundation.AsyncStatus Windows.Foundation.IAsyncInfo::get_Status()
  // 	}

  // } // end of class Windows.Foundation.IAsyncInfo
  test('Windows.Foundation.IAsyncInfo', () {
    final iai =
        MetadataStore.getMetadataForType('Windows.Foundation.IAsyncInfo')!;
    check(iai.isInterface).isTrue();
    check(iai.typeVisibility).equals(TypeVisibility.public);
    check(iai.typeLayout).equals(TypeLayout.auto);
    check(iai.stringFormat).equals(StringFormat.ansi);
    check(iai.isAbstract).isTrue();
    // check(iai.isImported).isTrue();
    check(iai.isWindowsRuntime).isTrue();
    check(iai.name).equals('Windows.Foundation.IAsyncInfo');

    check(iai.customAttributes.length).equals(2);
    check(iai
            .findAttribute('Windows.Foundation.Metadata.GuidAttribute')!
            .signatureBlob
            .toList())
        .deepEquals([
      0x01, 0x00, 0x36, 0x00, 0x00, 0x00, 0x00, 0x00, //
      0x00, 0x00, 0xc0, 0x00, 0x00, 0x00, 0x00, 0x00, //
      0x00, 0x46, 0x00, 0x00
    ]);
    check(iai
            .findAttribute(
                'Windows.Foundation.Metadata.ContractVersionAttribute')!
            .signatureBlob
            .toList())
        .containsInOrder(<int>[0x01, 0x00, 0x25, 0x57, 0x69, 0x6e, 0x64, 0x6f]);

    check(iai.methods.length).equals(5);
    check(iai.methods[0].memberAccess).equals(MemberAccess.public);
    check(iai.methods[0].isHideBySig).isTrue();
    check(iai.methods[0].isSpecialName).isTrue();
    check(iai.methods[0].vTableLayout).equals(VtableLayout.newSlot);
    check(iai.methods[0].isAbstract).isTrue();
    check(iai.methods[0].isVirtual).isTrue();
    check(iai.methods[0].returnType.typeIdentifier.baseType)
        .equals(BaseType.uint32Type);
    check(iai.methods[0].name).equals('get_Id');
    check(iai.methods[0].implFeatures.codeType).equals(CodeType.runtime);
    check(iai.methods[0].implFeatures.isManaged).isTrue();

    check(iai.properties.length).equals(3);
    check(iai.properties[0].typeIdentifier.name)
        .equals('Windows.Foundation.HResult');
    check(iai.properties[0].typeIdentifier.baseType)
        .equals(BaseType.valueTypeModifier);
    check(iai.properties[0].name).equals('ErrorCode');
    check(iai.properties[0].hasGetter).isTrue();
    check(iai.properties[0].getterMethod?.name).equals('get_ErrorCode');
    check(iai.properties[0].hasSetter).isFalse();
  });
}
