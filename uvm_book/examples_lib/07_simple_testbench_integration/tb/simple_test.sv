/****************************************************************
 File:  simple_test.sv - Creates the testbench and prints it
 NO STIMULUS IS GENERATED
 ****************************************************************/

class simple_test extends uvm_test;

  uart_ctrl_tb my_tb;

  `uvm_component_utils(simple_test)

  function new(input string name, input uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    my_tb = uart_ctrl_tb::type_id::create("my_tb", this);
  endfunction : build_phase

  virtual task run_phase(uvm_phase phase);
    my_tb.print();
  endtask : run_phase

endclass : simple_test
