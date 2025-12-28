
module bk_adder16bit (
    input  [15:0] A,
    input  [15:0] B,
    output [15:0] SUM
    // output       COUT
);
    wire [15:0] G, P;
    wire [15:0] C;

    assign G = A & B;
    assign P = A ^ B;

    // Stage 0
    wire [15:0] g0 = G, p0 = P;

    // Stage 1
    wire [15:0] g1, p1;
    assign g1[1]  = g0[1] | (p0[1] & g0[0]);
    assign p1[1]  = p0[1] & p0[0];
    assign g1[3]  = g0[3] | (p0[3] & g0[2]);
    assign p1[3]  = p0[3] & p0[2];
    assign g1[5]  = g0[5] | (p0[5] & g0[4]);
    assign p1[5]  = p0[5] & p0[4];
    assign g1[7]  = g0[7] | (p0[7] & g0[6]);
    assign p1[7]  = p0[7] & p0[6];
    assign g1[9]  = g0[9] | (p0[9] & g0[8]);
    assign p1[9]  = p0[9] & p0[8];
    assign g1[11] = g0[11] | (p0[11] & g0[10]);
    assign p1[11] = p0[11] & p0[10];
    assign g1[13] = g0[13] | (p0[13] & g0[12]);
    assign p1[13] = p0[13] & p0[12];
    assign g1[15] = g0[15] | (p0[15] & g0[14]);
    assign p1[15] = p0[15] & p0[14];

    // Stage 2
    wire [15:0] g2, p2;
    assign g2[3]  = g1[3]  | (p1[3]  & g1[1]);
    assign p2[3]  = p1[3]  & p1[1];
    assign g2[7]  = g1[7]  | (p1[7]  & g1[5]);
    assign p2[7]  = p1[7]  & p1[5];
    assign g2[11] = g1[11] | (p1[11] & g1[9]);
    assign p2[11] = p1[11] & p1[9];
    assign g2[15] = g1[15] | (p1[15] & g1[13]);
    assign p2[15] = p1[15] & p1[13];

    // Stage 3
    wire [15:0] g3, p3;
    assign g3[7]  = g2[7]  | (p2[7]  & g2[3]);
    assign p3[7]  = p2[7]  & p2[3];
    assign g3[15] = g2[15] | (p2[15] & g2[11]);
    assign p3[15] = p2[15] & p2[11];

    // Stage 4
    wire [15:0] g4;
    assign g4[15] = g3[15] | (p3[15] & g3[7]);

    // Carry computation
    assign C[0]  = 1'b0;
    assign C[1]  = g0[0];
    assign C[2]  = g1[1];
    assign C[3]  = g0[2] | (p0[2] & g1[1]);
    assign C[4]  = g2[3];
    assign C[5]  = g0[4] | (p0[4] & g2[3]);
    assign C[6]  = g1[5] | (p0[5] & g2[3]);
    assign C[7]  = g0[6] | (p0[6] & g1[5]) | (p0[6] & p0[5] & g2[3]);
    assign C[8]  = g3[7];
    assign C[9]  = g0[8] | (p0[8] & g3[7]);
    assign C[10] = g1[9] | (p0[9] & g3[7]);
    assign C[11] = g0[10] | (p0[10] & g1[9]) | (p0[10] & p0[9] & g3[7]);
    assign C[12] = g2[11] | (p0[11] & p0[10] & p0[9] & g3[7]);
    assign C[13] = g0[12] | (p0[12] & C[12]);
    assign C[14] = g1[13] | (p0[13] & C[12]);
    assign C[15] = g0[14] | (p0[14] & C[14]);
    // assign COUT = g4[15];

    assign SUM = P ^ C;
endmodule