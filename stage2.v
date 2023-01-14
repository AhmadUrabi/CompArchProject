module CSL(input [31:0] in, input [31:0] n, output reg [31:0] out);
reg [31:0] temp;
reg [31:0] temp_old;
integer y;
integer x;
always@(*)
begin
    temp = in;
    temp_old = in;
    for(x = 0; x<n; x++)
    begin
        temp[0] = temp_old[31];
        for(y=0;y<31;y++)
        begin
            temp[y+1] = temp_old[y];
        end
        temp_old = temp;
    end
    out = temp;
end
endmodule

module G(input [31:0] x,y,z, output [31:0] out);
        assign out = (x & y) | (x & z) | (y & z);
endmodule

module Operation_2(a,b,c,d,s,k,out);
input [31:0]a,b,c,d;
input [31:0]k;
input [31:0] s;
output reg [31:0] out;
wire [31:0] G_out;
wire [31:0] temp;
wire [31:0] CSL_out;
reg [31:0] temp_2;
reg [31:0] extra;
integer y;
integer x;
G G_1 (b,c,d,G_out);
assign temp = (a + G_out + k + 32'h5A827999);
CSL cs(temp,s,CSL_out);
always @(CSL_out)
begin
    out = CSL_out;
end
endmodule

module stage2(a,b,c,d,x,out_a, out_b, out_c, out_d);
input [31:0] a,b,c,d;
input [511:0] x;
output [31:0] out_a, out_b, out_c, out_d;
wire [31:0] a_1,a_2,a_3,a_4;
wire [31:0] b_1,b_2,b_3,b_4;
wire [31:0] c_1,c_2,c_3,c_4;
wire [31:0] d_1,d_2,d_3,d_4;

Operation_2 f1(a,b,c,d,3,x[31:0],a_1);
Operation_2 f2(d,a_1,b,c,5,x[159:128],d_1);
Operation_2 f3(c,d_1,a_1,b,9,x[287:256],c_1);
Operation_2 f4(b,c_1,d_1,a_1,13,x[415:384],b_1);
Operation_2 f5(a_1,b_1,c_1,d_1,3,x[63:32],a_2);
Operation_2 f6(d_1,a_2,b_1,c_1,5,x[191:160],d_2);
Operation_2 f7(c_1,d_2,a_2,b_1,9,x[319:288],c_2);
Operation_2 f8(b_1,c_2,d_2,a_2,13,x[447:416],b_2);
Operation_2 f9(a_2,b_2,c_2,d_2,3,x[95:64],a_3);
Operation_2 f10(d_2,a_3,b_2,c_2,5,x[223:192],d_3);
Operation_2 f11(c_2,d_3,a_3,b_2,9,x[351:320],c_3);
Operation_2 f12(b_2,c_3,d_3,a_3,13,x[479:448],b_3);
Operation_2 f13(a_3,b_3,c_3,d_3,3,x[127:96],a_4);
Operation_2 f14(d_3,a_4,b_3,c_3,5,x[255:224],d_4);
Operation_2 f15(c_3,d_4,a_4,b_3,9,x[383:352],c_4);
Operation_2 f16(b_3,c_4,d_4,a_4,13,x[511:480],b_4);


assign out_a = a_4;
assign out_b = b_4;
assign out_c = c_4;
assign out_d = d_4;
endmodule

module stage_2_tb();
reg  [31:0] a,b,c,d;
wire [31:0] res_a, res_b, res_c, res_d;
reg  [511:0] M;
stage2 s2(a,b,c,d,M,res_a,res_b,res_c,res_d);
initial
begin
 a <= 32'h9cf79903;
 b <= 32'h6472bcbb;
 c <= 32'h073a3859;
 d <= 32'h17ea3e30;
 M <= 512'h50535554800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000020;
#10 $display("Input: a = %h, b = %h, c = %h, d = %h", a,b,c,d);
#10 $display("Result: a = %h, b = %h, c = %h, d = %h", res_a,res_b,res_c,res_d);
$finish;
end
endmodule
