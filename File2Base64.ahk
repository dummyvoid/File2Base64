#SingleInstance Force
#Include <ImagePut>
#Include <StrCompress>
#Include <Base64>
#Include <Base64TohBitmap>
#Include <Class_CtlColors>
#Include <IsOver>
#Include <OSD>

SplitPath, A_ScriptFullPath, , , , ScriptName

Menu, Tray, NoIcon
icon:="iVBORw0KGgo_A4NSUhEUg#AB_A5QCAY_A4f8/9h#ACRUlEQVR42p2OTUhUURTHrzZlpRGhNWlSuHBRmxCnVQlCFC1apFAbS8hlRlq5SRdugqiEIgn6oFwEfgSBKxXaSEaNFuU0QYSMN2LGnA+n+X5z#3v/TvvTjNTMG488OPc8/+dy73Mrn3hwCdimeD/Up+ndO5Tl+v8K98I2NT6A6or1LmYF+ci9f6AwWqXfnECe9dlpWSev8Oci6t8z+IqnItB2L2WaPQG0fBFzTnI0R72e4Ky0RtCvSdYyNjutyFO4NB8BGOhDKLShAVg9rcA5Tnmwmj+sIa0YWVA1beUoDysYNVTEe6cjsATl4gIE/1fUzg3H8fxuRjIKWqImaBATLdg13VvsuDYrrEob59NKnHpfQo1E1FUj0dBeYGOuSQsC+hbSMOua9SVoz2281GMD7o1JXxxA4YFxISFoc8ayKHuWQw/EyYmvgs0jSZg19U3GdspWNXtBB+eF0o8+ajj4qSG1z6p5tPjGdxzC6xlLDQMJ3H4cUrlPTMadtxJoIpglQMpPjAtlGh5mMH2/jROPdXU3DuZxY+oBdMCNAkIwi5p0GNuHZW0y7Ze1njr3awSL9wSBwc1jLzLbbYOZdE1oqNnTOLKqMStqVz+csHAyfsC27o1sC2dgld0CjyYljBM5dVLN19JUP4fTTeE8t3PyV0QoLtgm9t07mjTQR0HuiRcvRLO8/ZMnJGwXd5XtOuo6aCvn1WzytmmEwYnsFGYo8XwlR81sREcxwyT2eU4YvrKXBYva/6LyySo57KS53KXucwYY38AFdXOMVHlBTM_A5SUVORK5CYII="
Menu, Tray, Icon, % "hBitmap:*" Base64TohBitmap(Expand(icon))
Gui, New, ,% ScriptName
Gui, Color, , FFF0F5
Gui, Font, s8, Microsoft YaHei UI
FileName:=StrSplit(Clipboard, "`r`n")
Gui, Add, Edit, r2 w300 hwndEdit1 Wrap -VScroll -WantReturn, % RegExMatch(FileName[1],"^[A-Z]:\\") ? FileName[1] : ""
CtlColors.Attach(Edit1, "E0FFFF", "")
Gui, Font, s10, Microsoft YaHei UI
Gui, Add, Button, w120 xm+15 Default gEncode, 轉成壓縮編碼
Gui, Add, Button, w140 x+10 gEncodeCopy, 轉成壓縮編碼並複製
Gui, Font, s10, Consolas
Gui, Add, Edit, r20 w300 xm Wrap, % StrLen(Clipboard)>100 ? Clipboard : ""
Gui, Font, s10, Microsoft YaHei UI
Gui, Add, Button, w95 xm gCompress, 編碼壓縮
Gui, Add, Button, w95 x+8 gExpand, 編碼解壓縮
Gui, Add, Button, w95 x+8 gExport, 轉出檔案
Gui, Show, AutoSize Center
return
;InputBox, F, 輸入檔案, , , 320, 100, % (A_ScreenWidth-320)/2, % (A_ScreenHeight-122)/2, Locale, , % Clipboard

#if WinActive(ScriptName) && MouseIsOverControlClass("Edit1")
{
~LButton::
ControlGetText, Edit1Text, Edit1, A
if (Edit1Text="")
{
    FileSelectFile, FileName, , % A_Desktop, 選擇檔案
    ControlSetText, Edit1, % FileName, A
}
return
}

GuiClose:
GuiEscape:
ExitApp

Encode:
ControlSetText, Edit2, , A
ControlGetText, Edit1Text, Edit1, A
if (Edit1Text="")
    MsgBox, 請輸入檔案路徑
else
{
    a:=ImagePutBase64(Edit1Text)
    Clipboard:=Compress(a)
    ControlSetText, Edit2, % Clipboard, A
    b:=Expand(Clipboard)
    if (a==b)
        Tooltip("編碼壓縮校驗OK",2)
    else
        Tooltip("編碼壓縮校驗NG",2)
}
return

EncodeCopy:
ControlSetText, Edit2, , A
ControlGetText, Edit1Text, Edit1, A
if (Edit1Text="")
    MsgBox, 請輸入檔案路徑
else
{
    a:=ImagePutBase64(Edit1Text)
    Clipboard:=Compress(a)
    ControlSetText, Edit2, % Clipboard, A
    b:=Expand(Clipboard)
    if (a==b)
        Tooltip("編碼壓縮校驗OK",2)
    else
        Tooltip("編碼壓縮校驗NG",2)
}
ControlGetText, Edit2Text, Edit2, A
Clipboard:=Edit2Text
return

Compress:
ControlGetText, Edit2Text, Edit2, A
b:=Compress(Edit2Text)
ControlSetText, Edit2, % b, A
return

Expand:
ControlGetText, Edit2Text, Edit2, A
b:=Expand(Edit2Text)
ControlSetText, Edit2, % b, A
return

Export:
ControlGetText, Edit2Text, Edit2, A
nBytes:=Base64Dec(Edit2Text,Bin)
Header:=b64Decode(SubStr(Edit2Text,1,10))
if InStr(Header,"png")
    FilePath:=A_Desktop "\Output.png"
else
    FilePath:=A_Desktop "\Output.bin"
FileAppend, , % FilePath
File:=FileOpen(FilePath,"w")
File.RawWrite(Bin,nBytes)
File.Close()
MsgBox % "檔頭：" Header
return
