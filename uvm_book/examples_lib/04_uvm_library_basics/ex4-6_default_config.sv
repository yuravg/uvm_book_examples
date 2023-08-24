/**********************************************************************
 Example 4-6: Configuration Mechanism (no configuration)

 To run:   %  irun -uvm ex4-6_default_config.sv
 OR:       %  irun -uvmhome $UVM_HOME ex4-6_default_config.sv
 **********************************************************************/
package my_pkg;
  import uvm_pkg::*;
`include "uvm_macros.svh"

  class master_comp extends uvm_component;
    `uvm_component_utils(master_comp)

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    task run_phase (uvm_phase phase);
      `uvm_info("MASTER", "run_phase: Executing.", UVM_LOW)
    endtask : run_phase
  endclass : master_comp

  class slave_comp extends uvm_component;
    `uvm_component_utils(slave_comp)

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    task run_phase (uvm_phase phase);
      `uvm_info("SLAVE", "run_phase: Executing.", UVM_LOW)
    endtask : run_phase
  endclass : slave_comp

  class interface_comp extends uvm_component;
    master_comp master[];  // dynamic array of masters
    slave_comp  slave[];   // dynamic array of slaves
    int num_masters = 3;
    int num_slaves = 5;
    string if_name = "bus_uvc";

    `uvm_component_utils_begin(interface_comp)
      `uvm_field_string(if_name, UVM_DEFAULT)
      `uvm_field_int(num_masters, UVM_DEFAULT)
      `uvm_field_int(num_slaves, UVM_DEFAULT)
    `uvm_component_utils_end

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
      master = new[num_masters];
      slave = new[num_slaves];
      foreach (master[i])
        master[i] = master_comp::type_id::create($sformatf("master[%0d]",i), this);
      foreach (slave[i])
        slave[i]  = slave_comp::type_id::create($sformatf("slave[%0d]",i), this);
    endfunction : build_phase

    task run_phase (uvm_phase phase);
      `uvm_info("UVC", {"run_phase: Hierarchy:\n",this.sprint()}, UVM_LOW)
      `uvm_info("UVC", $sformatf("%s has %0d master(s) and %0d slave(s)",
                                 if_name, num_masters, num_slaves), UVM_LOW)
    endtask : run_phase
  endclass : interface_comp
endpackage : my_pkg

module test;
  import uvm_pkg::*;
`include "uvm_macros.svh"

  import my_pkg::*;

  interface_comp my_uvc;

  initial begin
    // Create components
    my_uvc = interface_comp::type_id::create("my_uvc", null);
    // Start UVM Phases
    run_test();
  end
endmodule : test

// OUTPUT:
// # --------------------------------------------
// # Name           Type            Size  Value
// # --------------------------------------------
// # my_uvc         interface_comp  -     @355
// #   master[0]    master_comp     -     @369
// #   master[1]    master_comp     -     @377
// #   master[2]    master_comp     -     @385
// #   slave[0]     slave_comp      -     @393
// #   slave[1]     slave_comp      -     @401
// #   slave[2]     slave_comp      -     @409
// #   slave[3]     slave_comp      -     @417
// #   slave[4]     slave_comp      -     @425
// #   if_name      string          7     bus_uvc
// #   num_masters  integral        32    'h3
// #   num_slaves   integral        32    'h5
// # --------------------------------------------
// #
// # UVM_INFO ex4-6_default_config.sv(63) @ 0: my_uvc [UVC] bus_uvc has 3 master(s) and 5 slave(s)
// # UVM_INFO ex4-6_default_config.sv(31) @ 0: my_uvc.slave[4] [SLAVE] run_phase: Executing.
// # UVM_INFO ex4-6_default_config.sv(31) @ 0: my_uvc.slave[3] [SLAVE] run_phase: Executing.
// # UVM_INFO ex4-6_default_config.sv(31) @ 0: my_uvc.slave[2] [SLAVE] run_phase: Executing.
// # UVM_INFO ex4-6_default_config.sv(31) @ 0: my_uvc.slave[1] [SLAVE] run_phase: Executing.
// # UVM_INFO ex4-6_default_config.sv(31) @ 0: my_uvc.slave[0] [SLAVE] run_phase: Executing.
// # UVM_INFO ex4-6_default_config.sv(19) @ 0: my_uvc.master[2] [MASTER] run_phase: Executing.
// # UVM_INFO ex4-6_default_config.sv(19) @ 0: my_uvc.master[1] [MASTER] run_phase: Executing.
// # UVM_INFO ex4-6_default_config.sv(19) @ 0: my_uvc.master[0] [MASTER] run_phase: Executing.
// # UVM_INFO verilog_src/uvm-1.2/src/base/uvm_report_server.svh(847) @ 0: reporter [UVM/REPORT/SERVER]
// # --- UVM Report Summary ---
// #
// # ** Report counts by severity
// # UVM_INFO :   14
// # UVM_WARNING :    0
// # UVM_ERROR :    0
// # UVM_FATAL :    0
// # ** Report counts by id
// # [MASTER]     3
// # [Questa UVM]     2
// # [RNTST]     1
// # [SLAVE]     5
// # [UVC]     2
// # [UVM/RELNOTES]     1
