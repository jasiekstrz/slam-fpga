-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2025.1 (lin64) Build 6140274 Wed May 21 22:58:25 MDT 2025
-- Date        : Mon Dec  8 21:19:30 2025
-- Host        : eecs-digital-47 running 64-bit Ubuntu 24.04.3 LTS
-- Command     : write_vhdl -force -mode funcsim
--               /home/jstrz/slam/corner_detection.gen/sources_1/bd/design_1/ip/design_1_tristate_0_0/design_1_tristate_0_0_sim_netlist.vhdl
-- Design      : design_1_tristate_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_tristate_0_0_tristate is
  port (
    o : out STD_LOGIC;
    oi : inout STD_LOGIC;
    i : in STD_LOGIC;
    t : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of design_1_tristate_0_0_tristate : entity is "tristate";
end design_1_tristate_0_0_tristate;

architecture STRUCTURE of design_1_tristate_0_0_tristate is
  attribute BOX_TYPE : string;
  attribute BOX_TYPE of mib : label is "PRIMITIVE";
  attribute CAPACITANCE : string;
  attribute CAPACITANCE of mib : label is "DONT_CARE";
  attribute IBUF_DELAY_VALUE : string;
  attribute IBUF_DELAY_VALUE of mib : label is "0";
  attribute IFD_DELAY_VALUE : string;
  attribute IFD_DELAY_VALUE of mib : label is "AUTO";
  attribute BOX_TYPE of mob : label is "PRIMITIVE";
  attribute CAPACITANCE of mob : label is "DONT_CARE";
begin
mib: unisim.vcomponents.IBUF
    generic map(
      IOSTANDARD => "DEFAULT"
    )
        port map (
      I => oi,
      O => o
    );
mob: unisim.vcomponents.OBUFT
    generic map(
      IOSTANDARD => "DEFAULT"
    )
        port map (
      I => i,
      O => oi,
      T => t
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_tristate_0_0 is
  port (
    i : in STD_LOGIC;
    t : in STD_LOGIC;
    oi : inout STD_LOGIC;
    o : out STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of design_1_tristate_0_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of design_1_tristate_0_0 : entity is "design_1_tristate_0_0,tristate,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of design_1_tristate_0_0 : entity is "yes";
  attribute IP_DEFINITION_SOURCE : string;
  attribute IP_DEFINITION_SOURCE of design_1_tristate_0_0 : entity is "module_ref";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of design_1_tristate_0_0 : entity is "tristate,Vivado 2025.1";
end design_1_tristate_0_0;

architecture STRUCTURE of design_1_tristate_0_0 is
begin
inst: entity work.design_1_tristate_0_0_tristate
     port map (
      i => i,
      o => o,
      oi => oi,
      t => t
    );
end STRUCTURE;
