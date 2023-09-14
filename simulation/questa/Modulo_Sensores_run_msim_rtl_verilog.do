transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/wesle/Documents/PBL1-SD {C:/Users/wesle/Documents/PBL1-SD/BaudRateGenerator.v}
vlog -vlog01compat -work work +incdir+C:/Users/wesle/Documents/PBL1-SD {C:/Users/wesle/Documents/PBL1-SD/Rx_module.v}
vlog -vlog01compat -work work +incdir+C:/Users/wesle/Documents/PBL1-SD {C:/Users/wesle/Documents/PBL1-SD/controlePC_FPGA.v}

