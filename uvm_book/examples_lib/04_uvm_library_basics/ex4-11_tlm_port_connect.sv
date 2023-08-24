/*******************************************************************
 Example 4-11: Connecting a Child Port to a Parent Port

 To run:   %  irun -uvm ex4-11_tlm_port_connect.sv
 OR        %  irun -uvmhome $UVM_HOME ex4-11_tlm_port_connect.sv
 *******************************************************************/
module test;
  import uvm_pkg::*;
`include "uvm_macros.svh"
`include "simple_packet.sv"

  typedef class producer;

  class parent_producer extends uvm_component;
    uvm_blocking_put_port #(simple_packet) put_port;

    producer child_producer_inst;

    `uvm_component_utils(parent_producer)

    function new(string name, uvm_component parent);
      super.new(name, parent);
      put_port = new("put_port", this);
      child_producer_inst = new("child_producer_inst", this);
    endfunction : new

    function void connect();
      super.connect();
      child_producer_inst.put_port.connect(put_port);
    endfunction : connect
  endclass : parent_producer

  class producer extends uvm_component;
    uvm_blocking_put_port #(simple_packet) put_port;

    `uvm_component_utils_begin(producer)
    `uvm_component_utils_end

    function new(string name, uvm_component parent);
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

    function new(string name, uvm_component parent);
      super.new(name, parent);
      put_export = new("put_export", this);
    endfunction : new

    task put(simple_packet packet);
      packet.print();
    endtask : put
  endclass : consumer

  class parent_comp extends uvm_component;
    parent_producer producer_inst;
    consumer consumer_inst;

    `uvm_component_utils(parent_comp)

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
      producer_inst = parent_producer::type_id::create("producer_inst", null);
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
// # packet      simple_packet  -     @427
// #   src_addr  integral       32    'h64b69519
// #   dst_addr  integral       32    'ha90970ab
// #   data      da(integral)   12    -
// #     [0]     integral       8     'h9c
// #     [1]     integral       8     'h62
// #     [2]     integral       8     'h6
// #     [3]     integral       8     'h5b
// #     [4]     integral       8     'hcc
// #     ...     ...            ...   ...
// #     [7]     integral       8     'h64
// #     [8]     integral       8     'h7d
// #     [9]     integral       8     'h97
// #     [10]    integral       8     'h30
// #     [11]    integral       8     'h10
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
