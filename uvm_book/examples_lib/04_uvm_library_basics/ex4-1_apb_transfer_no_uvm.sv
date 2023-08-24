/****************************************************************
 Example 4-1: Non-UVM Class Definition

 To run:   %  irun ex4-1_apb_transfer_no_uvm.sv
 ****************************************************************/
//------------------------------------------------------------------------------
// CLASS: apb_transfer
//------------------------------------------------------------------------------
typedef enum bit {APB_READ, APB_WRITE} apb_direction_enum;

class apb_transfer;
  rand bit [31:0]           addr;
  rand bit [31:0]           data;
  rand apb_direction_enum   direction;
  // Control field - does not translate into signal data
  rand int unsigned         transmit_delay;

  function void print();
    $display("%s transfer: addr=%h data=%h", direction.name(), addr, data);
  endfunction : print
endclass : apb_transfer

module test;
  apb_transfer transfer;
  initial begin
    transfer = new();
    repeat (3) begin
      void'(transfer.randomize());
      transfer.print();
    end
  end
endmodule : test

// OUTPUT:
// # APB_WRITE transfer: addr=6288fc4c data=a7764686
// # APB_WRITE transfer: addr=7659aa6d data=ee27cf6f
// # APB_READ transfer: addr=c0ebd713 data=0c2e81fe
