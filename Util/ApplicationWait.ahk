﻿
#Include %A_LineFile%\..\Is.ahk

Class ApplicationWaitActive extends ApplicationWait {
	Check(hwnd, active) {
		return active = hwnd || this.GetAncestor(active) = hwnd
	}
}

Class ApplicationWaitNotActive extends ApplicationWait {
	Check(hwnd, active) {
		return active != hwnd && this.GetAncestor(active) != hwnd && active != 0x0
	}
}

Class ApplicationWaitModalActive extends ApplicationWait {
	Check(hwnd, active) {
		return active != hwnd && this.GetAncestor(active) = hwnd
	}
}

Class ApplicationWaitModalNotActive extends ApplicationWait {
	Check(hwnd, active) {
		return active = hwnd || this.GetAncestor(active) != hwnd
	}
}

Class ApplicationWait {
	
	__New(window, callback, interval := 20, condition := False) {
		this.window := window
		this.callback := callback
		this.condition := condition
		this.timer := ObjBindMethod(this, "TimerFunc")
		this.On(interval)
	}
	
	On(interval) {
		funobj := this.timer
		SetTimer, % funobj, % interval ? interval : "Off"
	}
	
	TimerFunc() {
		hwnd := this.GetHwnd(), active := WinActive("A")
		if(this.Check(hwnd, active)) {
			if(!this.condition || this.condition.Call(hwnd, active)) {
				this.Success()
			}
		}
	}
	
	Success() {
		this.On(False)
		this.callback.Call()
	}
	
	GetAncestor(hwnd) {
		return DllCall("GetAncestor", "Ptr", hwnd, "UInt", 3)
	}
	
	GetHwnd() {
		if(!Is_OfType(this.window, "xdigit")) {
			WinGet, hwnd, Id, % this.window
			return hwnd
		}
		return this.window
	}
	
	Destroy() {
		this.On(False)
		this.timer := ""
		;ObjRelease(this)
	}
}
