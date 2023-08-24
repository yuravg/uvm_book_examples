// From: MentorGraphics Verification Academy: UVM Cookbook:
//   On (not) using `uvm_field macros The `uvm_field macros hurt run-time performance, can make
// debug more difficult, and can not accomodate custom behaviors (e.g. conditional packing,
// copying, etc. based on value of another field). The macros generate far more code than is
// necessary to implement the operations directly. This consumes memory and hurts performance. Even
// a small performance decrease of 1% can dramatically affect regression times and lowers the
// ceiling on potential accelerator/emulator performance gains.

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
    `uvm_component_utils(interface_comp)

    master_comp master[];  // dynamic array of masters
    slave_comp  slave[];   // dynamic array of slaves
    int num_masters = 1;
    int num_slaves = 1;
    string if_name = "bus_uvc";

    function void do_record(uvm_recorder recorder);
      `uvm_record_field("if_name", if_name)
      `uvm_record_field("num_masters", num_masters)
      `uvm_record_field("num_slaves", num_slaves)
    endfunction : do_record

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
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
    // Configure BEFORE create
    uvm_config_string::set(null, "my_uvc", "if_name", "APB_UVC");
    uvm_config_int::set(null, "my_uvc", "num_masters", 2);
    uvm_config_int::set(null, "my_uvc", "num_slaves", 4);
    // Create components
    my_uvc = interface_comp::type_id::create("my_uvc", null);
    // Start UVM Phases
    run_test();
  end

endmodule : test

// OUTPUT:
// # UVM_INFO ex4-7_config_record_field_macro.sv(66) @ 0: my_uvc [UVC] run_phase: Hierarchy:
// # ----------------------------------------
// # Name         Type            Size  Value
// # ----------------------------------------
// # my_uvc       interface_comp  -     @363
// #   master[0]  master_comp     -     @375
// #   slave[0]   slave_comp      -     @383
// # ----------------------------------------
// #
// # UVM_INFO ex4-7_config_record_field_macro.sv(67) @ 0: my_uvc [UVC] bus_uvc has 1 master(s) and 1 slave(s)
// # UVM_INFO ex4-7_config_record_field_macro.sv(33) @ 0: my_uvc.slave[0] [SLAVE] run_phase: Executing.
// # UVM_INFO ex4-7_config_record_field_macro.sv(21) @ 0: my_uvc.master[0] [MASTER] run_phase: Executing.
