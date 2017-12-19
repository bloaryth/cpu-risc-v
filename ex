#! c:/iverilog-x64/bin/vvp
:ivl_version "10.1 (stable)" "(v10_1_1)";
:ivl_delay_selection "TYPICAL";
:vpi_time_precision + 0;
:vpi_module "system";
:vpi_module "vhdl_sys";
:vpi_module "v2005_math";
:vpi_module "va_math";
S_0000000002f87a20 .scope module, "ex" "ex" 2 3;
 .timescale 0 0;
    .port_info 0 /INPUT 1 "rst"
    .port_info 1 /INPUT 8 "aluop_i"
    .port_info 2 /INPUT 3 "alusel_i"
    .port_info 3 /INPUT 32 "reg1_i"
    .port_info 4 /INPUT 32 "reg2_i"
    .port_info 5 /INPUT 5 "wd_i"
    .port_info 6 /INPUT 1 "wreg_i"
    .port_info 7 /OUTPUT 5 "wd_o"
    .port_info 8 /OUTPUT 1 "wreg_o"
    .port_info 9 /OUTPUT 32 "wdata_o"
    .port_info 10 /OUTPUT 32 "logicout"
o000000000477ab78 .functor BUFZ 8, C4<zzzzzzzz>; HiZ drive
v0000000002f87c60_0 .net "aluop_i", 7 0, o000000000477ab78;  0 drivers
o000000000477aba8 .functor BUFZ 3, C4<zzz>; HiZ drive
v00000000047cb880_0 .net "alusel_i", 2 0, o000000000477aba8;  0 drivers
v00000000047cb920_0 .var "logicout", 31 0;
o000000000477ac08 .functor BUFZ 32, C4<zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz>; HiZ drive
v00000000047cb9c0_0 .net "reg1_i", 31 0, o000000000477ac08;  0 drivers
o000000000477ac38 .functor BUFZ 32, C4<zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz>; HiZ drive
v00000000047cba60_0 .net "reg2_i", 31 0, o000000000477ac38;  0 drivers
o000000000477ac68 .functor BUFZ 1, C4<z>; HiZ drive
v00000000047cbb00_0 .net "rst", 0 0, o000000000477ac68;  0 drivers
o000000000477ac98 .functor BUFZ 5, C4<zzzzz>; HiZ drive
v00000000047cbba0_0 .net "wd_i", 4 0, o000000000477ac98;  0 drivers
v00000000047cbc40_0 .var "wd_o", 4 0;
v00000000047cbce0_0 .var "wdata_o", 31 0;
o000000000477ad28 .functor BUFZ 1, C4<z>; HiZ drive
v00000000047cbe10_0 .net "wreg_i", 0 0, o000000000477ad28;  0 drivers
v00000000047cbeb0_0 .var "wreg_o", 0 0;
E_0000000004774170 .event edge, v00000000047cbba0_0, v00000000047cbe10_0, v00000000047cb880_0, v00000000047cb920_0;
E_0000000004774230 .event edge, v00000000047cbb00_0, v0000000002f87c60_0, v00000000047cb9c0_0, v00000000047cba60_0;
    .scope S_0000000002f87a20;
T_0 ;
    %wait E_0000000004774230;
    %load/vec4 v00000000047cbb00_0;
    %cmpi/e 1, 0, 1;
    %jmp/0xz  T_0.0, 4;
    %pushi/vec4 0, 0, 32;
    %assign/vec4 v00000000047cb920_0, 0;
    %jmp T_0.1;
T_0.0 ;
    %load/vec4 v0000000002f87c60_0;
    %dup/vec4;
    %pushi/vec4 37, 0, 8;
    %cmp/u;
    %jmp/1 T_0.2, 6;
    %pushi/vec4 0, 0, 32;
    %assign/vec4 v00000000047cb920_0, 0;
    %jmp T_0.4;
T_0.2 ;
    %load/vec4 v00000000047cb9c0_0;
    %load/vec4 v00000000047cba60_0;
    %or;
    %assign/vec4 v00000000047cb920_0, 0;
    %jmp T_0.4;
T_0.4 ;
    %pop/vec4 1;
T_0.1 ;
    %jmp T_0;
    .thread T_0, $push;
    .scope S_0000000002f87a20;
T_1 ;
    %wait E_0000000004774170;
    %load/vec4 v00000000047cbba0_0;
    %assign/vec4 v00000000047cbc40_0, 0;
    %load/vec4 v00000000047cbe10_0;
    %assign/vec4 v00000000047cbeb0_0, 0;
    %load/vec4 v00000000047cb880_0;
    %dup/vec4;
    %pushi/vec4 1, 0, 3;
    %cmp/u;
    %jmp/1 T_1.0, 6;
    %pushi/vec4 0, 0, 32;
    %assign/vec4 v00000000047cbce0_0, 0;
    %jmp T_1.2;
T_1.0 ;
    %load/vec4 v00000000047cb920_0;
    %assign/vec4 v00000000047cbce0_0, 0;
    %jmp T_1.2;
T_1.2 ;
    %pop/vec4 1;
    %jmp T_1;
    .thread T_1, $push;
# The file index is used to find the file name in the following table.
:file_names 3;
    "N/A";
    "<interactive>";
    "ex.v";
