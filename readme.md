# ESN Project - I2C enabled Sopc + accelerometer + :computer: VGA :sparkle:

*note: for the best viewing experience, view this document in vscode with the [markdown preview enhanced by Yiyi Wang extension](https://marketplace.visualstudio.com/items?itemName=shd101wyy.markdown-preview-enhanced) installed, otherwise open the PDF version found [here](./readme.pdf)*

*you may need to set this setting in the extension's settings (done through the GUI):*
```yaml
plantuml server:
https://kroki.io/plantuml/svg/
```

to start cygwin from powershell:
```pwsh
& 'C:\intelFPGA\18.1\nios2eds\Nios II Command Shell.bat'
```

to generate bsp:

```bash
nios2-bsp hal ./software/bsp/ ./*.sopcinfo
```

to generate makefile:
```bash
nios2-app-generate-makefile --app-dir ./software/app --bsp-dir ./software/bsp --elf-name maion.elf --src-files ./sofware/app/main.c
```

both (one liner):
```bash
nios2-bsp hal ./software/bsp/ ./*.sopcinfo && nios2-app-generate-makefile --app-dir ./software/app --bsp-dir ./software/bsp --elf-name maion.elf --src-files ./sofware/app/main.c
```

## Introduction

This project aims to add an I2C interface using an open cores IP block over AVMM, in order to communicate with an accelerometer.

This version has an entire VGA driver built from scratch added to it do display the data in the form of a 2D crosshair on a screen (640x480 at 30 fps).

## System architecture

Similar to the other version of this project, with the added VGA hardware.

```mermaid
---
config:
  sankey:
    showValues: false
---
sankey-beta
NIOS2, AVMM, 0.4
AVMM, AV2SEGM, 0.22
AVMM, Timer_0, 0.05
AVMM, PIO(button), 0.03
AVMM, VGA, 0.1
PIO(button), btn_i(1), 0.03
AV2SEGM, 7-Segment (Ones), 0.073
AV2SEGM, 7-Segment (Tens), 0.073
AV2SEGM, 7-Segment (Hundreds), 0.073
VGA, HS, 0.03
VGA, VS, 0.03
VGA, RGB, 0.035
JTAG, NIOS2, 0.1
NIOS2, IRQ, 0.05
IRQ, Timer_0, 0.05
M10K memory, NIOS2, 0.1
CLK 50M, NIOS2, 0.05
RESET, NIOS2, 0.05
```

```plantuml
@startuml

rectangle NIOS2
rectangle Reset
rectangle Jtag
rectangle "Clock 50MHz"
rectangle "M10K Memory"
rectangle "AVMM Data Bus"
rectangle "AVMM Instruction Bus"
rectangle "AV2SEGM3_1"
rectangle "AV2SEGM3_2"
rectangle "opencores_i2c"
rectangle "VGA"

NIOS2 <-u-> Reset 
NIOS2 <-r-> "Clock 50MHz"
NIOS2 <-l-> "AVMM Instruction Bus"
NIOS2 <-d-> "AVMM Data Bus"
"AVMM Instruction Bus" <-d-> "M10K Memory"
"AVMM Data Bus" -r-> Jtag
"AVMM Data Bus" -d-> "AV2SEGM3_1"
"AVMM Data Bus" -d-> "AV2SEGM3_2"
"AVMM Data Bus" -l-> "M10K Memory"
"AVMM Data Bus" --> "opencores_i2c"
"AVMM Data Bus" --> "VGA"
"Clock 50MHz" --> "opencores_i2c"
"opencores_i2c" --> "scl"
"opencores_i2c" --> "sda"
"AV2SEGM3_1" -d-> "7 segment 1"
"AV2SEGM3_1" -d-> "7 segment 2"
"AV2SEGM3_1" -d-> "7 segment 3"
"AV2SEGM3_2" -d-> "7 segment 4"
"AV2SEGM3_2" -d-> "7 segment 5"
"AV2SEGM3_2" -d-> "7 segment 6"

"VGA" -d-> "Hsync"
"VGA" -d-> "Vsync"
"VGA" -d-> "RGB"

@enduml
```

## Progress

The system is fully functionnal

## Conclusion
