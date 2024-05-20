#
# This file is licensed under the Apache License v2.0 with LLVM Exceptions.
# See https://llvm.org/LICENSE.txt for license information.
# SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
#
# Copyright (C) 2024, Advanced Micro Devices, Inc.

SRCDIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

VITIS_ROOT ?= $(shell realpath $(dir $(shell which vitis))/../)
VITIS_AIETOOLS_DIR ?= ${VITIS_ROOT}/aietools
VITIS_AIE_INCLUDE_DIR ?= ${VITIS_ROOT}/aietools/data/versal_prod/lib
VITIS_AIE2_INCLUDE_DIR ?= ${VITIS_ROOT}/aietools/data/aie_ml/lib

CHESSCC1_FLAGS = -f -p me -P ${VITIS_AIE_INCLUDE_DIR} -I ${VITIS_AIETOOLS_DIR}/include
CHESSCC2_FLAGS = -f -p me -P ${VITIS_AIE2_INCLUDE_DIR} -I ${VITIS_AIETOOLS_DIR}/include -D__AIENGINE__=2 -D__AIEARCH__=20
CHESS_FLAGS = -P ${VITIS_AIE_INCLUDE_DIR}

CHESSCCWRAP1_FLAGS = aie -I ${VITIS_AIETOOLS_DIR}/include 
CHESSCCWRAP2_FLAGS = aie2 -I ${VITIS_AIETOOLS_DIR}/include 




HOST_O_DIR := build/host
HOST_C_TARGET := host.exe

KERNEL_O_DIR := build/bitstream
KERNEL_SRCS := $(wildcard $(SRCDIR)/kernel/*.cc)
KERNEL_OBJS := $(patsubst $(SRCDIR)/kernel/%.cc, ${KERNEL_O_DIR}/%.o, $(KERNEL_SRCS))
KERNEL_HEADERS := $(wildcard $(SRCDIR)/kernel/*.h)

MLIR_O_DIR := build/mlir
MLIR_TARGET := ${MLIR_O_DIR}/aie.mlir

BITSTREAM_O_DIR := build/bitstream
XCLBIN_TARGET := ${BITSTREAM_O_DIR}/final.xclbin
INSTS_TARGET := ${BITSTREAM_O_DIR}/insts.txt

.PHONY: all kernel link bitstream host clean
all: ${XCLBIN_TARGET} ${INSTS_TARGET} ${HOST_C_TARGET}


clean:
	-@rm -rf build 
	-@rm -rf log

kernel: ${KERNEL_OBJS}


link: ${MLIR_TARGET}


bitstream: ${XCLBIN_TARGET}


host: ${HOST_C_TARGET}


# Build host
${HOST_C_TARGET}: ${SRCDIR}/host/host.cpp 
	rm -rf ${HOST_O_DIR}
	mkdir -p ${HOST_O_DIR}
	cd ${HOST_O_DIR} && cmake -E env CXXFLAGS="-std=c++23 -ggdb" cmake ../.. -D CMAKE_C_COMPILER=gcc-13 -D CMAKE_CXX_COMPILER=g++-13 -DTARGET_NAME=${HOST_C_TARGET} -Dsubdir=${subdir}
	cd ${HOST_O_DIR} && cmake --build . --config Release
	cp ${HOST_O_DIR}/${HOST_C_TARGET} ./

# Build kernels
${KERNEL_O_DIR}/%.o: ${SRCDIR}/kernel/%.cc ${KERNEL_HEADERS}
	mkdir -p ${@D}
	cd ${@D} && xchesscc_wrapper ${CHESSCCWRAP2_FLAGS} -DINT8_ACT -c $< -o ${@F}

# Build mlir
${MLIR_TARGET}: ${SRCDIR}/kernel/aie2.py
	mkdir -p ${@D}
	python3 $< > $@

# Build bitstream
${XCLBIN_TARGET}: ${MLIR_TARGET} ${KERNEL_OBJS}
	mkdir -p ${@D}
	cd ${BITSTREAM_O_DIR} && aiecc.py --aie-generate-cdo --no-compile-host --xclbin-name=${@F} \
		--aie-generate-npu --npu-insts-name=${INSTS_TARGET:${BITSTREAM_O_DIR}/%=%} $(<:${MLIR_O_DIR}/%=../mlir/%) 

.PHONY: run
run: ${HOST_C_TARGET} ${XCLBIN_TARGET} ${INSTS_TARGET} #sign
	export XRT_HACK_UNSECURE_LOADING_XCLBIN=1 && \
	./$< -x ${XCLBIN_TARGET} -i ${INSTS_TARGET} -k MLIR_AIE 

trace: ${HOST_C_TARGET} ${XCLBIN_TARGET} ${INSTS_TARGET} # sign
	export XRT_HACK_UNSECURE_LOADING_XCLBIN=1 && \
	./$< -x ${XCLBIN_TARGET} -i ${INSTS_TARGET} -k MLIR_AIE
	./parse_trace.py --filename trace.txt --mlir ${MLIR_TARGET} --colshift 1 > trace_mm.json

run_py: ${XCLBIN_TARGET} ${INSTS_TARGET} ${SRCDIR}/host/test.py
	python3 ${SRCDIR}/host/test.py -x ${<} -i ${INSTS_TARGET} -k MLIR_AIE

