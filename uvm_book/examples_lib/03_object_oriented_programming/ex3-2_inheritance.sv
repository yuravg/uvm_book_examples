/****************************************************************
 Example 3-2: Generalization and Inheritance

 To run:   %  irun ex3-2_inheritance.sv
 ****************************************************************/

module top;

  typedef enum {AUTOMATIC, MANUAL} trans_type;

  virtual class car;  // note that car is a virtual class
    local trans_type m_trans;
    local bit m_is_locked[];
    local bit m_num_doors;

    task drive_forward();
    endtask : drive_forward

    task open_door(int door);
    endtask : open_door
  endclass : car

  virtual class sports_coupe extends car;
    local bit m_is_convertible;

    task drive_forward();
    endtask : drive_forward
  endclass : sports_coupe

  class KCMotors_H10 extends sports_coupe;
    task drive_forward();
      $display("%m() is executing");
    endtask : drive_forward
  endclass : KCMotors_H10

  KCMotors_H10 my_car;

  initial begin
    my_car = new();
    my_car.drive_forward();
  end
endmodule : top

// OUTPUT:
// # top.KCMotors_H10.drive_forward() is executing
