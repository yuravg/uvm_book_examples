/**********************************************************************
 Example 4-21a: Callbacks Example

 To run:   %  irun -uvm  ex4-21a_callbacks.sv
 **********************************************************************/
module test;
  import uvm_pkg::*;
`include "uvm_macros.svh"
`include "apb_transfer.sv"

  virtual class driver_cb extends uvm_callback;
    function new(string name = "driver_cb");
      super.new(name);
    endfunction : new
    pure virtual function void modify_transfer(apb_transfer transfer);
  endclass : driver_cb

  class driver extends uvm_component;
    `uvm_register_cb(driver, driver_cb)

    `uvm_component_utils(driver)
    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    task run_phase(uvm_phase phase);
      apb_transfer transfer;
      transfer = apb_transfer::type_id::create("transfer");
      void'(transfer.randomize());
      drive_transfer(transfer);
    endtask : run_phase

    virtual task drive_transfer(apb_transfer transfer);
      `uvm_do_callbacks(driver, driver_cb, modify_transfer(transfer))
      // drive DUT signals
      `uvm_info("DRIVER", transfer.sprint(uvm_default_line_printer), UVM_LOW)
    endtask : drive_transfer
  endclass : driver

  typedef uvm_callbacks #(driver, driver_cb) driver_cb_type;

  class my_driver_cb extends driver_cb;
    `uvm_object_utils(my_driver_cb)

    function new(string name="my_driver_cb");
      super.new(name);
    endfunction : new

    virtual function void modify_transfer(apb_transfer transfer);
      `uvm_info("DRIVER_CB", "injecting an error into the transfer", UVM_LOW)
    endfunction : modify_transfer
  endclass : my_driver_cb

  class agent extends uvm_component;
    `uvm_component_utils(agent)

    driver my_driver;

    function new(string name, uvm_component parent);
      super.new(name, parent);
      my_driver = driver::type_id::create("my_driver", this);
    endfunction : new

    function void end_of_elaboration_phase(uvm_phase phase);
      this.print();
    endfunction : end_of_elaboration_phase
  endclass : agent

  my_driver_cb cb;
  agent my_agent;

  initial begin
    cb = my_driver_cb::type_id::create("cb");
    // Create the agent
    my_agent = agent::type_id::create("my_agent", null);
    // Create the callback and add
    driver_cb_type::add(null, cb);
    // Run the UVM Phases
    run_test();
  end
endmodule : test

// OUTPUT:
// # UVM_INFO @ 0: reporter [RNTST] Running test ...
// # --------------------------------
// # Name         Type    Size  Value
// # --------------------------------
// # my_agent     agent   -     @372
// #   my_driver  driver  -     @380
// # --------------------------------
// # UVM_INFO ex4-21a_callbacks.sv(50) @ 0: reporter [DRIVER_CB] injecting an error into the transfer
// # UVM_INFO ex4-21a_callbacks.sv(36) @ 0: my_agent.my_driver [DRIVER] transfer: (apb_transfer@401) { addr: 'hd6cd8cf2  data: 'h99d7bae9  direction: APB_WRITE  transmit_delay: 'hd  }
// #
// # UVM_INFO verilog_src/uvm-1.2/src/base/uvm_report_server.svh(847) @ 0: reporter [UVM/REPORT/SERVER]
// # --- UVM Report Summary ---
// #
// # ** Report counts by severity
// # UVM_INFO :    6
// # UVM_WARNING :    0
// # UVM_ERROR :    0
// # UVM_FATAL :    0
// # ** Report counts by id
// # [DRIVER]     1
// # [DRIVER_CB]     1
// # [Questa UVM]     2
// # [RNTST]     1
// # [UVM/RELNOTES]     1
