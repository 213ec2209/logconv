`timescale 1ns/1ps


module cs (
    input  [9:0]m,
    output [9:0]y
);
    // Control signal wires
  wire u_1, u_2, u_3, u_4, u_5, u_6, u_7, u_8;
         wire u_star_1, u_star_2, u_star_3, u_star_4, 
                    u_star_5, u_star_6, u_star_7;
                    assign u_1=m[9];
                    assign u_2=m[8];
                    assign u_3=m[7];
                    assign u_4=m[6];
                    assign u_5=m[5];
                    assign u_6=m[4];
                    assign u_7=m[3];
                    //assign u_8=m[2];
                    
                    
                    assign y[9]=u_star_1;
                    assign y[8]= u_star_2;
                    assign y[7]=u_star_3;
                    assign y[6]=u_star_4;
                    assign y[5]=u_star_5;
                    assign y[4]=u_star_6;
                    assign y[3]=u_star_7;
                   // assign y[2]=u_star_8;
                    assign y[2:0]=m[2:0];

    // Logic control
  wire nand1, or1, not1, and2, or2,nand2 ;
     wire mux1_out, mux2_out, mux3_out;
       assign nand1 = ~(u_2 & u_3)  ;
       assign or1  = u_2 | u_3;
       assign not1 = ~u_2;
       assign nand2  = ~(u_2 & u_4);
        assign or2  = u_2 | u_4;
      
wire c1, c2, c3, c4,c5,c6, c7,s1, s2, s3, s4;
    // MUX outputs
  
           assign mux1_out = u_1 ? c1 : u_2; //mux1
           assign mux2_out = u_1 ? not1 : or2; //mux2
           assign mux3_out = u_1 ? nand1 : or1; //mux2
    //mux2to1 mux1 (.d0(1'b0), .d1(1'b1), .sel(sel1), .y(mux1_out));
   // mux2to1 mux2 (.d0(u_1), .d1(1'b0), .sel(sel2), .y(mux2_out));
   // mux2to1 mux3 (.d0(u_1), .d1(1'b0), .sel(sel3), .y(mux3_out));

    // HA Chain
    
    ha ha1 (.a(u_7), .b(nand2), .sum(u_star_7), .carry(c1));
    fa fa1 (.a(u_6), .b(mux2_out), .cin(mux1_out), .sum(u_star_6), .carry(c2));
    fa fa2 (.a(u_5), .b(mux3_out), .cin(c2), .sum(u_star_5), .carry(c3));
    ha ha2 (.a(u_4), .b(c3),        .sum(u_star_4), .carry(c4));
    ha ha3 (.a(u_3), .b(c4),        .sum(u_star_3), .carry(c5));
    ha ha4 (.a(u_2), .b(c5),        .sum(u_star_2), .carry(c6));
    ha ha5 (.a(u_1), .b(c6),        .sum(u_star_1), .carry(c7));
endmodule