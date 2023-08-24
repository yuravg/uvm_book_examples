//-----------------------------------------------------------------
// File: ex4-0_hello_world.sv
//
// To Run:  %  irun -uvm ex4-0_hello_world.sv
//
// OR:      %  irun -uvmhome $UVM_HOME ex4-0_hello_world.sv
//-----------------------------------------------------------------
module hello_world_example;
  // Import the UVM library and include the UVM macros
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  initial begin
    `uvm_info("info1", "Hello World!", UVM_LOW)
  end
endmodule : hello_world_example

// OUTPUT:
// # UVM_INFO ex4-0_hello_world.sv(14) @ 0: reporter [info1] Hello World!
