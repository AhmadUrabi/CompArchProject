module csl(input [31:0] in, input [31:0] n, output reg [31:0] out);
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

module f(input [31:0] x,y,z, output [31:0] out);
        assign out = (x && y) || (~x && z);
endmodule

module function_1(a,b,c,d,s,k,out);
input [31:0]a,b,c,d;
input [31:0]k;
input [31:0] s;
output reg [31:0] out;
wire [31:0] f_out;
wire [31:0] temp;
wire [31:0] csl_out, csl_out_2, csl_out_3;
reg [31:0] temp_2;
integer y;
integer x;
f f_1 (b,c,d,f_out);
assign temp = (a + f_out + k);
csl cs(temp,s,csl_out);
always @(csl_out)
begin
    out = csl_out;
end
endmodule

module stage1(a,b,c,d,x,out_a, out_b, out_c, out_d,clk);
input [31:0] a,b,c,d;
input [511:0] x;
input clk;
output [31:0] out_a, out_b, out_c, out_d;
wire [31:0] a_1,a_2,a_3,a_4;
wire [31:0] b_1,b_2,b_3,b_4;
wire [31:0] c_1,c_2,c_3,c_4;
wire [31:0] d_1,d_2,d_3,d_4;

function_1 f1(a,b,c,d,3,x[31:0],a_1);
function_1 f2(d,a_1,b,c,7,x[63:32],d_1);
function_1 f3(c,d_1,a_1,b,11,x[95:64],c_1);
function_1 f4(b,c_1,d_1,a_1,19,x[127:96],b_1);
function_1 f5(a_1,b_1,c_1,d_1,3,x[159:128],a_2);
function_1 f6(d_1,a_2,b_1,c_1,7,x[191:160],d_2);
function_1 f7(c_1,d_2,a_2,b_1,11,x[223:192],c_2);
function_1 f8(b_1,c_2,d_2,a_2,19,x[255:224],b_2);
function_1 f9(a_2,b_2,c_2,d_2,3,x[287:256],a_3);
function_1 f10(d_2,a_3,b_2,c_2,7,x[319:288],d_3);
function_1 f11(c_2,d_3,a_3,b_2,11,x[351:320],c_3);
function_1 f12(b_2,c_3,d_3,a_3,19,x[383:352],b_3);
function_1 f13(a_3,b_3,c_3,d_3,3,x[415:384],a_4);
function_1 f14(d_3,a_4,b_3,c_3,7,x[447:416],d_4);
function_1 f15(c_3,d_4,a_4,b_3,11,x[479:448],c_4);
function_1 f16(b_3,c_4,d_4,a_4,19,x[511:480],b_4);

assign out_a = a_4;
assign out_b = b_4;
assign out_c = c_4;
assign out_d = d_4;
endmodule

module stage_1_tb();
reg [31:0] a,b,c,d;
wire [31:0] res_a, res_b, res_c, res_d;
reg [15:0] x[15:0];
reg [511:0] M;
reg clk;
stage1 s1(a,b,c,d,M,res_a,res_b,res_c,res_d,clk);
initial
begin
#1 a <= 32'h67453201;
#1 b <= 32'hefcdab89;
#1 c <= 32'h98badcfe;
#1 d <= 32'h10325476;
#1 M <= 512'h41686D61642055726162698000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000059;
#1 $display("Before Stage 1: a = %h, b = %h, c = %h, d = %h", a,b,c,d);
#1 $display("After Stage 1: a = %h, b = %h, c = %h, d = %h", res_a,res_b,res_c,res_d);
$finish;
end
endmodule
