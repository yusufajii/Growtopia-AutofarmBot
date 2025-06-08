#SingleInstance, force
SetBatchLines, 200
CoordMode, Mouse, Relative
SetControlDelay -1

;Opening GUI Layout
;{

Gui, OG:Font,s7 , Verdana
Gui, OG:+alwaysontop
Gui, OG:Color, 4584C8

Gui, OG:Add, Picture, x5 y-12 w240 h220 , LOGOBLACK.png
Gui, OG:Add, Button, x72 y200 w110 h30 gOGTOMG , Get Started



;}

; Main GUI Layout :
;{ 

Gui, MG:+alwaysontop
Gui, MG:Color, 4584C8
Gui, MG:Add, Picture, x10 y-36 w160 h150 , LOGOBLACK.png
Gui, MG:Font,s7 , Verdana

;SetWindow
Gui, MG:Add, Edit, x172 y9 w70 h20 vPID_Edit gSubmiter, 
Gui, MG:Add, Button, x172 y34 w70 h18 vSet_Win_Button gSet_Win_Label, Set Window
Gui, MG:Add, Checkbox, Checkedx176 y+7 w70 h18 vKeepActive_CB gSubmiter, Keep Act

;ScreenResoluton
Gui, MG:Add, DropDownList, x252 y9 w80 vScreenRes_DDL gSubmiter, 1154x626||

;HitCount
Gui, MG:Add, DropDownList, x252 y+5 w80  vHitCount_DDL gSubmiter, Puts|5 Hits|4 Hits|3 Hits|6 Hits||

;Adjusting Zoom	
Gui, MG:Add, Button, x252 y+5 w80 h18 vAdjZoom_Button gAdjust_Label, Zoom

;Pixel Search
Gui, MG:Add, Edit, x342 y9 w80 h20 vDefaultColor_Edit gSubmiter, 0x60D7F2
Gui, MG:Add, Radio, Checked x342 y35 w80 h20 vPixSearch_Radio gSubmiter, Pixel Search
Gui, MG:Add, Radio, x342 y55 vNoPixSearch_Radio gSubmiter, Standard

;Setting
Gui, MG:Add, CheckBox,Checked x442 y49 w80 h20 vShowFrame_CB gSubmiter, Show Frame
Gui, MG:Add, CheckBox, x442 y29 w80 h20 vLagMode_CB gSubmiter, Lag Mode
Gui, MG:Add, CheckBox,Checked x442 y9 w80 h20 vRandoming_CB gSubmiter,  Randoming

;Start Button
Gui, MG:Add, Button, x532 y9 w80 h60 vStart_Button gStart_Label , Start

;}

;Simple GUI Layout
;{
Gui, SG:Font,s7 , Verdana
Gui, SG:+alwaysontop
Gui, SG:-Caption
Gui, SG:Color, 4584C8
Gui, SG:Add, Button, x12 y19 w100 h30 vStop_Button gStop_Label, Stop

;}

Gui, OG:Show, w250 h300, `t
gosub, Submiter
return

;Gui Controller Label
;{
Submiter:
	Gui,MG:Submit, NoHide
	return
	
OGGuiClose:
	ExitApp
	
MGGuiClose:
	ON_VAR:= 0
	ExitApp
	
SGGuiClose:
	ON_VAR:= 0
	ExitApp


OGTOMG:
	GUIMG_X_POS:= A_ScreenWidth - 629
	GUIMG_Y_POS:= A_ScreenHeight - 82 - 100
	Gui, OG:Destroy
	Gui, MG:Show, x%GUIMG_X_POS% y%GUIMG_Y_POS% w629 h82, `t
	return

