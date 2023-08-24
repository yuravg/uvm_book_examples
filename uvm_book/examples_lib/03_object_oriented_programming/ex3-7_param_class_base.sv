/*********************************************************************
 Example 3-7: Parameterized Class Using Base Class for Static Field

 To run:   %  irun ex3-7_param_class_base.sv
 *********************************************************************/

module top;

  class stack_base;
    static int stacks;
    local int id;

    function new();
      stacks++;
      id = stacks;
    endfunction : new

    function int get_id();
      return (id);
    endfunction : get_id
  endclass : stack_base

  class stack #(type T = int) extends stack_base;
    local T items[$];

    task push(T a);
      items.push_front(a);
      $display("executed push(%s)", $typename(T));
    endtask : push

    task pop(ref T a);
      a = items.pop_back();
      $display("executed pop(%s)", $typename(T));
    endtask : pop
  endclass : stack

  stack int_stack, int_stack2; // default: stack of ints
  stack #(bit[9:0]) bit_stack; // stack of 10-bit vectors
  stack #(real) real_stack;    // stack of reals

  int int_value;
  int int_value2;
  bit[9:0] bit_value;
  real real_value;

  initial begin
    int_stack=new();  // id = 1
    bit_stack=new();  // id = 2
    real_stack=new(); // id = 3

    int_stack.push(400);
    bit_stack.push('h200);
    real_stack.push(40.5);
    int_stack.pop(int_value);
    bit_stack.pop(bit_value);
    real_stack.pop(real_value);

    int_stack2=new();  // id = 4
    int_stack2.push(888);
    int_stack2.pop(int_value2);

    $display("int:%0d; int2:%0d; bit[9:0]:0x%0h; real:%g",
             int_value, int_value2, bit_value, real_value);

    $display("int_stack.id=%0d; int_stack2.id=%0d; bit_stack.id=%0d; real_stack.id=%0d",
             int_stack.get_id(), int_stack2.get_id(), bit_stack.get_id(), real_stack.get_id());
  end

endmodule : top

// OUTPUT:
// # executed push(int)
// # executed push(bit[9:0])
// # executed push(real)
// # executed pop(int)
// # executed pop(bit[9:0])
// # executed pop(real)
// # executed push(int)
// # executed pop(int)
// # int:400; int2:888; bit[9:0]:0x200; real:40.5
// # int_stack.id=1; int_stack2.id=4; bit_stack.id=2; real_stack.id=3
