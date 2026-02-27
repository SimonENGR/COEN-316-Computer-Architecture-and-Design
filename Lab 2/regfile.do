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
force read_a 00100
force read_b 00010
force write_address 00000

run 5
force din 00001111000011110000111100001111
force reset 0
force write_address 00100
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
force write_address 00010
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

