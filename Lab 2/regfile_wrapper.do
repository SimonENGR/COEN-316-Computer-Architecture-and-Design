add wave din
add wave reset
add wave clk
add wave write
add wave read_a
add wave read_b
add wave write_address
add wave out_a
add wave out_b

force clk 0
force reset 1
force write 0
force read_a 10
force read_b 01
force write_address 00

run 5
force din 0011
force reset 0
force write_address 10
run 1
force clk 1
run 5
force clk 0
run 5
force write 1
run 1
force clk 1
run 5
force clk 0
run 5
force write_address 01
run 1
force clk 1
run 5
force clk 0
run 5
force clk 1
run 5
force clk 0
run 5
force clk 1
run 5
force clk 0
run 5

