
//instruction memory 
module InstMemDriver(IRin,IRRdy,PC,bit,bitRdy,Upload,reset);

input bitRdy;
input bit;
input reset;
input Upload;

output reg [9:0] PC;
output reg [31:0] IRin;
output reg IRRdy;
reg [5:0] counterIR;

always@(posedge bitRdy , posedge reset)
begin
if(reset)
begin
PC<=0;
counterIR<=0;
IRRdy<=1'bz;
IRin <=32'bz;
end
else if(Upload)
begin
if(counterIR == 5'b11111)
begin
IRin[counterIR] = bit;
IRRdy = 1;
counterIR <= 0;
PC <= PC + 1;
end
else 
begin
IRin[counterIR] = bit;
IRRdy<=0;
counterIR <= counterIR + 1;
end
end
end

endmodule

module InstMem(IRout,PC[9:0],IRin,Upload,IRRdy,clk,reset);

input [31:0] IRin;
input Upload;
input IRRdy;

input [9:0] PC;
output reg [31:0] IRout;
input clk,reset;

reg [31:0] Mem [0:1023];

//initial
//$readmemb("InstMem.txt",Mem);
always@(posedge IRRdy) if(Upload)
begin
Mem[PC]<=IRin;
end
always@(posedge reset) if(!Upload) IRout<=32'bx; 
always@(posedge clk) if(!reset&&!Upload) IRout<= Mem[PC];

endmodule



module DataMem(Read,MemRead,Write,MemWrite,address[9:0],clk,reset);

input clk,reset,MemWrite,MemRead;
input [31:0] Write;
input [9:0] address;
output reg [31:0] Read;

reg[31:0] Mem[0:1023];

always@(posedge clk)
begin
if(!reset)
begin
if(MemRead)
Read<=Mem[address];
else if(MemWrite)
Mem[address]<=Write;
else
Mem[address]<=Mem[address];

if(!MemRead)
Read <= 32'bx;
end
end

endmodule




module Adder(out,in1,in2);

input[31:0] in1,in2;
output reg [31:0] out;

always@(in1 or in2)
begin
out <= in1 + in2;
end

endmodule


module Control_Unit(delaySel,RegDst,RegWrite,MemRead,MemWrite,MemtoReg,AluSrc,AluOp,Beq,Bne,Jump,Jal,Lui,op,reset);
output reg[1:0] RegDst,delaySel;
output reg AluSrc,RegWrite,MemRead,MemWrite,MemtoReg,Beq,Jump,Bne,Jal,Lui;
input [5:0] op;
output reg[2:0]AluOp;
input reset;


always @(op, reset)
begin
if(reset)
begin
RegDst<=0;RegWrite<=0;delaySel<=2'b00;AluSrc<=0;AluOp<=7;MemWrite<=0;MemRead<=0;MemtoReg<=0;Beq<=0;Bne<=0;Jump<=0;Jal<=0;Lui<=0;
end
else if(!reset)
begin
case(op)
6'b000000:
	begin
	 RegDst<=1;RegWrite<=1;delaySel<=2'b00;AluSrc<=0;AluOp<=2;MemWrite<=0;MemRead<=0;MemtoReg<=0;Beq<=0;Bne<=0;Jump<=0;Jal<=0;Lui<=0; 
	end
6'b001000:
	begin
	RegDst<=0;RegWrite<=1;delaySel<=2'b00;AluSrc<=1;AluOp<=0;MemWrite<=0;MemRead<=0;MemtoReg<=0;Beq<=0;Bne<=0;Jump<=0;Jal<=0;Lui<=0;
	end
6'b001100:
	begin
	RegDst<=0;RegWrite<=1;delaySel<=2'b00;AluSrc<=1;AluOp<=3;MemWrite<=0;MemRead<=0;MemtoReg<=0;Beq<=0;Bne<=0;Jump<=0;Jal<=0;Lui<=0;
	end
6'b000100:
	begin
	RegDst<=0;RegWrite<=0;delaySel<=2'b00;AluSrc<=0;AluOp<=1;MemWrite<=0;MemRead<=0;MemtoReg<=0;Beq<=1;Bne<=0;Jump<=0;Jal<=0;Lui<=0;
	end
6'b000101:
	begin
	RegDst<=0;RegWrite<=0;delaySel<=2'b00;AluSrc<=0;AluOp<=1;MemWrite<=0;MemRead<=0;MemtoReg<=0;Beq<=0;Bne<=1;Jump<=0;Jal<=0;Lui<=0;
	end
6'b000010:
	begin
	RegDst<=0;RegWrite<=0;delaySel<=2'b00;AluSrc<=0;AluOp<=7;MemWrite<=0;MemRead<=0;MemtoReg<=0;Beq<=0;Bne<=0;Jump<=1;Jal<=0;Lui<=0;
	end
6'b000011:
	begin
	RegDst<=2;RegWrite<=1;delaySel<=2'b00;AluSrc<=0;AluOp<=7;MemWrite<=0;MemRead<=0;MemtoReg<=0;Beq<=0;Bne<=0;Jump<=1;Jal<=1;Lui<=0;
	end
6'b001111:
	begin
	RegDst<=0;RegWrite<=1;delaySel<=2'b00;AluSrc<=0;AluOp<=7;MemWrite<=0;MemRead<=0;MemtoReg<=0;Beq<=0;Bne<=0;Jump<=0;Jal<=0;Lui<=1;
	end
6'b001101:
	begin
	RegDst<=0;RegWrite<=1;delaySel<=2'b00;AluSrc<=1;AluOp<=4;MemWrite<=0;MemRead<=0;MemtoReg<=0;Beq<=0;Bne<=0;Jump<=0;Jal<=0;Lui<=0;
	end
6'b001010:
	begin
	RegDst<=0;RegWrite<=1;delaySel<=2'b00;AluSrc<=1;AluOp<=5;MemWrite<=0;MemRead<=0;MemtoReg<=0;Beq<=0;Bne<=0;Jump<=0;Jal<=0;Lui<=0;
	end
6'b101011:
	begin
	RegDst<=0;RegWrite<=0;delaySel<=2'b10;AluSrc<=1;AluOp<=0;MemWrite<=1;MemRead<=0;MemtoReg<=0;Beq<=0;Bne<=0;Jump<=0;Jal<=0;Lui<=0;
	end
6'b100011:
	begin
	RegDst<=0;RegWrite<=1;delaySel<=2'b01;AluSrc<=1;AluOp<=0;MemWrite<=0;MemRead<=1;MemtoReg<=1;Beq<=0;Bne<=0;Jump<=0;Jal<=0;Lui<=0;
	end
6'b001110:
	begin
	RegDst<=0;RegWrite<=1;delaySel<=2'b00;AluSrc<=1;AluOp<=6;MemWrite<=0;MemRead<=0;MemtoReg<=0;Beq<=0;Bne<=0;Jump<=0;Jal<=0;Lui<=0;
	end
default:
	begin
	RegDst<=0;RegWrite<=0;delaySel<=2'b00;AluSrc<=0;AluOp<=7;MemWrite<=0;MemRead<=0;MemtoReg<=0;Beq<=0;Bne<=0;Jump<=0;Jal<=0;Lui<=0;
	end
endcase
end
end
endmodule



module Mips_Alu(AluOut,AluCtl,A,B,ZERO,reset);
input[3:0]AluCtl;
input signed [31:0]A,B;
input reset;
output reg[31:0]AluOut;
output reg ZERO;

always @(AluCtl , A , B , reset)
begin
if(!reset)
case (AluCtl)
0:AluOut<=A+B;     //0 represents add
1:AluOut<=A&B;     //1 represents and
2:AluOut<=A-B;     //2 represents sub 
3:AluOut<=A|B;     //3 represents or
4:AluOut<=B<<A;    //4 represents sll
5:AluOut<=B>>A;    //5 represents srl
6:AluOut<=(A<B); //6 represents slt
7:AluOut<=A^B;     //7 represents xor
8:AluOut<=~(A|B);   //8 represents nor
default:AluOut<=32'bz;
endcase
else if(reset)
AluOut<=32'bz;
end

always@(AluOut)
if(AluOut == 0)
ZERO <= 1;
else
ZERO <= 0;

endmodule



module Alu_Control(AluCtl,funct,AluOp,jr,shift,reset);
output reg[3:0] AluCtl;
input [5:0] funct;
input [2:0] AluOp;
output reg jr;
output reg shift;
input reset;

always @(AluOp,funct,reset)
begin
if (reset)
begin
AluCtl<=9;
jr<=0;
shift<=0;
end
else if(!reset)
begin
if(AluOp==0)
begin
AluCtl<=0;
jr<=0;
shift<=0;
end
else if(AluOp==1)
begin
AluCtl<=2;
jr<=0;
shift<=0;
end
else if(AluOp==2)
begin
if(funct==32)//add
begin
AluCtl<=0;
jr<=0;
shift<=0;
end
else if(funct==34)//sub
begin
AluCtl<=2;
jr<=0;
shift<=0;
end
else if(funct==36)//and
begin
AluCtl<=1;
jr<=0;
shift<=0;
end
else if(funct==39)//nor
begin
AluCtl<=8;
jr<=0;
shift<=0;
end
else if(funct==37)//or
begin
AluCtl<=3;
jr<=0;
shift<=0;
end
else if(funct==0)//sll
begin
shift<=1;
AluCtl<=4;
jr<=0;
end
else if(funct==42)//slt
begin
AluCtl<=6;
jr<=0;
shift<=0;
end
else if(funct==2)//srl
begin
shift<=1;
AluCtl<=5;
jr<=0;
end
else if(funct==38)//xor
begin
AluCtl<=7;
jr<=0;
shift<=0;
end
else if(funct==8)//jr
begin 
AluCtl<=9;
shift<=0;
jr<=1;
end
else
begin
AluCtl<=9;
jr<=0;
shift<=0;
end
end
else if(AluOp==3)//andi
begin
AluCtl<=1;
jr<=0;
shift<=0;
end
else if(AluOp==4)//ori
begin
AluCtl<=3;
jr<=0;
shift<=0;
end
else if(AluOp==5)//slti
begin
AluCtl<=6;
jr<=0;
shift<=0;
end
else if(AluOp==6)//xori
begin
AluCtl<=7;
jr<=0;
shift<=0;
end
else
begin
AluCtl<=9;
jr<=0;
shift<=0;
end
end
end

endmodule





module RegFile(read1,read2,write,writedata,regwrite,data1,data2,clk,reset);
input clk,reset;
input[4:0]read1,read2,write;
input[31:0]writedata;
input regwrite;
output wire [31:0] data1,data2;

reg [31:0] rf[0:31];


assign data1 = rf[read1];
assign data2 = rf[read2];

always @(posedge clk)
begin
if(!reset)
if(regwrite)
rf[write]<=writedata;
rf[0] <= 0;
end

endmodule




module SignExtend(ain,bout);
input [15:0]ain;
output reg [31:0]bout;
always @(ain)
begin
case(ain[15])
1: bout<={{16{1'b1}},ain};
0: bout<={{16{1'b0}},ain};
default:bout<=32'bx;
endcase
end 
endmodule




module SignExtend5(ain,bout);
input [4:0]ain;
output reg [31:0]bout;
wire [26:0] c,d;
assign c={27 {1'b0}};
assign d={27 {1'b1}};
always @(ain)
begin
if(ain[4]==1)
bout<={d,ain};
else if(ain[4]==0)
bout<={c,ain};
end 
endmodule




module shiftleft32 (regout,regin,shamt);
input [31:0] regin;
output reg [31:0] regout;
input [4:0]shamt;
always @(regin or shamt)
regout <= regin<<shamt;
endmodule


module shiftleft28 (regout,regin);
input [25:0] regin;
output reg [27:0] regout;
always @(regin)
regout <= regin<<2;
endmodule



module Mux5Bit(out,a,b,c,sel);

output [4:0] out;
input [4:0] a,b,c;
input [1:0] sel;

wire [4:0] in [2:0];
assign in[0] = a;
assign in[1] = b;
assign in[2] = c;

assign out = in[sel];

endmodule

module MuxClk(out,in,sel);
output out;
input [0:1] in;
input sel;

assign out = in[sel];
endmodule

module clkBuffer (clk_2Dm,clk_2Rf,clk_1,delaySel);
output clk_2Dm,clk_2Rf;
input [1:0] delaySel;
input clk_1;
wire [0:1] clkArr;
assign clkArr[0] = clk_1;
//BUFG b2 (clkArr[1],clk_1);
buf #1 b2 (clkArr[1],clk_1);
MuxClk x(clk_2Rf,clkArr,delaySel[0]);
MuxClk y(clk_2Dm,clkArr,delaySel[1]);
endmodule

module Mux(out,a,b,sel);
output [31:0] out;
input [31:0] a,b;
input sel;

wire [31:0] in [1:0];
assign in[0] = a;
assign in[1] = b;

assign out = in[sel];

endmodule


module MIPS(data1out,data2out,bit,bitRdy,Upload,clk,reset);

output reg [31:0] data1out,data2out;
input clk,reset,bit,bitRdy,Upload;
wire clk_1,clk_2Rf,clk_2Dm;
wire IRRdy;
reg[9:0] Pc;
wire [31:0] J,IR,WriteRegisterData,Data1,Data2,AluIn1,AluIn2,AluResult,ReadData,shamt,Immediate,OutBeq,NextPc,PcWithBranch,OutJump,OutBne,OutJr,InLui,InJal,OutLui,BranchOffset;
wire MemtoReg,Jump,Beq,Bne,MemRead,AluSrc,MemWrite,RegWrite,Jr,Shift,Jal,Lui,ZeroFlag,PcSrc1,PcSrc2;
wire [1:0] RegDst,delaySel;
wire [2:0] AluOp;
wire [3:0] AluCtl;
wire [27:0] ShiftedJump;
wire [4:0] WriteRegister;
wire RegisterWrite,NJr;
wire [31:0] PcFinal ,PcUpload,IRin;

not n1(NJr,Jr);
and a1(RegisterWrite,NJr,RegWrite);



assign J={NextPc[31:28],ShiftedJump[27:0]};
and myand1(PcSrc1,Beq,ZeroFlag);
and myand2(PcSrc2,Bne,(~ZeroFlag));

//BUFG b1(clk_1,clk);
buf #1 b1(clk_1,clk);
clkBuffer b3(clk_2Dm,clk_2Rf,clk_1,delaySel);
//Muxes
Mux5Bit mux1(WriteRegister,IR[20:16],IR[15:11],5'b11111,RegDst);
Mux mux2(AluIn1,Data1,shamt,Shift);
Mux mux3(AluIn2,Data2,Immediate,AluSrc);
Mux mux4(OutBeq,NextPc,PcWithBranch,PcSrc1);
Mux mux5(OutBne,OutBeq,PcWithBranch,PcSrc2);
Mux mux6(OutJump,OutBne,J,Jump);
Mux mux7(OutJr,OutJump,Data1,Jr);
Mux mux8(InLui,AluResult,ReadData,MemtoReg);
Mux mux9(InJal,InLui,OutLui,Lui);
Mux mux10(WriteRegisterData,InJal,NextPc,Jal);
Mux mux11(PcFinal,Pc,PcUpload,Upload);


//Adders
Adder add1(NextPc,{{22{1'b0}},Pc[9:0]},{{31{1'b0}},1'b1});
Adder add2(PcWithBranch,NextPc,BranchOffset);


//Shifters
shiftleft32 s2(OutLui,{{16{1'b0}},IR[15:0]},5'b10000);


//sign extends
SignExtend sg1(IR[15:0],Immediate);
//SignExtend5 sg2(IR[10:6],shamt);
assign shamt={{27{1'b0}},IR[10:6]};

//Assignments
assign ShiftedJump = {2'b00,IR[25:0]};
assign BranchOffset = Immediate;

InstMemDriver InstructionMemoryDriver(IRin,IRRdy,PcUpload[9:0],bit,bitRdy,Upload,reset);
InstMem InstructionMemory(IR,PcFinal[9:0],IRin,Upload,IRRdy,clk,reset);
RegFile RegisterFile(IR[25:21],IR[20:16],WriteRegister,WriteRegisterData,RegisterWrite,Data1,Data2,clk_2Rf,reset);
Mips_Alu Alu(AluResult,AluCtl,AluIn1,AluIn2,ZeroFlag,reset);
DataMem DataMemory(ReadData,MemRead,Data2,MemWrite,AluResult[9:0],clk_2Dm,reset);
Control_Unit myCtl(delaySel,RegDst,RegWrite,MemRead,MemWrite,MemtoReg,AluSrc,AluOp,Beq,Bne,Jump,Jal,Lui,IR[31:26],reset);
Alu_Control AC1(AluCtl,IR[5:0],AluOp,Jr,Shift,reset);

integer f;

always @(posedge clk_1)
begin
if(reset) Pc <= 0;
else if(!Upload) Pc<=OutJr;
if(IR[0]===1'bx && !reset &&!Upload)
begin
f = $fopen("PC");
$fdisplay(f,"%b\n%d\n%H",{{22{1'b0}},Pc},Pc,Pc);
$fclose(f);
$stop;
end
end

always @(posedge clk_2Rf)
begin
data1out <= Data1;
data2out <= Data2;
end

endmodule

module testBenchMIPS();

reg bit,bitRdy,Upload,clk,reset;
wire [31:0] data1,data2;
reg [31:0] instructionArray[0:1023];
integer i,j;

MIPS y(data1,data2,bit,bitRdy,Upload,clk,reset);

initial
begin
reset<=0;
bitRdy<=0;
Upload<=1;
#2
reset<=1;
//$readmemb("InstMem.mem",instructionArray);
#5
reset<=0;
for(i=0;i<1024;i=i+1)
begin
for(j=0;j<32;j=j+1)
begin
bit<=instructionArray[i][j];
#1
bitRdy<=1;
#1
bitRdy<=0;
end
if(instructionArray[i+1][0]===1'bx)i<=1024;
end
@(negedge clk)
begin
Upload<=0;
reset<=1;
end
#10
reset<=0;
end

initial
begin
clk<=0;

forever
begin
#5
clk<=~clk;
end

end

endmodule
