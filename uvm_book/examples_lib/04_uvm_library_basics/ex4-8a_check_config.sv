/**********************************************************************
 Example 4-8a: Configuration Mechanism - Checking using exists()

 To run:   %  irun -uvm ex4-8a_check_config.sv
 OR:       %  irun -uvmhome $UVM_HOME ex4-8a_check_config.sv
 **********************************************************************/
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
    master_comp master[];  // dynamic array of masters
    slave_comp  slave[];   // dynamic array of slaves
    int num_masters = 1;
    int num_slaves = 1;
    string if_name = "bus_uvc";

    `uvm_component_utils_begin(interface_comp)
      `uvm_field_string(if_name, UVM_DEFAULT)
      `uvm_field_int(num_masters, UVM_DEFAULT)
      `uvm_field_int(num_slaves, UVM_DEFAULT)
    `uvm_component_utils_end

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
      if (!uvm_config_db #(int)::exists(this, "", "num_masters", 1))
        `uvm_error("NOTFOUND", "num_masters must be provided")
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

module test2;
  import uvm_pkg::*;
`include "uvm_macros.svh"
  import my_pkg::*;
  interface_comp my_uvc;

  initial begin
    // Configure BEFORE create
    uvm_config_string::set(null, "my_uvc", "if_name", "APB_UVC");
    uvm_config_int::set(null, "my_uvc", "num_slaves", 2);
    // Create components
    my_uvc = interface_comp::type_id::create("my_uvc", null);
    // Start UVM Phases
    run_test();
  end

endmodule : test2

// OUTPUT:
// # UVM_INFO @ 0: reporter [RNTST] Running test ...
// # UVM_INFO verilog_src/uvm-1.2/src/base/uvm_spell_chkr.svh(123) @ 0: reporter [UVM/CONFIGDB/SPELLCHK] num_masters not located, did you mean num_slaves
// # UVM_ERROR ex4-8a_check_config.sv(55) @ 0: my_uvc [NOTFOUND] num_masters must be provided
// # UVM_FATAL @ 0: reporter [BUILDERR] stopping due to build errors
// # UVM_INFO verilog_src/uvm-1.2/src/base/uvm_report_server.svh(847) @ 0: reporter [UVM/REPORT/SERVER]
// # --- UVM Report Summary ---
// #
// # ** Report counts by severity
// # UVM_INFO :    5
// # UVM_WARNING :    0
// # UVM_ERROR :    1
// # UVM_FATAL :    1
// # ** Report counts by id
// # [BUILDERR]     1
// # [NOTFOUND]     1
// # [Questa UVM]     2
// # [RNTST]     1
// # [UVM/CONFIGDB/SPELLCHK]     1
// # [UVM/RELNOTES]     1
