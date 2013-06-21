#SingleInstance force
#notrayicon
#Include Winclip\WinClipAPI.ahk
#Include Winclip\WinClip.ahk

ColumnNumber := 6
SpaceBetweenButton := 5
ButtonSize := 25  ; = Width = Height

TextToSend=         ;Character to appear on GUI | Plain-or-HTML text | font to display on GUI | HTML format
(
→ | Plain | Times New Roman
↑ | Plain | Times New Roman
↓ | Plain | Times New Roman
← | Plain | Times New Roman
↔ | Plain | Times New Roman
↕ | Plain | Times New Roman
÷ | Plain | Times New Roman
± | Plain | Times New Roman
≤ | Plain | Times New Roman
≥ | Plain | Times New Roman
≠ | Plain | Times New Roman
≡ | Plain | Times New Roman
« | Plain | Times New Roman
» | Plain | Times New Roman
Î  | Plain | Times New Roman
¤ | Plain | Times New Roman
¦  | Plain | Times New Roman
ˠ | Plain | Times New Roman
∑ | Plain | Times New Roman
∆ | Plain | Times New Roman
∫ | Plain | Times New Roman
∞ | Plain | Times New Roman
≈ | Plain | Times New Roman
˽ | Plain | Times New Roman
σ | Plain | Times New Roman
∩ | Plain | Times New Roman
μ | Plain | Times New Roman
φ | Plain | Times New Roman
π | Plain | Times New Roman
Ω | Plain | Times New Roman
¥ | Plain | Times New Roman
€ | Plain | Times New Roman
₤ | Plain | Times New Roman
₣ | Plain | Times New Roman
₫ | Plain | Times New Roman
₩ | Plain | Times New Roman
 | Html | Wingdings 2 | <span style='font-family:"Wingdings 2"'></span>
O | Html | Wingdings 2 | <span style='font-family:"Wingdings 2"'>O</span>
Q | Html | Wingdings 2 | <span style='font-family:"Wingdings 2"'>Q</span>
P | Html | Wingdings 2 | <span style='font-family:"Wingdings 2"'>P</span>
R | Html | Wingdings 2 | <span style='font-family:"Wingdings 2"'>R</span>
a | Html | Webdings | <span style='font-family:"Webdings"'>a</span>
J | Html | Wingdings | <span style='font-family:"Wingdings"'>J</span>
L | Html | Wingdings | <span style='font-family:"Wingdings"'>L</span>
v | Html | Wingdings | <span style='font-family:"Wingdings"'>v</span>
N | Html | Wingdings | <span style='font-family:"Wingdings"'>N</span>
i | Html | Webdings | <span style='font-family:"Webdings"'>i</span>
Q | Html | Wingdings 3 | <span style='font-family:"Wingdings 3"'>Q</span>
@ | Html | Webdings | <span style='font-family:"Webdings"'>@</span>
N | Html | Webdings | <span style='font-family:"Webdings"'>N</span>
Y | Html | Webdings | <span style='font-family:"Webdings"'>Y</span>
Ñ | Html | Webdings | <span style='font-family:"Webdings"'>Ñ</span>
Ï | Html | Webdings | <span style='font-family:"Webdings"'>Ï</span>
Ð | Html | Webdings | <span style='font-family:"Webdings"'>Ð</span>
)

Gui, -Resize +AlwaysOnTop +ToolWindow -Border -Caption -SysMenu
Gui, +HwndhGui

Loop, parse, TextToSend, `n
   {
    If (A_Index != 1  AND   Mod(A_Index,ColumnNumber)=1 )   ;Decide position of top-left corner of each buttons
      y := y + ButtonSize + SpaceBetweenButton
      else if(A_Index = 1)
      y := 5
    If (A_Index = 1  OR   Mod(A_Index,ColumnNumber)=1)
       x = 5
       Else
       x := x + ButtonSize + SpaceBetweenButton

    StringSplit,Element,A_LoopField,|,%A_Space%%A_Tab%     ;Split in to Element1  Element2 .... by pipe character ("|")

    Gui, font, s11, %Element3%
    If(Element2 = "Plain")
    Gui, Add, Button, W%ButtonSize% H%ButtonSize% Y%y% X%x% gSendPlainText, %Element1%
    else
    {
    Element3Cleaned := varize(Element3)     ;remove illegal characters
    Gui, Add, Button, W%ButtonSize% H%ButtonSize% Y%y% X%x% v%Element1%%Element2%%Element3Cleaned% gSendHtmlText, %Element1%   ;v%Element1%%Element2%   contain the string to send
    %Element1%%Element2%%Element3Cleaned% := Element4
    }

    TotalCharacters++     ;Equal max A_Index
    }

Rownumber := Ceil(TotalCharacters/ColumnNumber)
Gui, Show, AutoSize Center

#If (WinExist("A") = hGui)      ;↓ Using Up/Down arrowkey to select buttons ↓
Up::
Down::
GuiControlGet, FocusedControl, Focus
Num := SubStr(FocusedControl,7)       ;Get number from FocusedControl, i.e:  Button12
if (A_ThisHotkey = "Up")
   NewNum := (Num > ColumnNumber) ? Num - ColumnNumber : Num + ColumnNumber*(Rownumber-1)
else
   NewNum := (Num <= ColumnNumber*(Rownumber-1)) ? Num + ColumnNumber : Num - ColumnNumber*(Rownumber-1)
GuiControl, Focus, Button%NewNum%
return

Enter::
GuiControlGet, GuiControl, FocusV
If( InStr(GuiControl,"Html"))
Gosub, SendHtmlText
else
Gosub, SendPlainText
Return


SendPlainText:
GuiControlGet, ClassNN, Focus
GuiControlGet, SymbolText, , %ClassNN%   ;Sub-command=Blank: retrieve the control's contents
Gui, cancel
SendInput, %SymbolText%
Exitapp

SendHtmlText:
GuiControlGet, GuiControl, FocusV
Gui, cancel
html = % %GuiControl%
html := trim(html)
;html := FileOpen(A_Scriptdir "\Winclip\" SymbolText ".htm", "r").read()
WinClip.SetHTML(html)
WinClip.Paste()
exitapp

x::
Exitapp
GuiEscape:
Exitapp
GuiClose:
Exitapp
