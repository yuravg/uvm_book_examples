/**********************************************************************
 Example 4-21b: Callbacks

 To run:   %  irun -uvm ex4-21b_callbacks.sv
 **********************************************************************/

module test;
  import uvm_pkg::*;
`include "uvm_macros.svh"

  virtual class inj_err_cb extends uvm_callback;
    `uvm_object_utils(inj_err_cb)

    function new(string name = "inj_err_cb");
      super.new(name);
    endfunction : new

    pure virtual function void inject_err(uvm_object pkt);
  endclass : inj_err_cb

  class driver extends uvm_component;
    `uvm_component_utils(driver)
    `uvm_register_cb(driver, inj_err_cb)

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    virtual task drive_transfer(uvm_object pkt);
      `uvm_do_callbacks(driver, inj_err_cb, inject_err(pkt))
      // drive DUT signals
    endtask : drive_transfer
  endclass : driver

  typedef uvm_callbacks #(driver, inj_err_cb) inj_err_cb_type;

  class my_driver_cb extends inj_err_cb;
    function new(string name="my_driver_cb");
      super.new(name);
    endfunction : new

    virtual function void inject_err(uvm_object pkt);
      `uvm_info("my_driver_cb", "injecting an error into the packet", UVM_LOW)
    endfunction : inject_err
  endclass : my_driver_cb

  class agent extends uvm_component;
    `uvm_component_utils(agent)

    driver my_driver;

    function new(string name, uvm_component parent);
      super.new(name, parent);
      my_driver = driver::type_id::create("my_driver", this);
    endfunction : new
  endclass : agent

  class my_project_driver extends driver;
    `uvm_component_utils(my_project_driver)

    virtual task drive_transfer(uvm_object pkt);
      super.drive_transfer(pkt);
      `uvm_info("MYINFO", "Finished driving transfer", UVM_LOW)
    endtask : drive_transfer

    function new (string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new
  endclass : my_project_driver

  my_driver_cb cb = new();
  agent my_agent;

  initial begin
    my_agent = new("my_agent",null);
    inj_err_cb_type::add(null, cb);
    run_test();
  end
endmodule : test
