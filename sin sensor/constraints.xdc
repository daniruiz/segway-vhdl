## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal
set_property PACKAGE_PIN W5 [get_ports reloj]							
	set_property IOSTANDARD LVCMOS33 [get_ports reloj]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports reloj]
 
## Switches
set_property PACKAGE_PIN V17 [get_ports {pos_x[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pos_x[0]}]
set_property PACKAGE_PIN V16 [get_ports {pos_x[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pos_x[1]}]
set_property PACKAGE_PIN W16 [get_ports {pos_x[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pos_x[2]}]
set_property PACKAGE_PIN W17 [get_ports {pos_x[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pos_x[3]}]
set_property PACKAGE_PIN W15 [get_ports {pos_x[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pos_x[4]}]
set_property PACKAGE_PIN V15 [get_ports {pos_x[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pos_x[5]}]
set_property PACKAGE_PIN W14 [get_ports {pos_x[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pos_x[6]}]
set_property PACKAGE_PIN W13 [get_ports {pos_x[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pos_x[7]}]
set_property PACKAGE_PIN V2 [get_ports {pos_x[8]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pos_x[8]}]
set_property PACKAGE_PIN T3 [get_ports {pos_x[9]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pos_x[9]}]
set_property PACKAGE_PIN T2 [get_ports {pos_x[10]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pos_x[10]}]
set_property PACKAGE_PIN R3 [get_ports {pos_x[11]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pos_x[11]}]
set_property PACKAGE_PIN W2 [get_ports {pos_x[12]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pos_x[12]}]
set_property PACKAGE_PIN U1 [get_ports {pos_x[13]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pos_x[13]}]
set_property PACKAGE_PIN T1 [get_ports {pos_x[14]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pos_x[14]}]
set_property PACKAGE_PIN R2 [get_ports {pos_x[15]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pos_x[15]}]

##Pmod Header JA
#Sch name = JA1
set_property PACKAGE_PIN J1 [get_ports {L298N_ENA}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {L298N_ENA}]
#Sch name = JA2
set_property PACKAGE_PIN L2 [get_ports {L298N_IN1}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {L298N_IN1}]
##Sch name = JA3
set_property PACKAGE_PIN J2 [get_ports {L298N_IN2}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {L298N_IN2}]
#Sch name = JA4
set_property PACKAGE_PIN G2 [get_ports {L298N_IN3}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {L298N_IN3}]
#Sch name = JA7
set_property PACKAGE_PIN H1 [get_ports {L298N_IN4}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {L298N_IN4}]
#Sch name = JA8
set_property PACKAGE_PIN K2 [get_ports {L298N_ENB}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {L298N_ENB}]
