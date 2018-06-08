## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal
set_property PACKAGE_PIN W5 [get_ports reloj]							
	set_property IOSTANDARD LVCMOS33 [get_ports reloj]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports reloj]

##Pmod Header JA
#Sch name = JA1
set_property PACKAGE_PIN J1 [get_ports {l298n_ena}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {l298n_ena}]
#Sch name = JA2
set_property PACKAGE_PIN L2 [get_ports {l298n_in1}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {l298n_in1}]
##Sch name = JA3
set_property PACKAGE_PIN J2 [get_ports {l298n_in2}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {l298n_in2}]
#Sch name = JA4
set_property PACKAGE_PIN G2 [get_ports {l298n_in3}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {l298n_in3}]
#Sch name = JA7
set_property PACKAGE_PIN H1 [get_ports {l298n_in4}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {l298n_in4}]
#Sch name = JA8
set_property PACKAGE_PIN K2 [get_ports {l298n_enb}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {l298n_enb}]


##Pmod Header JB
#Sch name = JB1
set_property PACKAGE_PIN B15 [get_ports {sda}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {sda}]
#Sch name = JB4
set_property PACKAGE_PIN B16 [get_ports {scl}]                    
    set_property IOSTANDARD LVCMOS33 [get_ports {scl}]

