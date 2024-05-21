# MLIR_Make

This make file use xilinx vitis aie_tool and mlir to build kernels.

# Targets

## all (default target)

Build kernels, link kernels, build host program.

## kernel

Build kernels. The new kernels are saved in the ./build/bitstream.

## link

Link the kernels. The linker file ./kernel/aie.py share be edit beforehead.

## bitstream

Build kernels and link the kernels. It will generate final.xclbin and insts.txt

## host

Build the host excutable file. 

## run

Run the emulation

## trace 

Run the emulation and generate the trace.json file. It can be opened in [link](http://ui.perfetto.dev).

## clean

Clean up the project.
