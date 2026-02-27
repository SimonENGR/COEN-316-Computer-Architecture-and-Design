add wave x_in
add wave y_in
add wave add_sub
add wave logic_func
add wave func
add wave output_out
add wave zero
add wave overflow

force x_in 0110
force y_in 0011

force add_sub 0
force logic_func 01
force func 00
run 10
force func 01
run 10
force func 10
run 10
force func 11
run 10

force func 10
force add_sub 0
run 10
force add_sub 1
run 10

force func 11
force logic_func 00
run 10
force logic_func 01
run 10
force logic_func 10
run 10
force logic_func 11
run 10

force func 10
force add_sub 1
force x_in 0011
force y_in 0011
run 10

force x_in 1000
force y_in 1000
force add_sub 0
run 10

force x_in 0111
force y_in 0001
force add_sub 0
run 10

