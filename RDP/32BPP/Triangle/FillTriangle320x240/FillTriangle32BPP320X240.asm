; N64 'Bare Metal' 32BPP 320x240 Fill Triangle RDP Demo by krom (Peter Lemon):

  include LIB\N64.INC ; Include N64 Definitions
  dcb 2097152,$00 ; Set ROM Size
  org $80000000 ; Entry Point Of Code
  include LIB\N64_HEADER.ASM  ; Include 64 Byte Header & Vector Table
  incbin LIB\N64_BOOTCODE.BIN ; Include 4032 Byte Boot Code

Start:
  include LIB\N64_INIT.ASM ; Include Initialisation Routine
  include LIB\N64_GFX.INC  ; Include Graphics Macros

  ScreenNTSC 320,240, BPP32, $A0100000 ; Screen NTSC: 320x240, 32BPP, DRAM Origin $A0100000

  WaitScanline $200 ; Wait For Scanline To Reach Vertical Blank

  DPC RDPBuffer,RDPBufferEnd ; Run DPC Command Buffer: Start Address, End Address

Loop:
  j Loop
  nop ; Delay Slot

  align 8 ; Align 64-bit
RDPBuffer:
  Set_Scissor 0<<2,0<<2, 320<<2,240<<2, 0 ; Set Scissor: XH 0.0, YH 0.0, XL 320.0, YL 240.0, Scissor Field Enable Off
  Set_Other_Modes CYCLE_TYPE_FILL, 0 ; Set Other Modes
  Set_Color_Image SIZE_OF_PIXEL_32B|(320-1), $00100000 ; Set Color Image: SIZE 32B, WIDTH 320, DRAM ADDRESS $00100000
  Set_Fill_Color $FFFF00FF ; Set Fill Color: PACKED COLOR 32B R8G8B8A8 Pixel
  Fill_Rectangle 319<<2,239<<2, 0<<2,0<<2 ; Fill Rectangle: XL 319.0, YL 239.0, XH 0.0, YH 0.0

  Sync_Pipe ; Stall Pipeline, Until Preceeding Primitives Completely Finish
  Set_Fill_Color $FF0000FF ; Set Fill Color: PACKED COLOR 32B R8G8B8A8 Pixel (Red)
  ;
  ;      DxHDy
  ;      .___. v[2]:XH,XM(X:25.0) YH(Y:50.0), v[1]:XL(X:75.0) YM(Y:50.0)
  ;      |  /
  ; DxMDy| /DxLDy
  ;      ./    v[0]:(X:25.0) YL(Y:100.0)
  ;
  ; Output: Dir=0, YL=100.0, YM=50.0, YH=50.0, XL=25.0, DxLDy=0.0, XH=75.0, DxHDy=-1.0, XM=75.0, DxMDy=0.0
  ; Fill_Triangle 0, 0, 0, 400,200,200, 25,0, 0,0, 75,0, -1,0, 75,0, 0,0 ; Generated By N64LeftMajorTriangleCalc.py
  ; Output: Dir=1, YL=100.0, YM=50.0, YH=50.0, XL=75.0, DxLDy=-1.0, XH=25.0, DxHDy=0.0, XM=25.0, DxMDy=0.0
    Fill_Triangle 1, 0, 0, 400,200,200, 75,0, -1,0, 25,0, 0,0, 25,0, 0,0 ; Generated By N64RightMajorTriangleCalc.py

  Sync_Pipe ; Stall Pipeline, Until Preceeding Primitives Completely Finish
  Set_Fill_Color $00FF00FF ; Set Fill Color: PACKED COLOR 32B R8G8B8A8 Pixel (Green)
  ;
  ;      DxHDy
  ;      .___. v[2]:XH,XM(X:100.0) YH(Y:50.0), v[1]:XL(X:150.0) YM(Y:50.0)
  ;       \  |
  ; DxMDy  \ |DxLDy
  ;         \. v[0]:(X:150.0) YL(Y:100.0)
  ;
  ; Output: Dir=0, YL=100.0, YM=50.0, YH=50.0, XL=100.0, DxLDy=1.0, XH=150.0, DxHDy=0.0, XM=150.0, DxMDy=0.0
  ; Fill_Triangle 0, 0, 0, 400,200,200, 100,0, 1,0, 150,0, 0,0, 150,0, 0,0 ; Generated By N64LeftMajorTriangleCalc.py
  ; Output: Dir=1, YL=100.0, YM=50.0, YH=50.0, XL=150.0, DxLDy=0.0, XH=100.0, DxHDy=1.0, XM=100.0, DxMDy=0.0
    Fill_Triangle 1, 0, 0, 400,200,200, 150,0, 0,0, 100,0, 1,0, 100,0, 0,0 ; Generated By N64RightMajorTriangleCalc.py

  Sync_Pipe ; Stall Pipeline, Until Preceeding Primitives Completely Finish
  Set_Fill_Color $0000FFFF ; Set Fill Color: PACKED COLOR 32B R8G8B8A8 Pixel (Blue)
  ;
  ;          . v[2]:XH,XM(X:225.0) YH(Y:50.0)
  ;         /|
  ; DxMDy  / |DxHDy
  ;      ./__. v[0]:(X:175.0) YL(Y:100.0), v[1]:XL(X:225.0) YM(Y:100.0)
  ;      DxLDy
  ;
  ; Output: Dir=0, YL=100.0, YM=100.0, YH=50.0, XL=175.0, DxLDy=0.0, XH=225.0, DxHDy=0.0, XM=225.0, DxMDy=-1.0
  ; Fill_Triangle 0, 0, 0, 400,400,200, 175,0, 0,0, 225,0, 0,0, 225,0, -1,0 ; Generated By N64LeftMajorTriangleCalc.py
  ; Output: Dir=1, YL=100.0, YM=100.0, YH=50.0, XL=225.0, DxLDy=0.0, XH=225.0, DxHDy=-1.0, XM=225.0, DxMDy=0.0
    Fill_Triangle 1, 0, 0, 400,400,200, 225,0, 0,0, 225,0, -1,0, 225,0, 0,0 ; Generated By N64RightMajorTriangleCalc.py

  Sync_Pipe ; Stall Pipeline, Until Preceeding Primitives Completely Finish
  Set_Fill_Color $FFFFFFFF ; Set Fill Color: PACKED COLOR 32B R8G8B8A8 Pixel (White)
  ;
  ;      .     v[2]:XH,XM(X:250.0) YH(Y:50.0)
  ;      |\
  ; DxMDy| \DxHDy
  ;      .__\. v[0]:(X:250.0) YL(Y:100.0), v[1]:XL(X:300.0) YM(Y:100.0)
  ;      DxLDy
  ;
  ; Output: Dir=0, YL=100.0, YM=100.0, YH=50.0, XL=250.0, DxLDy=0.0, XH=250.0, DxHDy=1.0, XM=250.0, DxMDy=0.0
  ; Fill_Triangle 0, 0, 0, 400,400,200, 250,0, 0,0, 250,0, 1,0, 250,0, 0,0 ; Generated By N64LeftMajorTriangleCalc.py
  ; Output: Dir=1, YL=100.0, YM=100.0, YH=50.0, XL=300.0, DxLDy=0.0, XH=250.0, DxHDy=0.0, XM=250.0, DxMDy=1.0
    Fill_Triangle 1, 0, 0, 400,400,200, 300,0, 0,0, 250,0, 0,0, 250,0, 1,0 ; Generated By N64RightMajorTriangleCalc.py

  Sync_Pipe ; Stall Pipeline, Until Preceeding Primitives Completely Finish
  Set_Fill_Color $FF0000FF ; Set Fill Color: PACKED COLOR 32B R8G8B8A8 Pixel (Red)
  ;
  ;      .    v[2]:XH,XM(X:25.0) YH(Y:150.0)
  ;      |\ DxHDy
  ;      | \
  ; DxMDy|  . v[1]:XL(X:75.0) YM(Y:175.0)
  ;      | / DxLDy
  ;      ./   v[0]:(X:25.0) YL(Y:200.0)
  ;
  ; Output: Dir=1, YL=200.0, YM=175.0, YH=150.0, XL=75.0, DxLDy=-2.0, XH=25.0, DxHDy=0.0, XM=25.0, DxMDy=2.0
  ; Fill_Triangle 1, 0, 0, 800,700,600, 75,0, -2,0, 25,0, 0,0, 25,0, 2,0 ; Generated By N64LeftMajorTriangleCalc.py
    Fill_Triangle 1, 0, 0, 800,700,600, 75,0, -2,0, 25,0, 0,0, 25,0, 2,0 ; Generated By N64RightMajorTriangleCalc.py

  Sync_Pipe ; Stall Pipeline, Until Preceeding Primitives Completely Finish
  Set_Fill_Color $00FF00FF ; Set Fill Color: PACKED COLOR 32B R8G8B8A8 Pixel (Green)
  ;
  ;        DxHDy
  ;      ._______. v[2]:XH,XM(X:100.0) YH(Y:150.0), v[1]:XL(X:150.0) YM(Y:150.0)
  ;       \     /
  ; DxMDy  \   / DxLDy
  ;         \ /
  ;          .     v[0]:(X:125.0) YL(Y:200.0)
  ;
  ; Output: Dir=0, YL=200.0, YM=150.0, YH=150.0, XL=100.0, DxLDy=0.5, XH=150.0, DxHDy=-0.5, XM=150.0, DxMDy=0.0
  ; Fill_Triangle 0, 0, 0, 800,600,600, 100,0, 0,32768, 150,0, -1,32768, 150,0, 0,0 ; Generated By N64LeftMajorTriangleCalc.py
  ; Output: Dir=1, YL=200.0, YM=150.0, YH=150.0, XL=150.0, DxLDy=-0.5, XH=100.0, DxHDy=0.5, XM=100.0, DxMDy=0.0
    Fill_Triangle 1, 0, 0, 800,600,600, 150,0, -1,32768, 100,0, 0,32768, 100,0, 0,0 ; Generated By N64RightMajorTriangleCalc.py

  Sync_Pipe ; Stall Pipeline, Until Preceeding Primitives Completely Finish
  Set_Fill_Color $0000FFFF ; Set Fill Color: PACKED COLOR 32B R8G8B8A8 Pixel (Blue)
  ;
  ;         . v[2]:XH,XM(X:225.1) YH(Y:150.0)
  ;        /|
  ; DxHDy / |DxMDy
  ;      .  | v[1]:XL(X:175.0) YM(Y:175.0)
  ; DxLDy \ |
  ;        \. v[0]:(X:225.0) YL(Y:200.0)
  ;
  ; Output: Dir=0, YL=200.0, YM=175.0, YH=150.0, XL=175.0, DxLDy=2.0, XH=225.0, DxHDy=0.0, XM=225.0, DxMDy=-2.0
  ; Fill_Triangle 0, 0, 0, 800,700,600, 175,0, 2,0, 225,0, 0,0, 225,0, -2,0 ; Generated By N64LeftMajorTriangleCalc.py
  ; Fill_Triangle 0, 0, 0, 800,700,600, 175,0, 2,0, 225,0, 0,0, 225,0, -2,0 ; Generated By N64RightMajorTriangleCalc.py
  ; Output: Dir=1, YL=175.0, YM=175.0, YH=150.0, XL=225.0, DxLDy=0.0, XH=225.0, DxHDy=-2.0, XM=225.0, DxMDy=0.0
    Fill_Triangle 1, 0, 0, 700,700,600, 225,0, 0,0, 225,0, -2,0, 225,0, 0,0 ; Generated By N64RightMajorTriangleCalc.py
  ; Output: Dir=1, YL=200.0, YM=175.0, YH=175.0, XL=225.0, DxLDy=0.0, XH=175.0, DxHDy=2.0, XM=175.0, DxMDy=0.0
    Fill_Triangle 1, 0, 0, 800,700,700, 225,0, 0,0, 175,0, 2,0, 175,0, 0,0 ; Generated By N64RightMajorTriangleCalc.py

  Sync_Pipe ; Stall Pipeline, Until Preceeding Primitives Completely Finish
  Set_Fill_Color $FFFFFFFF ; Set Fill Color: PACKED COLOR 32B R8G8B8A8 Pixel (White)
  ;
  ;         .     v[2]:XH,XM(X:275.0) YH(Y:150.0)
  ;        / \
  ; DxMDy /   \DxHDy
  ;      /     \  
  ;     ._______. v[1]:(X:250.0) YM(Y:200.0), v[0]:XL(X:300.0) YL(Y:200.0)
  ;       DxLDy
  ;
  ; Output: Dir=0, YL=200.0, YM=200.0, YH=150.0, XL=250.0, DxLDy=0.0, XH=275.0, DxHDy=0.5, XM=275.0, DxMDy=-0.5
  ; Fill_Triangle 0, 0, 0, 800,800,600, 250,0, 0,0, 275,0, 0,32768, 275,0, -1,32768 ; Generated By N64LeftMajorTriangleCalc.py
  ; Output: Dir=1, YL=200.0, YM=200.0, YH=150.0, XL=300.0, DxLDy=0.0, XH=275.0, DxHDy=-0.5, XM=275.0, DxMDy=0.5
    Fill_Triangle 1, 0, 0, 800,800,600, 300,0, 0,0, 275,0, -1,32768, 275,0, 0,32768 ; Generated By N64RightMajorTriangleCalc.py

  Sync_Full ; Ensure Entire Scene Is Fully Drawn
RDPBufferEnd: