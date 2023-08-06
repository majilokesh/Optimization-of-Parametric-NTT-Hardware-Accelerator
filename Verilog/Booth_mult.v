//// Booth_mult.v

////////////////////////// Booth Radix-4 Multiplier ///////////////////////////////////
////***********************************************************************
//// FileName: Booth_mult.v
//// FPGA: MachXO2 7000HE
//// IDE: Diamond 2.0.1 
////
//// HDL IS PROVIDED "AS IS." DIGI-KEY EXPRESSLY DISCLAIMS ANY
//// WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
//// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
//// PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
//// BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
//// DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
//// PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
//// BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
//// ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
//// DIGI-KEY ALSO DISCLAIMS ANY LIABILITY FOR PATENT OR COPYRIGHT
//// INFRINGEMENT.
////
//// Version History
//// Version 1.0 04/14/2013 Tony Storey
//// Initial Public Release
//// Small Footprint Button Debouncer


//`timescale 1ns/ 100 ps
module Booth_mult #(parameter N= 18)		// parametrizable data width N
		(
		output 	reg 	[2*N-1 : 0]	product,			// outputs
		output 	reg								done,
		input 	wire	[N-1 : 0]		mplier, 			// inputs
		input 	wire	[N-1 : 0]		mcand,	
		input 	wire							n_reset, 
		input 	wire							start, 
		input 	wire							clk
		);
////---------------- states for FSM --------------------------------------		
	parameter IDLE = 2'b01, BUSY = 2'b10;
	reg 	[1 : 0] 		state_reg, state_next;
		
////---------------- internal variables ----------------------------------
	reg 	[$clog2(N>>1) : 0]		q_reg, q_next;		// scales counter to N/2 counts,    $clog2(N>>1) = log(N/2)/log(2)
	reg 	[2*N : 0]	prod_reg, prod_next;	
	reg 	 					result_reg;										// used to dertermine least sig bit for 3 bit boothe encoding
	reg		[N-1 : 0] 	mcand_reg, mcand_next;
	reg							q_add, q_reset;
//// ------------- contenious assignments ----------------------------


//// Always block to update the states
	always @ (posedge clk)
		begin	:	FSM_Synch
			if(n_reset == 1'b 0)
				begin
					state_reg <= IDLE;
					q_reg <= 7'b 000_0000;
					prod_reg <= {2*N {1'b 0} };
					result_reg <= 3'b 000;
					mcand_reg <= 1'b 0;
				end
			else
				begin
					q_reg <= q_next;
					state_reg <= state_next;
					prod_reg <= { prod_next[2*N], prod_next[2*N : 1] }; 
					result_reg <= prod_next[0];
					mcand_reg <= mcand_next;
				end
		end
	
//// Combo Counter with Control Flags
	always @ ( q_reset, q_add, q_reg)
		begin	:	Counter
			case( {q_reset , q_add} )
				2'b00 :
						q_next = q_reg;
				2'b01 :
						q_next = q_reg + 1;
				default :
						q_next = { N {1'b0} };
			endcase 	
		end
	
	
//// Calculate next state and outputs
	always @ ( * )
		begin	:	FSM_Comb
			//// initializations
			q_add = 1'b 0;
			q_reset =1'b 0;
			done = 1'b 0;
			state_next = state_reg;
			prod_next = prod_reg;
			mcand_next = mcand_reg;
			
			case ( state_reg )
				IDLE	:	
					begin
						if( start == 1'b 1 )
							begin
								mcand_next = mcand;
								prod_next = { {N-1 {1'b 0} }, mplier, 1'b 0};
								state_next = BUSY;
							end
						else
							begin
								mcand_next = mcand_reg;
							end
					end
					
				BUSY	:
					begin
						q_add = 1'b 1;		// start adder
						if((q_reg == ( N >> 1)) && (start != 1'b 1))											// after N/2 clock cycles multiplication is done
							begin
								done = 1'b 1;
								q_add = 1'b 0;
								q_reset = 1'b 1;
								state_next = IDLE;
							end
							
						//// Booth Decode and Operation, encoding comes from prod_next[2:0] after sequential update 
						case ({prod_reg[1:0], result_reg})
							3'b 001		:		prod_next = {(  {prod_reg[2*N], prod_reg[2*N : N+1]}   +    { mcand_reg[N-1], mcand_reg }   ), prod_reg[N : 1]};		// Add Mcand

							3'b 010		:		prod_next = {(  {prod_reg[2*N], prod_reg[2*N : N+1]}   +    { mcand_reg[N-1], mcand_reg }   ), prod_reg[N : 1]};		// Add Mcand

							3'b 011		:		prod_next = {( {prod_reg[2*N], prod_reg[2*N : N+1]}  +   {mcand_reg, 1'b 0} ),  prod_reg[N : 1]};									// Add 2*Mcand

							3'b 100		:		prod_next = {( {prod_reg[2*N], prod_reg[2*N : N+1]}  -   {mcand_reg, 1'b 0} ),  prod_reg[N : 1]};									// Sub 2*Mcand

							3'b 101		:		prod_next = {(  {prod_reg[2*N], prod_reg[2*N : N+1]}   -    {mcand_reg[N-1], mcand_reg}   ), prod_reg[N : 1]};		// Sub Mcand

							3'b 110		:		prod_next = {(  {prod_reg[2*N], prod_reg[2*N : N+1]}   -    {mcand_reg[N-1], mcand_reg}   ), prod_reg[N : 1]};		// Sub Mcand								

							default 	:		prod_next = { prod_reg[2*N], prod_reg[2*N : 1] }; 																																// Shift >> 1

						endcase
						
					end  // end BUSY
				
			endcase
			
	end  // end always

//// Synch ouput with done for enable
	always @ (posedge clk)
		begin 	: 	Synch_Output
			if	(done)
				product <= prod_reg[2*N : 1] ; 
		end
		
		
		
		
endmodule









