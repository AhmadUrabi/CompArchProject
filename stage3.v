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

module H(input [31:0] x,y,z, output [31:0] out);
        assign out = (x ^ y ^ z);
endmodule

module Operation_3(a,b,c,d,s,k,out);
input [31:0] a,b,c,d;
input [31:0] k;
input [31:0] s;
output reg [31:0] out;
wire [31:0] H_out;
wire [31:0] temp;
wire [31:0] CSL_out;
integer y;
integer x;
H H_1 (b,c,d,H_out);
assign temp = (a + H_out + k + 32'h6ED9EBA1);
CSL cs(temp,s,CSL_out);
always @(CSL_out)
begin
    out = CSL_out;
end
endmodule

module stage3(a,b,c,d,x,out_a, out_b, out_c, out_d);
input [31:0] a,b,c,d;
input [511:0] x;
output [31:0] out_a, out_b, out_c, out_d;
wire [31:0] a_1,a_2,a_3,a_4;
wire [31:0] b_1,b_2,b_3,b_4;
wire [31:0] c_1,c_2,c_3,c_4;
wire [31:0] d_1,d_2,d_3,d_4;

Operation_3 f1(a,b,c,d,3,x[31:0],a_1);
Operation_3 f2(d,a_1,b,c,9,x[287:256],d_1);
Operation_3 f3(c,d_1,a_1,b,11,x[159:128],c_1);
Operation_3 f4(b,c_1,d_1,a_1,15,x[415:384],b_1);
Operation_3 f5(a_1,b_1,c_1,d_1,3,x[95:64],a_2);
Operation_3 f6(d_1,a_2,b_1,c_1,9,x[351:320],d_2);
Operation_3 f7(c_1,d_2,a_2,b_1,11,x[223:192],c_2);
Operation_3 f8(b_1,c_2,d_2,a_2,15,x[479:448],b_2);
Operation_3 f9(a_2,b_2,c_2,d_2,3,x[63:32],a_3);
Operation_3 f10(d_2,a_3,b_2,c_2,9,x[319:288],d_3);
Operation_3 f11(c_2,d_3,a_3,b_2,11,x[191:160],c_3);
Operation_3 f12(b_2,c_3,d_3,a_3,15,x[447:416],b_3);
Operation_3 f13(a_3,b_3,c_3,d_3,3,x[127:96],a_4);
Operation_3 f14(d_3,a_4,b_3,c_3,9,x[383:352],d_4);
Operation_3 f15(c_3,d_4,a_4,b_3,11,x[255:224],c_4);
Operation_3 f16(b_3,c_4,d_4,a_4,15,x[511:480],b_4);

assign out_a = a_4;
assign out_b = b_4;
assign out_c = c_4;
assign out_d = d_4;
endmodule

module stage_2_tb();
reg  [31:0] a,b,c,d;
wire [31:0] res_a, res_b, res_c, res_d;
reg  [511:0] M;
stage3 s3(a,b,c,d,M,res_a,res_b,res_c,res_d);
initial
begin
 a <= 32'h67452301;
 b <= 32'hefcdab89;
 c <= 32'h98badcfe;
 d <= 32'h10325476;
 M <= 512'b01000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001;
#10 $display("Input: a = %h, b = %h, c = %h, d = %h", a,b,c,d);
#10 $display("Result: a = %h, b = %h, c = %h, d = %h", res_a,res_b,res_c,res_d);
$finish;
end
endmodule