MGTOSG:
	GUISG_X_POS:= A_ScreenWidth - 128
	Gui, MG:Hide
	Gui, SG:Show, x%GUISG_X_POS% y0 w128 h72, `t
	return

SGTOMG:
	Gui, SG:Hide
	Gui, MG:Show
	return

;}


;################################################## Gui Button Label ##################################################
Set_Win_Label:
	;{
	UserAttribute()["pid"] := Set_Window()
	GuiControl,,PID_Edit,% Set_Window()
	goto, Submiter
	;}

Adjust_Label:
	;{
	if(ScreenRes_DDL == "1154x626" )
		{
			if(UserAttribute()["pid"] != null)
				{
					Loop,23
						{	
							ControlClick,,% "ahk_pid" UserAttribute()["pid"],,WheelUp
							Sleep,50
						}
					Loop,10
						{
							ControlClick,,% "ahk_pid" UserAttribute()["pid"],,WheelDown
							Sleep,50		
						}
					return
				}
			else
				{
					MsgBox, 16 , WARNING !,Target Growtiopia Must Be Arranged  `n `nSelect "Set Window" Then Click on Target Growtopia
					return
				}
		}
;}
	
Start_Label:
	;{
	ON_VAR:= 1
	ON_PROGRES:= 0 
	
	if(UserAttribute()["pid"] == null)
		{
			MsgBox, 16 , WARNING !,Target Growtiopia Must Be Arranged  `n `nSelect "Set Window" Then Click on Target Growtopia
			return
		}
	;}
	
	gosub, MGTOSG
	WinActivate, % "ahk_pid " . UserAttribute()["pid"]
	
	while(ON_VAR == 1)
		{
			gosub,KeepActive 
			ON_PROGRES := 1
			MainFunction()
			ON_PROGRES := 0
			if(ON_VAR== 0)
				{
					break
				}
			
			Jumping()
			Sleep, % RandNum(800,1200)
		}
	return
	;}


Stop_Label:
	;{

	MsgBox, 262196, `t, Stopping Program Will Execute Remaining Line `n`nWould You Still Like  to Stop ?
		IfMsgBox Yes
			{
				ON_VAR:= 0
				gosub, SGTOMG
			}
		else
			{
				return
			}
			
	return
	;}
	

;################################################## FUNCTION GLOBAL ##################################################

UserAttribute()
	{
		
		dictUserInfo := {} 
		
		global PID_Edit
		global KeepActive_CB
		global ScreenRes_DDL
		global HitCount_DDL
		global DefaultColor_Edit
		global PixSearch_Radio
		global ShowFrame_CB
		global LagMode_CB
		global Randoming_CB
		
		dictUserInfo["pid"]:=  PID_Edit
		dictUserInfo["keepact"]:= KeepActive_CB
		if(ScreenRes_DDL == "1154x626" )
			{
				dictUserInfo["arBlockPos_XMax"] := [760,660,760,660,760,660,470,370,470,370,470,370]
				dictUserInfo["arBlockPos_XMin"]:= [810,710,810,710,810,710,520,420,520,420,520,420]
				dictUserInfo["arBlockPos_YMax"]	:= [50,50,150,150,250,250,50,50,150,150,250,250]
				dictUserInfo["arBlockPos_YMin"]:=[100,100,200,200,300,300,100,100,200,200,300,300]
			}
		
		
		switch HitCount_DDL
			{
				case "Puts":
					dictUserInfo["hitcount"] := 1
				case "3 Hits":
					dictUserInfo["hitcount"] := 5
				case "4 Hits":
					dictUserInfo["hitcount"] := 6
				case "5 Hits":
					dictUserInfo["hitcount"] := 7
				case "6 Hits":
					dictUserInfo["hitcount"] := 8
			}
		if(LagMode_CB==1)
			{
				dictUserInfo["hitcount"]+=3
			}

		if(HitCount_DDL=="Puts")
			{
				dictUserInfo["isputs"]:=1
			}
		else
			{
				dictUserInfo["isputs"]:=0
			}
			
		dictUserInfo["defcol"]:= DefaultColor_Edit
		dictUserInfo["pixsearch"]:= PixSearch_Radio
		dictUserInfo["showframe"]:=ShowFrame_CB
		dictUserInfo["randoming"]:= Randoming_CB
		
		return dictUserInfo
	}

