/******************************************************************************
 FILE : apb_master_if.sv
 ******************************************************************************/
//   Copyright 1999-2010 Cadence Design Systems, Inc.
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//----------------------------------------------------------------------

interface apb_master_if (input pclock,
                         input preset);

  parameter         PADDR_WIDTH  = 32;
  parameter         PWDATA_WIDTH = 8;
  parameter         PRDATA_WIDTH = PWDATA_WIDTH;

  // Actual Signals
  logic [PADDR_WIDTH-1:0]  paddr;
  logic                    prwd;
  logic [PWDATA_WIDTH-1:0] pwdata;
  logic                    penable;
  logic                    pready;
  logic [15:0]             psel;
  logic [PRDATA_WIDTH-1:0] prdata;
  wire logic               pslverr;

  // UART Interrupt signal
  logic       ua_int;

  logic [31:0] gp_int;

  // Control flags
  bit                has_checks = 1;
  bit                has_coverage = 1;

  // Coverage and assertions to be implemented here.

  /* NEEDS TO BE UPDATED TO CONCURRENT ASSERTIONS
   always @(posedge pclock)
   begin

   // PADDR must not be X or Z when PSEL is asserted
   assertPAddrUnknown:assert property (
   disable iff(!has_checks || !preset)
   (psel == 0 or !$isunknown(paddr)))
   else
                    $error("ERR_APB001_PADDR_XZ\n PADDR went to X or Z \
                            when PSEL is asserted");

   // PRWD must not be X or Z when PSEL is asserted
   assertPRwdUnknown:assert property (
   disable iff(!has_checks || !preset)
   (psel == 0 or !$isunknown(prwd)))
   else
                    $error("ERR_APB002_PRWD_XZ\n PRWD went to X or Z \
                            when PSEL is asserted");

   // PWDATA must not be X or Z during a data transfer
   assertPWdataUnknown:assert property (
   disable iff(!has_checks || !preset)
   (psel == 0 or prwd == 0 or !$isunknown(pwdata)))
   else
                     $error("ERR_APB003_PWDATA_XZ\n PWDATA went to X or Z \
                             during a write transfer");

   // PENABLE must not be X or Z
   assertPEnableUnknown:assert property (
   disable iff(!has_checks || !preset)
   (!$isunknown(penable)))
   else
   $error("ERR_APB004_PENABLE_XZ\n PENABLE went to X or Z");

   // PSEL must not be X or Z
   assertPSelUnknown:assert property (
   disable iff(!has_checks || !preset)
   (!$isunknown(psel)))
   else
   $error("ERR_APB005_PSEL_XZ\n PSEL went to X or Z");

end // always @(posedge pclock)
   */

endinterface : apb_master_if
