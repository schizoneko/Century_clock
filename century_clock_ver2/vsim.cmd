vlog -sv clock_tb.v clock.v second.v minute.v hour.v counter.v
vsim -voptargs=+acc clock_tb
add wave -r *
run -all