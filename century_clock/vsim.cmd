vlog -sv century_clock_tb.v century_clock.v
vsim -voptargs=+acc century_clock_tb
add wave -r *
run -all