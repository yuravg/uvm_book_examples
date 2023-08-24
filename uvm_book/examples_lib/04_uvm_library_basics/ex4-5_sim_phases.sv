/**********************************************************************
 Example 4-5: uvm_component Simulation Phases and Hierarchy Methods

 To run:   %  irun -uvm ex4-5_sim_phases.sv
 OR:       %  irun -uvmhome $UVM_HOME ex4-5_sim_phases.sv
 **********************************************************************/
package my_pkg;
  import uvm_pkg::*;
`include "uvm_macros.svh"

  class master_comp extends uvm_component;
    `uvm_component_utils(master_comp)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    // UVM run_phase() method
    task run_phase (uvm_phase phase);
      `uvm_info("MASTER", "run_phase: Executing.", UVM_LOW)
    endtask : run_phase
  endclass : master_comp

  class slave_comp extends uvm_component;
    `uvm_component_utils(slave_comp)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    // UVM run_phase() method
    task run_phase (uvm_phase phase);
      `uvm_info("SLAVE", "run_phase: Executing.", UVM_LOW)
    endtask : run_phase
  endclass : slave_comp

  class simple_if_comp extends uvm_component;

    master_comp master;
    slave_comp  slave;

    `uvm_component_utils(simple_if_comp)

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    // UVM build_phase() method
    function void build_phase(uvm_phase phase);
      `uvm_info("UVC", "build_phase: Executing.", UVM_LOW)
      master = master_comp::type_id::create("master", this);
      slave  = slave_comp::type_id::create("slave", this);
    endfunction : build_phase

    // UVM run_phase() method
    task run_phase (uvm_phase phase);
      uvm_component child, parent;
      parent = get_parent();
      `uvm_info("UVC", "run_phase: Executing.", UVM_LOW)
      `uvm_info("UVC", {"get_parent(): ", parent.get_full_name()}, UVM_LOW)
      child = get_child("master");
      `uvm_info("UVC", {"get_child(master): ", child.get_full_name()}, UVM_LOW)
      `uvm_info("UVC", {"get_child(master): ", child.get_name()}, UVM_LOW)
      child = get_child("slave");
      `uvm_info("UVC", {"get_child(slave): ", child.get_full_name()}, UVM_LOW)
      `uvm_info("UVC", {"get_child(slave): ", child.get_name()}, UVM_LOW)
    endtask : run_phase
  endclass : simple_if_comp

  class testbench_comp extends uvm_component;
    simple_if_comp my_uvc;

    `uvm_component_utils(testbench_comp)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    // UVM build_phase() method
    function void build_phase(uvm_phase phase);
      my_uvc = simple_if_comp::type_id::create("my_uvc", this);
    endfunction : build_phase

    function void end_of_elaboration_phase(uvm_phase phase);
      `uvm_info("TBENCH", {"end_of_elaboration_phase(), Hierarchy:\n",
                           this.sprint()}, UVM_LOW)
    endfunction : end_of_elaboration_phase

    // UVM run_phase() method
    task run_phase (uvm_phase phase);
      `uvm_info("TBENCH", "run_phase: Executing.", UVM_LOW)
    endtask : run_phase
  endclass : testbench_comp
endpackage : my_pkg

module test;
  import uvm_pkg::*;
`include "uvm_macros.svh"

  import my_pkg::*;

  testbench_comp testbench;

  initial begin
    // Create components
    testbench = testbench_comp::type_id::create("testbench", null);
    // Start UVM Phases
    run_test();
  end
endmodule : test

// OUTPUT:
// # UVM_INFO ex4-5_sim_phases.sv(49) @ 0: testbench.my_uvc [UVC] build_phase: Executing.
// # UVM_INFO ex4-5_sim_phases.sv(85) @ 0: testbench [TBENCH] end_of_elaboration_phase(), Hierarchy:
// # ---------------------------------------
// # Name        Type            Size  Value
// # ---------------------------------------
// # testbench   testbench_comp  -     @355
// #   my_uvc    simple_if_comp  -     @367
// #     master  master_comp     -     @377
// #     slave   slave_comp      -     @385
// # ---------------------------------------
// #
// # UVM_INFO ex4-5_sim_phases.sv(91) @ 0: testbench [TBENCH] run_phase: Executing.
// # UVM_INFO ex4-5_sim_phases.sv(58) @ 0: testbench.my_uvc [UVC] run_phase: Executing.
// # UVM_INFO ex4-5_sim_phases.sv(59) @ 0: testbench.my_uvc [UVC] get_parent(): testbench
// # UVM_INFO ex4-5_sim_phases.sv(61) @ 0: testbench.my_uvc [UVC] get_child(master): testbench.my_uvc.master
// # UVM_INFO ex4-5_sim_phases.sv(62) @ 0: testbench.my_uvc [UVC] get_child(master): master
// # UVM_INFO ex4-5_sim_phases.sv(64) @ 0: testbench.my_uvc [UVC] get_child(slave): testbench.my_uvc.slave
// # UVM_INFO ex4-5_sim_phases.sv(65) @ 0: testbench.my_uvc [UVC] get_child(slave): slave
// # UVM_INFO ex4-5_sim_phases.sv(31) @ 0: testbench.my_uvc.slave [SLAVE] run_phase: Executing.
// # UVM_INFO ex4-5_sim_phases.sv(19) @ 0: testbench.my_uvc.master [MASTER] run_phase: Executing.
// # UVM_INFO verilog_src/uvm-1.2/src/base/uvm_report_server.svh(847) @ 0: reporter [UVM/REPORT/SERVER]
// # --- UVM Report Summary ---
// #
// # ** Report counts by severity
// # UVM_INFO :   15
// # UVM_WARNING :    0
// # UVM_ERROR :    0
// # UVM_FATAL :    0
// # ** Report counts by id
// # [MASTER]     1
// # [Questa UVM]     2
// # [RNTST]     1
// # [SLAVE]     1
// # [TBENCH]     2
// # [UVC]     7
// # [UVM/RELNOTES]     1
