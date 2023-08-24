/*******************************************************************
 Example 4-9: Transaction from a Producer to a Consumer using put

 To run:   %  irun -uvmhome $UVM_HOME ex4-9_tlm_put.sv
 *******************************************************************/
module test;
  import uvm_pkg::*;
`include "uvm_macros.svh"
`include "simple_packet.sv"

  class producer extends uvm_component;
    uvm_blocking_put_port #(simple_packet) put_port;

    `uvm_component_utils(producer)

    function new(string name = "producer", uvm_component parent);
      super.new(name, parent);
      put_port = new("put_port", this);
    endfunction : new

    virtual task run_phase(uvm_phase phase);
      simple_packet packet;
      packet = simple_packet::type_id::create("packet");
      void'(packet.randomize());
      put_port.put(packet);
    endtask : run_phase
  endclass : producer

  class consumer extends uvm_component;
    uvm_blocking_put_imp #(simple_packet, consumer) put_export;

    `uvm_component_utils(consumer)

    function new(string name = "consumer", uvm_component parent);
      super.new(name, parent);
      put_export = new("put_export", this);
    endfunction : new

    task put(simple_packet packet);
      packet.print();
    endtask : put
  endclass : consumer

  class parent_comp extends uvm_component;
    producer producer_inst;
    consumer consumer_inst;

    `uvm_component_utils(parent_comp)

    function new(string name = "parent_comp", uvm_component parent);
      super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
      producer_inst = producer::type_id::create("producer_inst", null);
      consumer_inst = consumer::type_id::create("consumer_inst", null);
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
      producer_inst.put_port.connect(consumer_inst.put_export);
    endfunction : connect_phase

    function void end_of_elaboration_phase(uvm_phase phase);
      this.print();
    endfunction : end_of_elaboration_phase
  endclass : parent_comp

  parent_comp parent;

  initial begin
    parent = parent_comp::type_id::create("parent", null);
    run_test();
  end
endmodule : test

// OUTPUT:
// # UVM_INFO @ 0: reporter [RNTST] Running test ...
// # --------------------------------
// # Name    Type         Size  Value
// # --------------------------------
// # parent  parent_comp  -     @355
// # --------------------------------
// # -------------------------------------------
// # Name        Type           Size  Value
// # -------------------------------------------
// # packet      simple_packet  -     @410
// #   src_addr  integral       32    'hfd606ce5
// #   dst_addr  integral       32    'h989fcda8
// #   data      da(integral)   16    -
// #     [0]     integral       8     'h78
// #     [1]     integral       8     'h94
// #     [2]     integral       8     'h1e
// #     [3]     integral       8     'h12
// #     [4]     integral       8     'ha0
// #     ...     ...            ...   ...
// #     [11]    integral       8     'hfc
// #     [12]    integral       8     'h8d
// #     [13]    integral       8     'hc0
// #     [14]    integral       8     'hb9
// #     [15]    integral       8     'h64
// # -------------------------------------------
// # UVM_INFO verilog_src/uvm-1.2/src/base/uvm_report_server.svh(847) @ 0: reporter [UVM/REPORT/SERVER]
// # --- UVM Report Summary ---
// #
// # ** Report counts by severity
// # UVM_INFO :    4
// # UVM_WARNING :    0
// # UVM_ERROR :    0
// # UVM_FATAL :    0
// # ** Report counts by id
// # [Questa UVM]     2
// # [RNTST]     1
// # [UVM/RELNOTES]     1
