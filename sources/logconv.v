`timescale 1ns/1ps
module logconv (
    input  wire [15:0] fp16_in,       // IEEE 754 half-precision
    output wire [15:0] log_out_q5_10  // Signed Q5.10 fixed-point log2(x)
);
    // Unpack fields
     //wire [9:0] mantc;
    assign sign_in = fp16_in[15];
    wire [4:0] exp = fp16_in[14:10];
    wire [9:0] mant = fp16_in[9:0];
      wire [15:0] frac_log ;
    // Special cases
    wire is_zero = (exp == 5'd0) && (mant == 10'd0);
  //  wire is_neg  = (sign_in == 1'b1);
    wire signed [15:0] log_val;
    // Output register
   reg [15:0] log_result;
    assign log_out_q5_10 = log_result;
//assign log_out_q5_10 = log_val;
wire co;


//assign mantc=mant; //mitchel  approx: log2(1 + f)=f
    // Normalize mantissa to Q0.10 format (f = mant / 1024)
    wire [15:0] f_q10 = {6'd0, mant};  // Q0.10
    

 assign frac_log = f_q10;     // Q0.10 approx log2(1+f)
 

    // Integer part: exp - bias = exp - 15
    wire signed [5:0] int_part = $signed({1'b0, exp}) - 6'sd15;
    wire signed [15:0] int_part_q10 = int_part <<< 10; // Q5.10

    // Final log value = int_part + frac_log
   assign log_val = int_part_q10 + $signed(frac_log);

    always @(*) begin
        if (is_zero) begin
            log_result = 16'sh8000;  // -INF in Q5.10
        end else begin
            log_result = log_val;
        end
    end

endmodule