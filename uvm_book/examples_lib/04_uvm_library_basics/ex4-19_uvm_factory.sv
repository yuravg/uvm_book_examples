/**********************************************************************
 Example 4-19: Using the UVM Factory

 To run:   %  irun -uvmhome $UVM_HOME ex4-19_uvm_factory.sv

 Notes:  Use the following syntax to override the driver:
 (before creating the driver)

 factory.set_type_override_by_type(driver::get_type(),
 my_project_driver::get_type());
 **********************************************************************/
package my_pkg;
  import uvm_pkg::*;
`include "uvm_macros.svh"

  class driver extends uvm_component;
    `uvm_component_utils(driver)

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    task run_phase(uvm_phase phase);
      `uvm_info("DRIVER", "Driving Transfer", UVM_LOW)
    endtask : run_phase
  endclass : driver

  class my_project_driver extends driver;
    `uvm_component_utils(my_project_driver)

    function new (string name, uvm_component parent);
      super.new(name, parent);
    endfunction : new

    task run_phase(uvm_phase phase);
      `uvm_info("PROJ_DRIVER", "Modifying Transfer", UVM_LOW)
      super.run_phase(phase);
      `uvm_info("PROJ_DRIVER", "Finished Driving Transfer", UVM_LOW)
    endtask : run_phase
  endclass : my_project_driver
endpackage : my_pkg

module test;
  import uvm_pkg::*;
`include "uvm_macros.svh"
  import my_pkg::*;

  driver driver1, driver2;

  initial begin
    uvm_factory factory = uvm_coreservice_t::get().get_factory();

    // Create the first agent using the default driver implementation
    driver1 = driver::type_id::create("driver1", null);
    `uvm_info("INFO", {"driver1.type=", driver1.get_type_name()}, UVM_LOW)
    `uvm_info("INFO", {"driver.name=", driver1.get_name()}, UVM_LOW)

    // Configure BEFORE create
    // Use the factory to override the second driver
    factory.set_type_override_by_type(driver::get_type(), my_project_driver::get_type());

    // Create the second agent
    driver2 = driver::type_id::create("driver2", null);
    `uvm_info("INFO", {"driver2.type=", driver2.get_type_name()}, UVM_LOW)
    `uvm_info("INFO", {"driver2.name=", driver2.get_name()}, UVM_LOW)

    // Run the uvm_phases
    run_test();
  end
endmodule : test

// OUTPUT:
// # UVM_INFO ex4-19_uvm_factory.sv(55) @ 0: reporter [INFO] driver1.type=driver
// # UVM_INFO ex4-19_uvm_factory.sv(56) @ 0: reporter [INFO] driver.name=driver1
// # UVM_INFO ex4-19_uvm_factory.sv(64) @ 0: reporter [INFO] driver2.type=my_project_driver
// # UVM_INFO ex4-19_uvm_factory.sv(65) @ 0: reporter [INFO] driver2.name=driver2
// # UVM_INFO @ 0: reporter [RNTST] Running test ...
// # UVM_INFO ex4-19_uvm_factory.sv(36) @ 0: driver2 [PROJ_DRIVER] Modifying Transfer
// # UVM_INFO ex4-19_uvm_factory.sv(24) @ 0: driver2 [DRIVER] Driving Transfer
// # UVM_INFO ex4-19_uvm_factory.sv(38) @ 0: driver2 [PROJ_DRIVER] Finished Driving Transfer
// # UVM_INFO ex4-19_uvm_factory.sv(24) @ 0: driver1 [DRIVER] Driving Transfer
// # UVM_INFO verilog_src/uvm-1.2/src/base/uvm_report_server.svh(847) @ 0: reporter [UVM/REPORT/SERVER]
// # --- UVM Report Summary ---
// #
// # ** Report counts by severity
// # UVM_INFO :   12
// # UVM_WARNING :    0
// # UVM_ERROR :    0
// # UVM_FATAL :    0
// # ** Report counts by id
// # [DRIVER]     2
// # [INFO]     4
// # [PROJ_DRIVER]     2
// # [Questa UVM]     2
// # [RNTST]     1
// # [UVM/RELNOTES]     1
