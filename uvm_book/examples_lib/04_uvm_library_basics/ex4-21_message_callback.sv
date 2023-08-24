/**********************************************************************
 Example 4-21: Message Callback Usage

 To run:   %  irun -uvm ex4-21_message_callback.sv
 **********************************************************************/
module test;
  import uvm_pkg::*;
`include "uvm_macros.svh"

  class my_catcher extends uvm_report_catcher;
    virtual function action_e catch();
      if (get_severity() == UVM_ERROR && get_id() == "MYID") begin
        set_severity(UVM_INFO);
      end
      return THROW;
    endfunction : catch
  endclass : my_catcher

  my_catcher catcher = new();

  initial begin
    uvm_report_cb::add(null, catcher);
    `uvm_error("MYID", "This one should be demoted to UVM_INFO");
    catcher.callback_mode(0);  // disable the catcher
    `uvm_error("MYID", "This one should NOT be demoted");
  end
endmodule : test

// OUTPUT:
// # UVM_INFO ex4-21_message_callback.sv(23) @ 0: reporter [MYID] This one should be demoted to UVM_INFO
// # UVM_ERROR ex4-21_message_callback.sv(25) @ 0: reporter [MYID] This one should NOT be demoted

// OUTPUT(without disable the catcher):
// # UVM_INFO ex4-21_message_callback.sv(23) @ 0: reporter [MYID] This one should be demoted to UVM_INFO
// # UVM_INFO ex4-21_message_callback.sv(25) @ 0: reporter [MYID] This one should NOT be demoted
