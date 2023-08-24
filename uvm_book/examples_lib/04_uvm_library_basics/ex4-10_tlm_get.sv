/*******************************************************************
 Example : Transaction from a Producer to a Consumer using get

 To run:   %  irun -uvm  ex4-10_tlm_get.sv
 *******************************************************************/
module test;
  import uvm_pkg::*;
`include "uvm_macros.svh"
`include "simple_packet.sv"

  class producer extends uvm_component;
    uvm_blocking_get_imp #(simple_packet, producer) get_export;

    `uvm_component_utils(producer)

    function new(string name, uvm_component parent);
      super.new(name, parent);
      get_export = new("get_export", this);
    endfunction : new

    task get(output simple_packet packet);
      simple_packet packet_temp;
      packet_temp = simple_packet::type_id::create("packet");
      void'(packet_temp.randomize());
      packet = packet_temp;
    endtask : get
  endclass : producer

  class consumer extends uvm_component;
    uvm_blocking_get_port #(simple_packet) get_port;

    `uvm_component_utils(consumer)

    function new(string name, uvm_component parent);
      super.new(name, parent);
      get_port = new("get_port", this);
    endfunction : new

    task run_phase(uvm_phase phase);
      simple_packet packet;
      get_port.get(packet);
      packet.print();
    endtask : run_phase
  endclass : consumer

  class parent_comp extends uvm_component;

    producer producer_inst;
    consumer consumer_inst;

    `uvm_component_utils(parent_comp)

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
      producer_inst = producer::type_id::create("producer_inst", null);
      consumer_inst = consumer::type_id::create("consumer_inst", null);
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
      consumer_inst.get_port.connect(producer_inst.get_export);
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
// #   src_addr  integral       32    'hfd5b9dad
// #   dst_addr  integral       32    'h8410265b
// #   data      da(integral)   16    -
// #     [0]     integral       8     'h7b
// #     [1]     integral       8     'hac
// #     [2]     integral       8     'ha5
// #     [3]     integral       8     'h38
// #     [4]     integral       8     'h6d
// #     ...     ...            ...   ...
// #     [11]    integral       8     'h42
// #     [12]    integral       8     'h19
// #     [13]    integral       8     'h14
// #     [14]    integral       8     'h71
// #     [15]    integral       8     'h16
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
