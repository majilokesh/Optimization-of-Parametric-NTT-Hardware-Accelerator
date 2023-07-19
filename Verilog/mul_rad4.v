`define DATA_SIZE_ARB   32

module mul_rad4 (
input clk,reset,
input  [`DATA_SIZE_ARB-1:0] x,y,
output reg [`DATA_SIZE_ARB*2 - 1:0] out
);
reg [2:0] c=0 ;

reg   [`DATA_SIZE_ARB*2 - 1:0] pp=0; //partial products
reg   [`DATA_SIZE_ARB*2 - 1:0] spp=0; //shifted partial products
reg   [`DATA_SIZE_ARB*2 - 1:0] prod=0;
reg [`DATA_SIZE_ARB - 1:0] i=0,j=0;
reg flag=0, temp=0 ;
wire [`DATA_SIZE_ARB - 1:0] inv_x ;
//assign x= (~x) +1'b1;
assign inv_x = (~x) +1'b1;
always@(posedge clk)
begin
if(reset)
begin
out=0;
c=0;
pp=0;
flag=0;
spp=0;
i=0;
j=0;
prod=0;
end
else begin

if(!flag)
c={y[1],y[0],1'b0};
flag=1;
case(c)
////////////////////////
3'b000,3'b111: begin
if(i<`DATA_SIZE_ARB/2)
begin  i=i+1;
c={y[2*i+1],y[2*i],y[2*i-1]}; end
else
c=3'bxxx;
end
////////////////////////////
3'b001,3'b010:
begin
if(i<`DATA_SIZE_ARB/2)
begin
i=i+1;
c={y[2*i+1],y[2*i],y[2*i-1]};
pp={{`DATA_SIZE_ARB{x[`DATA_SIZE_ARB - 1]}},x};
if(i==1'b1)
prod=pp;
else
begin
temp=pp[`DATA_SIZE_ARB*2 - 1];
j=i-1;
j=j<<1;
spp=pp<<j;
spp={temp,spp[(`DATA_SIZE_ARB - 1)*2:0]};
prod=prod+spp;
end
end
else c=3'bxxx;
end
///////////////////////////
3'b011:
begin
if(i<`DATA_SIZE_ARB/2)
begin
i=i+1;
c={y[2*i+1],y[2*i],y[2*i-1]};
pp={{`DATA_SIZE_ARB - 1{x[`DATA_SIZE_ARB - 1]}},x,1'b0};
if(i==1'b1)
prod=pp;
else
begin
temp=pp[`DATA_SIZE_ARB*2 - 1];
j=i-1;
j=j<<1;
spp=pp<<j;
spp={temp,spp[(`DATA_SIZE_ARB - 1)*2:0]};
prod=prod+spp;
end
end
else c=3'bxxx;
end
///////////////////////////
3'b100:
begin
if(i<`DATA_SIZE_ARB/2)
begin
i=i+1;
c={y[2*i+1],y[2*i],y[2*i-1]};
pp={{(`DATA_SIZE_ARB - 1){inv_x[`DATA_SIZE_ARB - 1]}},inv_x,1'b0};
if(i==1'b1)
prod=pp;
else
begin
temp=pp[`DATA_SIZE_ARB*2 - 1];
j=i-1;
j=j<<1;
spp=pp<<j;
spp={temp,spp[(`DATA_SIZE_ARB - 1)*2:0]};
prod=prod+spp;
end
end
else c=3'bxxx;
end
////////////////////////////////////
3'b101, 3'b110:
begin
if(i<`DATA_SIZE_ARB/2)
begin
i=i+1;
c={y[2*i+1],y[2*i],y[2*i-1]};
pp={{`DATA_SIZE_ARB{inv_x[`DATA_SIZE_ARB - 1]}},inv_x};
if(i==1'b1)
prod=pp;
else
begin
temp=pp[`DATA_SIZE_ARB*2 - 1];
j=i-1;
j=j<<1;
spp=pp<<j;
spp={temp,spp[(`DATA_SIZE_ARB - 1)*2:0]};
prod=prod+spp;
end
end
else c=3'bxxx;
end
////////////////
default:
out= prod;
endcase
end
end

endmodule
