# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_M00_AXIS_TDATA_WIDTH" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "C_S00_AXIS_TDATA_WIDTH" -parent ${Page_0} -widget comboBox


}

proc update_PARAM_VALUE.IDX_SIZE { PARAM_VALUE.IDX_SIZE } {
	# Procedure called to update IDX_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IDX_SIZE { PARAM_VALUE.IDX_SIZE } {
	# Procedure called to validate IDX_SIZE
	return true
}

proc update_PARAM_VALUE.KEY_SIZE { PARAM_VALUE.KEY_SIZE } {
	# Procedure called to update KEY_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.KEY_SIZE { PARAM_VALUE.KEY_SIZE } {
	# Procedure called to validate KEY_SIZE
	return true
}

proc update_PARAM_VALUE.NUM_BITS { PARAM_VALUE.NUM_BITS } {
	# Procedure called to update NUM_BITS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUM_BITS { PARAM_VALUE.NUM_BITS } {
	# Procedure called to validate NUM_BITS
	return true
}

proc update_PARAM_VALUE.NUM_CORNERS { PARAM_VALUE.NUM_CORNERS } {
	# Procedure called to update NUM_CORNERS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NUM_CORNERS { PARAM_VALUE.NUM_CORNERS } {
	# Procedure called to validate NUM_CORNERS
	return true
}

proc update_PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH { PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH } {
	# Procedure called to update C_M00_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH { PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_M00_AXIS_TDATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH } {
	# Procedure called to update C_S00_AXIS_TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH { PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH } {
	# Procedure called to validate C_S00_AXIS_TDATA_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.C_M00_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_M00_AXIS_TDATA_WIDTH PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_M00_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_M00_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXIS_TDATA_WIDTH { MODELPARAM_VALUE.C_S00_AXIS_TDATA_WIDTH PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S00_AXIS_TDATA_WIDTH}] ${MODELPARAM_VALUE.C_S00_AXIS_TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.NUM_BITS { MODELPARAM_VALUE.NUM_BITS PARAM_VALUE.NUM_BITS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NUM_BITS}] ${MODELPARAM_VALUE.NUM_BITS}
}

proc update_MODELPARAM_VALUE.NUM_CORNERS { MODELPARAM_VALUE.NUM_CORNERS PARAM_VALUE.NUM_CORNERS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NUM_CORNERS}] ${MODELPARAM_VALUE.NUM_CORNERS}
}

proc update_MODELPARAM_VALUE.KEY_SIZE { MODELPARAM_VALUE.KEY_SIZE PARAM_VALUE.KEY_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.KEY_SIZE}] ${MODELPARAM_VALUE.KEY_SIZE}
}

proc update_MODELPARAM_VALUE.IDX_SIZE { MODELPARAM_VALUE.IDX_SIZE PARAM_VALUE.IDX_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IDX_SIZE}] ${MODELPARAM_VALUE.IDX_SIZE}
}