Set_Window()
	{
		isPressed:=0,i:= 0
		Loop
			{
				Left_Mouse:=GetKeyState("LButton")
				WinGetTitle,Temp_Window,A
				ToolTip,Left Click on the target window twice to set `n`n Current Window: %Temp_Window%
				if(Left_Mouse==False&&isPressed==0)
					isPressed:=1
				else if(Left_Mouse==True&&isPressed==1)
					{
						i++,isPressed:=0
						if(i>=2)
							{
								WinGet,Target_Window,PID,A
								ToolTip,
								break
							}
					}
			}
		return Target_Window
	}

MsgBoxUserAttribute()
	{
		for i,val in UserAttribute()
			{
				if(val[1] != null)
				{
					var.= i . " = [" 
					for i,vals in val
						var.=  vals . ", "
					var.= "]`n"
				}
				else
					var.= "`n" .  i . " = " . val 
			}
		MsgBox, % var 
		var:=null
	}
	
KeepActive:
	{
		if (UserAttribute()["keepact"] == 1)
			{
				IfWinNotActive, % "ahk_pid " . UserAttribute()["pid"]
					{
						MsgBox, 262196, `t,Growtopia Screen is Not Active`t `n`nWould you like to continue breaking?
							IfMsgBox Yes
								WinActivate, % "ahk_pid " . UserAttribute()["pid"]
							else
								goto, Stop_Label
					}
			}
		return
	}
	return
	
DrawRect(n,intX, intY, intRealorder, intRandomOrder, w:=50, h:=50, colors:="CYAN") 
	{
		Gui, br%n%:Add, Picture, x0 y0 w50 h50 , L%colors%.png
		Gui, br%n%:Font, cFFFFFF
		Gui, br%n%:add, text,x5 y5, %intRandomOrder% (%intRealorder%)
		Gui, br%n%:-Caption +AlwaysOnTop
		Gui, br%n%:Color, black
		gui, br%n%:+ToolWindow
		Gui, br%n%:Show, x%intX% y%intY% w%w% h%h%
	}

RandNum(max,min)
	{
		Random, rands,max,min
		return rands
	}

SearchPixel(ByRef arBlockNum, ByRef arBlockNum_Null, arXMax,arYMax,arXMin,arYMin,strColor:="0x60D7F2")
	{
		intIndexs:=1
		while(intIndexs <= 12)
			{
				PixelSearch, Px, Py, arXMax[intIndexs],arYMax[intIndexs],arXMin[intIndexs],arYMin[intIndexs], % strColor,, Fast RGB
				if not ErrorLevel
				{
					arBlockNum_Null.Push(intIndexs)
				}
				else
				{
					arBlockNum.Push(intIndexs)
				}
				intIndexs+=1
			}
	}	

GetRandomOrder(puts_stat,ByRef intOrder, ByRef arBlockNum_Ordered, ByRef arBlockNum, ByRef arBlockNum_Null)
	{
		if(puts_stat != 1)
			{
				Loop, % arBlockNum.length() 
					{
						intOrder+=1
						Random, intRandomNum, 1, arBlockNum.length() ;get random number
						intBlockNum:= arBlockNum[intRandomNum] ;get single Block num from array
						;MsgBox, i will draw block %intBlockNum% 
						;DrawRect(intBlockNum,arBlockPos_XMax[intBlockNum],arBlockPos_YMax[intBlockNum],intBlockNum,intOrder) ;Draw Block by NumOrder
						arBlockNum.Remove(intRandomNum) ;Remove rechieved value
						arBlockNum_Ordered.insert(intOrder, intBlockNum) ;Move rechieved value to new array
					}
			}
		else
			{
				Loop, % arBlockNum_Null.length() 
					{
						intOrder+=1
						Random, intRandomNum, 1, arBlockNum_Null.length() ;get random number
						intBlockNum_Null:= arBlockNum_Null[intRandomNum] ;get single Block num from array 
						;DrawRect(intBlockNum_Null,arBlockPos_XMax[intBlockNum_Null],arBlockPos_YMax[intBlockNum_Null],intBlockNum_Null,intOrder)
						arBlockNum_Null.Remove(intRandomNum) ;Remove rechieved value
						arBlockNum_Ordered.insert(intOrder, intBlockNum_Null) ;Move rechieved value to new array
					}
			}					
	}
	
