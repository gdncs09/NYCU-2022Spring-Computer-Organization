`timescale 1ns / 1ps

module Full_Subtractor(
    In_A, In_B, Borrow_in, Difference, Borrow_out
    );
    input In_A, In_B, Borrow_in;
    output Difference, Borrow_out;
    
    // implement full subtractor circuit, your code starts from here.
    wire diff_0, borr_0, borr_1;
    Half_Subtractor G1(In_A, In_B, diff_0, borr_0);
    Half_Subtractor G2(diff_0, Borrow_in, Difference, borr_1);
    or(Borrow_out, borr_0, borr_1); //gate(output, input1, input2)

    // use half subtractor in this module, fulfill I/O ports connection.
    Half_Subtractor HSUB (
        .In_A(), 
        .In_B(), 
        .Difference(), 
        .Borrow_out()
    );

endmodule
