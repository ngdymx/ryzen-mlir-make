module {
  aie.device(npu1_1col) {
    memref.global "public" @out_cons : memref<1024xi32>
    memref.global "public" @out : memref<1024xi32>
    memref.global "public" @infactor_cons : memref<1xi32>
    memref.global "public" @infactor : memref<1xi32>
    memref.global "public" @in_cons : memref<1024xi32>
    memref.global "public" @in : memref<1024xi32>
    func.func private @vector_scalar_mul_aie_scalar(memref<1024xi32>, memref<1024xi32>, memref<1xi32>, i32)
    %tile_0_0 = aie.tile(0, 0)
    %tile_0_2 = aie.tile(0, 2)
    %out_cons_prod_lock = aie.lock(%tile_0_0, 4) {init = 0 : i32, sym_name = "out_cons_prod_lock"}
    %out_cons_cons_lock = aie.lock(%tile_0_0, 5) {init = 0 : i32, sym_name = "out_cons_cons_lock"}
    %out_buff_0 = aie.buffer(%tile_0_2) {address = 1024 : i32, mem_bank = 0 : i32, sym_name = "out_buff_0"} : memref<1024xi32> 
    %out_buff_1 = aie.buffer(%tile_0_2) {address = 16384 : i32, mem_bank = 1 : i32, sym_name = "out_buff_1"} : memref<1024xi32> 
    %out_prod_lock = aie.lock(%tile_0_2, 4) {init = 2 : i32, sym_name = "out_prod_lock"}
    %out_cons_lock = aie.lock(%tile_0_2, 5) {init = 0 : i32, sym_name = "out_cons_lock"}
    %infactor_cons_buff_0 = aie.buffer(%tile_0_2) {address = 5120 : i32, mem_bank = 0 : i32, sym_name = "infactor_cons_buff_0"} : memref<1xi32> 
    %infactor_cons_buff_1 = aie.buffer(%tile_0_2) {address = 20480 : i32, mem_bank = 1 : i32, sym_name = "infactor_cons_buff_1"} : memref<1xi32> 
    %infactor_cons_prod_lock = aie.lock(%tile_0_2, 2) {init = 2 : i32, sym_name = "infactor_cons_prod_lock"}
    %infactor_cons_cons_lock = aie.lock(%tile_0_2, 3) {init = 0 : i32, sym_name = "infactor_cons_cons_lock"}
    %infactor_prod_lock = aie.lock(%tile_0_0, 2) {init = 0 : i32, sym_name = "infactor_prod_lock"}
    %infactor_cons_lock = aie.lock(%tile_0_0, 3) {init = 0 : i32, sym_name = "infactor_cons_lock"}
    %in_cons_buff_0 = aie.buffer(%tile_0_2) {address = 32768 : i32, mem_bank = 2 : i32, sym_name = "in_cons_buff_0"} : memref<1024xi32> 
    %in_cons_buff_1 = aie.buffer(%tile_0_2) {address = 49152 : i32, mem_bank = 3 : i32, sym_name = "in_cons_buff_1"} : memref<1024xi32> 
    %in_cons_prod_lock = aie.lock(%tile_0_2, 0) {init = 2 : i32, sym_name = "in_cons_prod_lock"}
    %in_cons_cons_lock = aie.lock(%tile_0_2, 1) {init = 0 : i32, sym_name = "in_cons_cons_lock"}
    %in_prod_lock = aie.lock(%tile_0_0, 0) {init = 0 : i32, sym_name = "in_prod_lock"}
    %in_cons_lock = aie.lock(%tile_0_0, 1) {init = 0 : i32, sym_name = "in_cons_lock"}
    aie.flow(%tile_0_0, DMA : 0, %tile_0_2, DMA : 0)
    aie.flow(%tile_0_0, DMA : 1, %tile_0_2, DMA : 1)
    aie.flow(%tile_0_2, DMA : 0, %tile_0_0, DMA : 0)
    %core_0_2 = aie.core(%tile_0_2) {
      %c0 = arith.constant 0 : index
      %c9223372036854775807 = arith.constant 9223372036854775807 : index
      %c1 = arith.constant 1 : index
      %c9223372036854775806 = arith.constant 9223372036854775806 : index
      %c2 = arith.constant 2 : index
      cf.br ^bb1(%c0 : index)
    ^bb1(%0: index):  // 2 preds: ^bb0, ^bb8
      %1 = arith.cmpi slt, %0, %c9223372036854775806 : index
      cf.cond_br %1, ^bb2, ^bb9
    ^bb2:  // pred: ^bb1
      aie.use_lock(%infactor_cons_cons_lock, AcquireGreaterEqual, 1)
      %c0_0 = arith.constant 0 : index
      %c4 = arith.constant 4 : index
      %c1_1 = arith.constant 1 : index
      %c2_2 = arith.constant 2 : index
      cf.br ^bb3(%c0_0 : index)
    ^bb3(%2: index):  // 2 preds: ^bb2, ^bb4
      %3 = arith.cmpi slt, %2, %c4 : index
      cf.cond_br %3, ^bb4, ^bb5
    ^bb4:  // pred: ^bb3
      aie.use_lock(%out_prod_lock, AcquireGreaterEqual, 1)
      aie.use_lock(%in_cons_cons_lock, AcquireGreaterEqual, 1)
      %c1024_i32 = arith.constant 1024 : i32
      func.call @vector_scalar_mul_aie_scalar(%in_cons_buff_0, %out_buff_0, %infactor_cons_buff_0, %c1024_i32) : (memref<1024xi32>, memref<1024xi32>, memref<1xi32>, i32) -> ()
      aie.use_lock(%in_cons_prod_lock, Release, 1)
      aie.use_lock(%out_cons_lock, Release, 1)
      aie.use_lock(%out_prod_lock, AcquireGreaterEqual, 1)
      aie.use_lock(%in_cons_cons_lock, AcquireGreaterEqual, 1)
      %c1024_i32_3 = arith.constant 1024 : i32
      func.call @vector_scalar_mul_aie_scalar(%in_cons_buff_1, %out_buff_1, %infactor_cons_buff_0, %c1024_i32_3) : (memref<1024xi32>, memref<1024xi32>, memref<1xi32>, i32) -> ()
      aie.use_lock(%in_cons_prod_lock, Release, 1)
      aie.use_lock(%out_cons_lock, Release, 1)
      %4 = arith.addi %2, %c2_2 : index
      cf.br ^bb3(%4 : index)
    ^bb5:  // pred: ^bb3
      aie.use_lock(%infactor_cons_prod_lock, Release, 1)
      aie.use_lock(%infactor_cons_cons_lock, AcquireGreaterEqual, 1)
      %c0_4 = arith.constant 0 : index
      %c4_5 = arith.constant 4 : index
      %c1_6 = arith.constant 1 : index
      %c2_7 = arith.constant 2 : index
      cf.br ^bb6(%c0_4 : index)
    ^bb6(%5: index):  // 2 preds: ^bb5, ^bb7
      %6 = arith.cmpi slt, %5, %c4_5 : index
      cf.cond_br %6, ^bb7, ^bb8
    ^bb7:  // pred: ^bb6
      aie.use_lock(%out_prod_lock, AcquireGreaterEqual, 1)
      aie.use_lock(%in_cons_cons_lock, AcquireGreaterEqual, 1)
      %c1024_i32_8 = arith.constant 1024 : i32
      func.call @vector_scalar_mul_aie_scalar(%in_cons_buff_0, %out_buff_0, %infactor_cons_buff_1, %c1024_i32_8) : (memref<1024xi32>, memref<1024xi32>, memref<1xi32>, i32) -> ()
      aie.use_lock(%in_cons_prod_lock, Release, 1)
      aie.use_lock(%out_cons_lock, Release, 1)
      aie.use_lock(%out_prod_lock, AcquireGreaterEqual, 1)
      aie.use_lock(%in_cons_cons_lock, AcquireGreaterEqual, 1)
      %c1024_i32_9 = arith.constant 1024 : i32
      func.call @vector_scalar_mul_aie_scalar(%in_cons_buff_1, %out_buff_1, %infactor_cons_buff_1, %c1024_i32_9) : (memref<1024xi32>, memref<1024xi32>, memref<1xi32>, i32) -> ()
      aie.use_lock(%in_cons_prod_lock, Release, 1)
      aie.use_lock(%out_cons_lock, Release, 1)
      %7 = arith.addi %5, %c2_7 : index
      cf.br ^bb6(%7 : index)
    ^bb8:  // pred: ^bb6
      aie.use_lock(%infactor_cons_prod_lock, Release, 1)
      %8 = arith.addi %0, %c2 : index
      cf.br ^bb1(%8 : index)
    ^bb9:  // pred: ^bb1
      aie.use_lock(%infactor_cons_cons_lock, AcquireGreaterEqual, 1)
      %c0_10 = arith.constant 0 : index
      %c4_11 = arith.constant 4 : index
      %c1_12 = arith.constant 1 : index
      %c2_13 = arith.constant 2 : index
      cf.br ^bb10(%c0_10 : index)
    ^bb10(%9: index):  // 2 preds: ^bb9, ^bb11
      %10 = arith.cmpi slt, %9, %c4_11 : index
      cf.cond_br %10, ^bb11, ^bb12
    ^bb11:  // pred: ^bb10
      %c1024_i32_14 = arith.constant 1024 : i32
      func.call @vector_scalar_mul_aie_scalar(%in_cons_buff_1, %out_buff_1, %infactor_cons_buff_0, %c1024_i32_14) : (memref<1024xi32>, memref<1024xi32>, memref<1xi32>, i32) -> ()
      aie.use_lock(%in_cons_prod_lock, Release, 1)
      aie.use_lock(%out_cons_lock, Release, 1)
      aie.use_lock(%out_prod_lock, AcquireGreaterEqual, 1)
      aie.use_lock(%in_cons_cons_lock, AcquireGreaterEqual, 1)
      %c1024_i32_15 = arith.constant 1024 : i32
      func.call @vector_scalar_mul_aie_scalar(%in_cons_buff_0, %out_buff_0, %infactor_cons_buff_0, %c1024_i32_15) : (memref<1024xi32>, memref<1024xi32>, memref<1xi32>, i32) -> ()
      aie.use_lock(%in_cons_prod_lock, Release, 1)
      aie.use_lock(%out_cons_lock, Release, 1)
      %11 = arith.addi %9, %c2_13 : index
      cf.br ^bb10(%11 : index)
    ^bb12:  // pred: ^bb10
      aie.use_lock(%infactor_cons_prod_lock, Release, 1)
      aie.end
    } {link_with = "scale.o"}
    aie.flow(%tile_0_2, Trace : 0, %tile_0_0, DMA : 1)
    aie.shim_dma_allocation @in(MM2S, 0, 0)
    func.func @sequence(%arg0: memref<4096xi32>, %arg1: memref<1xi32>, %arg2: memref<4096xi32>) {
      aiex.npu.write32 {address = 213200 : ui32, column = 0 : i32, row = 2 : i32, value = 65536 : ui32}
      aiex.npu.write32 {address = 213204 : ui32, column = 0 : i32, row = 2 : i32, value = 0 : ui32}
      aiex.npu.write32 {address = 213216 : ui32, column = 0 : i32, row = 2 : i32, value = 1260527909 : ui32}
      aiex.npu.write32 {address = 213220 : ui32, column = 0 : i32, row = 2 : i32, value = 757865039 : ui32}
      aiex.npu.write32 {address = 261888 : ui32, column = 0 : i32, row = 2 : i32, value = 289 : ui32}
      aiex.npu.write32 {address = 261892 : ui32, column = 0 : i32, row = 2 : i32, value = 0 : ui32}
      aiex.npu.writebd_shimtile {bd_id = 13 : i32, buffer_length = 8192 : i32, buffer_offset = 16384 : i32, column = 0 : i32, column_num = 1 : i32, d0_size = 0 : i32, d0_stride = 0 : i32, d1_size = 0 : i32, d1_stride = 0 : i32, d2_stride = 0 : i32, ddr_id = 2 : i32, enable_packet = 0 : i32, iteration_current = 0 : i32, iteration_size = 0 : i32, iteration_stride = 0 : i32, lock_acq_enable = 0 : i32, lock_acq_id = 0 : i32, lock_acq_val = 0 : i32, lock_rel_id = 0 : i32, lock_rel_val = 0 : i32, next_bd = 0 : i32, out_of_order_id = 0 : i32, packet_id = 0 : i32, packet_type = 0 : i32, use_next_bd = 0 : i32, valid_bd = 1 : i32}
      aiex.npu.write32 {address = 119308 : ui32, column = 0 : i32, row = 0 : i32, value = 13 : ui32}
      aiex.npu.writebd_shimtile {bd_id = 0 : i32, buffer_length = 4096 : i32, buffer_offset = 0 : i32, column = 0 : i32, column_num = 1 : i32, d0_size = 0 : i32, d0_stride = 0 : i32, d1_size = 0 : i32, d1_stride = 0 : i32, d2_stride = 0 : i32, ddr_id = 2 : i32, enable_packet = 0 : i32, iteration_current = 0 : i32, iteration_size = 0 : i32, iteration_stride = 0 : i32, lock_acq_enable = 0 : i32, lock_acq_id = 0 : i32, lock_acq_val = 0 : i32, lock_rel_id = 0 : i32, lock_rel_val = 0 : i32, next_bd = 0 : i32, out_of_order_id = 0 : i32, packet_id = 0 : i32, packet_type = 0 : i32, use_next_bd = 0 : i32, valid_bd = 1 : i32}
      aiex.npu.write32 {address = 119300 : ui32, column = 0 : i32, row = 0 : i32, value = 2147483648 : ui32}
      aiex.npu.writebd_shimtile {bd_id = 1 : i32, buffer_length = 4096 : i32, buffer_offset = 0 : i32, column = 0 : i32, column_num = 1 : i32, d0_size = 0 : i32, d0_stride = 0 : i32, d1_size = 0 : i32, d1_stride = 0 : i32, d2_stride = 0 : i32, ddr_id = 0 : i32, enable_packet = 0 : i32, iteration_current = 0 : i32, iteration_size = 0 : i32, iteration_stride = 0 : i32, lock_acq_enable = 0 : i32, lock_acq_id = 0 : i32, lock_acq_val = 0 : i32, lock_rel_id = 0 : i32, lock_rel_val = 0 : i32, next_bd = 0 : i32, out_of_order_id = 0 : i32, packet_id = 0 : i32, packet_type = 0 : i32, use_next_bd = 0 : i32, valid_bd = 1 : i32}
      aiex.npu.write32 {address = 119316 : ui32, column = 0 : i32, row = 0 : i32, value = 1 : ui32}
      aiex.npu.writebd_shimtile {bd_id = 2 : i32, buffer_length = 1 : i32, buffer_offset = 0 : i32, column = 0 : i32, column_num = 1 : i32, d0_size = 0 : i32, d0_stride = 0 : i32, d1_size = 0 : i32, d1_stride = 0 : i32, d2_stride = 0 : i32, ddr_id = 1 : i32, enable_packet = 0 : i32, iteration_current = 0 : i32, iteration_size = 0 : i32, iteration_stride = 0 : i32, lock_acq_enable = 0 : i32, lock_acq_id = 0 : i32, lock_acq_val = 0 : i32, lock_rel_id = 0 : i32, lock_rel_val = 0 : i32, next_bd = 0 : i32, out_of_order_id = 0 : i32, packet_id = 0 : i32, packet_type = 0 : i32, use_next_bd = 0 : i32, valid_bd = 1 : i32}
      aiex.npu.write32 {address = 119324 : ui32, column = 0 : i32, row = 0 : i32, value = 2 : ui32}
      aiex.npu.sync {channel = 0 : i32, column = 0 : i32, column_num = 1 : i32, direction = 0 : i32, row = 0 : i32, row_num = 1 : i32}
      return
    }
    aie.shim_dma_allocation @infactor(MM2S, 1, 0)
    aie.shim_dma_allocation @out(S2MM, 0, 0)
    %mem_0_2 = aie.mem(%tile_0_2) {
      %0 = aie.dma_start(S2MM, 0, ^bb1, ^bb3)
    ^bb1:  // 2 preds: ^bb0, ^bb2
      aie.use_lock(%in_cons_prod_lock, AcquireGreaterEqual, 1)
      aie.dma_bd(%in_cons_buff_0 : memref<1024xi32>, 0, 1024) {bd_id = 0 : i32, next_bd_id = 1 : i32}
      aie.use_lock(%in_cons_cons_lock, Release, 1)
      aie.next_bd ^bb2
    ^bb2:  // pred: ^bb1
      aie.use_lock(%in_cons_prod_lock, AcquireGreaterEqual, 1)
      aie.dma_bd(%in_cons_buff_1 : memref<1024xi32>, 0, 1024) {bd_id = 1 : i32, next_bd_id = 0 : i32}
      aie.use_lock(%in_cons_cons_lock, Release, 1)
      aie.next_bd ^bb1
    ^bb3:  // pred: ^bb0
      %1 = aie.dma_start(S2MM, 1, ^bb4, ^bb6)
    ^bb4:  // 2 preds: ^bb3, ^bb5
      aie.use_lock(%infactor_cons_prod_lock, AcquireGreaterEqual, 1)
      aie.dma_bd(%infactor_cons_buff_0 : memref<1xi32>, 0, 1) {bd_id = 2 : i32, next_bd_id = 3 : i32}
      aie.use_lock(%infactor_cons_cons_lock, Release, 1)
      aie.next_bd ^bb5
    ^bb5:  // pred: ^bb4
      aie.use_lock(%infactor_cons_prod_lock, AcquireGreaterEqual, 1)
      aie.dma_bd(%infactor_cons_buff_1 : memref<1xi32>, 0, 1) {bd_id = 3 : i32, next_bd_id = 2 : i32}
      aie.use_lock(%infactor_cons_cons_lock, Release, 1)
      aie.next_bd ^bb4
    ^bb6:  // pred: ^bb3
      %2 = aie.dma_start(MM2S, 0, ^bb7, ^bb9)
    ^bb7:  // 2 preds: ^bb6, ^bb8
      aie.use_lock(%out_cons_lock, AcquireGreaterEqual, 1)
      aie.dma_bd(%out_buff_0 : memref<1024xi32>, 0, 1024) {bd_id = 4 : i32, next_bd_id = 5 : i32}
      aie.use_lock(%out_prod_lock, Release, 1)
      aie.next_bd ^bb8
    ^bb8:  // pred: ^bb7
      aie.use_lock(%out_cons_lock, AcquireGreaterEqual, 1)
      aie.dma_bd(%out_buff_1 : memref<1024xi32>, 0, 1024) {bd_id = 5 : i32, next_bd_id = 4 : i32}
      aie.use_lock(%out_prod_lock, Release, 1)
      aie.next_bd ^bb7
    ^bb9:  // pred: ^bb6
      aie.end
    }
  }
}
