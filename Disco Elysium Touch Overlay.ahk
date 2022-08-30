#SingleInstance Force

TraySetIcon('resources\eye.png', 0, 1)

GameWindowID := WinWait('ahk_exe Disco Elysium.exe', ,)

ZoomIn(*)
{
    Send('{WheelUp 15}')
}

ZoomOut(*)
{
    Send('{WheelDown 15}')
}

FocusOn := false
ToggleFocus(*)
{
    global FocusOn
    FocusOn := !FocusOn
    Send(FocusOn ? '{Tab down}' : '{Tab up}')
    Eye.Value := FocusOn ? 'resources\eye-active.png' : 'resources\eye.png'
}

ControlsGui := Gui()
ControlsGui.Opt('+AlwaysOnTop -Caption +ToolWindow +E0x08000000')
ControlsGui.BackColor := 'black'
ControlsGui.MarginY := 22
ControlsGui.Add('Picture', 'x0 y0', 'resources\background.png')
Minus := ControlsGui.Add('Picture', 'x8 y24 w-1 h40 BackgroundTrans', 'resources\minus.png')
Eye := ControlsGui.Add('Picture', 'w-1 h40 BackgroundTrans', 'resources\eye.png')
Plus := ControlsGui.Add('Picture', 'w-1 h40 BackgroundTrans', 'resources\plus.png')
WinSetTransColor(ControlsGui.BackColor ' 248', ControlsGui)
Height := 451

MenuGui := Gui()
MenuGui.Opt('+AlwaysOnTop -Caption +ToolWindow +E0x08000000')
MenuGui.BackColor := 'black'
MenuGui.Add('Picture', 'x0 y0', 'resources\menu.png')
WinSetTransColor(MenuGui.BackColor ' 248', MenuGui)

OnMessage 0x0201, WM_LBUTTONDOWN

WM_LBUTTONDOWN(wParam, lParam, msg, hwnd)
{
    if (GuiFromHwnd(hwnd) == MenuGui)
    {
        Send('{Escape}')
    } else
    {
        Y := lParam >> 16
        if (Y < Height / 3)
            ZoomOut()
        else if (Y < Height * 2 / 3)
            ToggleFocus()
        else
            ZoomIn()
    }
}

Loop:
    WinWaitNotActive('ahk_id ' GameWindowID)
    ControlsGui.Hide()
    MenuGui.Hide()
    TraySetIcon('eye.png', 0, 1)
    WinWaitActive('ahk_id ' GameWindowID)
    ControlsGui.Show('x0 yCenter NoActivate')
    MenuGui.Show('x0 y0 NoActivate')
    TraySetIcon('eye-active.png', 0, 1)
    Goto Loop