MainFunction() ;while program is running
	{
		
		arBlockNum := [] 
		arBlockNum_Null := []
		arBlockNum_Ordered := []
		
		intOrder := 0
		
		UserAttribute := UserAttribute()
		
		Switch UserAttribute["isputs"]
			{
				case 1:
					scopecolorz:="CYAN"
				case 0:
					scopecolorz:="PINK"
			}
			
		if(UserAttribute["pixsearch"]==1)
			{
				IfWinNotActive, % "ahk_pid " . UserAttribute["pid"]
					WinActivate,% "ahk_pid " . UserAttribute["pid"]
				SearchPixel(arBlockNum, arBlockNum_Null, UserAttribute["arBlockPos_XMax"], UserAttribute["arBlockPos_YMax"],UserAttribute["arBlockPos_XMin"],UserAttribute["arBlockPos_YMin"],UserAttribute["defcol"])
			}
		else
			{
				arBlockNum := [1,2,3,4,5,6,7,8,9,10,11,12]
				arBlockNum_Null:= [1,2,3,4,5,6,7,8,9,10,11,12]
			}
			
		if(UserAttribute["randoming"] == 1)
			{
				GetRandomOrder(UserAttribute["isputs"],intOrder, arBlockNum_Ordered, arBlockNum, arBlockNum_Null)
			}
		else
			{
				if(UserAttribute["isputs"] != 1)
					arBlockNum_Ordered := arBlockNum
				else
					arBlockNum_Ordered := arBlockNum_Null
			}
		
		if(UserAttribute["showframe"] == 1)
			{
				for intNewOrder, intRealOrder in arBlockNum_Ordered
				{
					DrawRect(intRealOrder,UserAttribute["arBlockPos_XMax"][intRealOrder], UserAttribute["arBlockPos_YMax"][intRealOrder],intRealOrder,intNewOrder,,,scopecolorz)
					Sleep,150
				}
			}
		
		for i,val in arBlockNum_Ordered
			{
				
				ClickPos_XY:={"x":0,"y":0}
				
				Loop, % UserAttribute["hitcount"]
				{
					ClickPos_XY["x"] := RandNum(UserAttribute["arBlockPos_XMin"][val],UserAttribute["arBlockPos_XMax"][val])
					ClickPos_XY["y"] := RandNum(UserAttribute["arBlockPos_YMin"][val],UserAttribute["arBlockPos_YMax"][val])
					ControlClick, % "x" . ClickPos_XY["x"] . " y" . ClickPos_XY["y"], % "ahk_pid " . UserAttribute["pid"] ,,, NA
					Sleep,300					
				}
				
				;MsgBox, i will erase block %val%
				Gui, br%val%:Destroy
				Sleep,200
			}
		if(UserAttribute["pixsearch"]==1)
			{
				IfWinNotActive, % "ahk_pid " . UserAttribute["pid"]
					WinActivate,% "ahk_pid " . UserAttribute["pid"]
				SearchPixel(arBlockNum, arBlockNum_Null, UserAttribute["arBlockPos_XMax"], UserAttribute["arBlockPos_YMax"],UserAttribute["arBlockPos_XMin"],UserAttribute["arBlockPos_YMin"])
			}
		
		global ON_VAR
		if(UserAttribute["isputs"] == 0 && arBlockNum[1] != null && ON_VAR != 0)
			{
				MainFunction()
			}
			
		else if(UserAttribute["isputs"] == 1 && arBlockNum_Null[1] != null && ON_VAR != 0)
			{
				MainFunction()
			}	
	}
	
Jumping()
	{
		ControlSend,,{w down},% "ahk_pid " . UserAttribute()["pid"] 
		Sleep, % RandNum(300,350)
		ControlSend,,{w up},% "ahk_pid " . UserAttribute()["pid"]
	}
	
