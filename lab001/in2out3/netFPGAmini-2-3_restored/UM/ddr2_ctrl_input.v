module ddr2_ctrl_input(
sys_rst_n,

ddr2_clk,
local_init_done,
local_ready,
local_address,
local_read_req,
local_write_req,
local_wdata,
local_be,
local_size,
local_burstbegin,


um2ddr_wrreq,
um2ddr_data,
um2ddr_data_ready,
um2ddr_command_ready,
um2ddr_command_wrreq,
um2ddr_command,
um2ddr_wrclk,
rd_ddr2_size,
rd_ddr2_size_wrreq,
read_permit
);
input          sys_rst_n;
input          ddr2_clk;
input		      local_ready;

input		      local_init_done;
		
output[25:0]	local_address;
output		   local_write_req;
output		   local_read_req;
output		   local_burstbegin;
output[31:0]	local_wdata;
output[3:0]    local_be;
output[3:0]	   local_size;

input          um2ddr_wrclk;
input          um2ddr_wrreq;
input	[127:0]  um2ddr_data; 
output         um2ddr_command_ready;
output         um2ddr_data_ready;
input          um2ddr_command_wrreq;
input	[33:0]   um2ddr_command;

output[6:0]    rd_ddr2_size;
output         rd_ddr2_size_wrreq;
input          read_permit;

/////////////////////////////////////
reg[25:0]	local_address;
reg		   local_write_req;
reg		   local_read_req;
reg		   local_burstbegin;
reg[31:0]	local_wdata;
reg[3:0]    local_be;
reg[3:0]	   local_size;
reg        um2ddr_data_ready;
reg        um2ddr_command_ready;
reg[6:0]    rd_ddr2_size;
reg         rd_ddr2_size_wrreq;
reg[95:0]   um2ddr_reg;
///////////////////////////////////
reg [6:0]  pkt_len;
reg [1:0]  shift;
reg [25:0] op_addr;
reg [33:0] command_reg;
reg [127:0] data_reg;
reg flag;
reg [3:0]  state;
///////////////////////////////////

///////////////////////////////////
parameter idle_s     = 4'h0,
          wr_start_s = 4'h1,
			 wr_mid_fs  = 4'h2,
			 wr_mid_sd  = 4'h3,
			 wr_end_s   = 4'h4,
			 rd_start_s = 4'h5,
			 rd_s       = 4'h6,
			 wait_s     = 4'h7,
			 wait_s1    =4'h8,
			 wait_s2    =4'h9,
			 wait_w     =4'ha,
			 wait_w1 =4'hb,
			 command=4'hc;
always@(posedge ddr2_clk or negedge sys_rst_n)
begin
    if(~sys_rst_n)begin
		   local_write_req      <= 1'b0;
		   local_read_req       <= 1'b0;
		   local_burstbegin     <= 1'b0;
			rd_ddr2_size_wrreq   <= 1'b0;
			command_reg<=34'b0;
			flag<=1'b0;
			data_reg<=128'b0;
			um2ddr_reg           <= 96'b0;
			shift                <= 2'b0;			
			local_address<=26'b0;
			local_wdata<=32'b0;
			local_be<=4'b0;
			local_size<=4'b0;
			um2ddr_data_ready<=1'b0;
			um2ddr_command_ready<=1'b0;
			rd_ddr2_size<=7'b0;
///////////////////////////////////
			pkt_len<=7'b0;
			shift<=2'b0;
			op_addr<=26'b0;			
			state <= idle_s;
	   end
	 else begin
	    case(state)
		   idle_s:begin
			local_write_req      <= 1'b0;
			local_read_req       <= 1'b0;
			local_burstbegin     <= 1'b0;
			rd_ddr2_size_wrreq   <= 1'b0;
			command_reg<=34'b0;
			flag<=1'b0;
			data_reg<=128'b0;
			um2ddr_reg           <= 96'b0;
			shift                <= 2'b0;			
			local_address<=26'b0;
			local_wdata<=32'b0;
			local_be<=4'b0;
			local_size<=4'b0;
			um2ddr_data_ready<=1'b0;
			um2ddr_command_ready<=1'b0;
			rd_ddr2_size<=7'b0;
///////////////////////////////////
			pkt_len<=7'b0;
			shift<=2'b0;
			op_addr<=26'b0;	
			    if(local_ready)begin
					um2ddr_command_ready<=1'b1;
					state  <= command;					
				end
				else begin
				state <= idle_s;
				end
			end
			command:begin
			if(local_ready && local_init_done)begin
				if(um2ddr_command_wrreq && flag==1'b0) begin			
					um2ddr_command_ready<=1'b0;
				    op_addr              <= um2ddr_command[25:0];
					 pkt_len              <= um2ddr_command[32:26];
					 local_address        <= um2ddr_command[25:0];
				    if(um2ddr_command[33])begin//read ddr2
					    pkt_len        <= um2ddr_command[32:26]<<2;
						 state          <=  rd_start_s;
						end
						else begin
							um2ddr_data_ready <= 1'b1;
							state <= wr_start_s;
							flag<=1'b0;
						end
					end
				  else if( flag==1'b1) begin
						 op_addr              <= command_reg[25:0];
					 pkt_len              <= command_reg[32:26];
					 local_address        <= command_reg[25:0];
				    if(um2ddr_command[33])begin//read ddr2
					    pkt_len        <= command_reg[32:26]<<2;
						 state          <=  rd_start_s;
						end
						else begin
							um2ddr_data_ready <= 1'b1;
							state <= wr_start_s;
							flag<=1'b0;
						end
					end
				else begin
				 state <= command;
				end
			end//endlocal_ready && local_init_done
			else begin
				if(um2ddr_command_wrreq)begin
					um2ddr_command_ready<=1'b0;
					flag<=1'b1;
					command_reg<=um2ddr_command;
					state          <=  command;
				end
				else begin
					state <= command;
				end
			end
		end
			wr_start_s:begin 
				  local_write_req   <= 1'b0;
			   if(local_ready && local_init_done )begin
				 if(um2ddr_wrreq && flag==1'b0) begin
					um2ddr_data_ready         <= 1'b0;
				    local_write_req   <= 1'b1;
					local_burstbegin  <= 1'b1;
					local_be          <= 4'hf;
					local_size        <= 4'h4;
					pkt_len           <= pkt_len - 1'b1;
					local_address     <= op_addr ;
					local_wdata       <= um2ddr_data[127:96];
				    um2ddr_reg        <= um2ddr_data[95:0];	 
					state             <= wr_mid_fs;
					flag<=1'b0;
				  end
				  else if( flag==1'b1)begin
					um2ddr_data_ready         <= 1'b0;
				   local_write_req   <= 1'b1;
					local_burstbegin  <= 1'b1;
					local_be          <= 4'hf;
					local_size        <= 4'h4;
					pkt_len           <= pkt_len - 1'b1;
					local_address     <= op_addr ;
					local_wdata       <= data_reg[127:96];
				    um2ddr_reg        <= data_reg[95:0];	 
					state             <= wr_mid_fs;
					flag<=1'b0;
					end
					else begin
				    state <= wr_start_s;
					 
					end
				end
			  else begin
				if(um2ddr_wrreq)begin
					um2ddr_data_ready         <= 1'b0;
					data_reg<=um2ddr_data;
					state <= wr_start_s;
					flag<=1'b1;
				end
				else begin
				state <= wr_start_s;
				end
				end
			end
			wr_mid_fs:
			   begin
			   local_write_req   <= 1'b0;
			      if(local_ready && local_init_done)
					 begin
					  local_write_req   <= 1'b1;
					  local_burstbegin  <= 1'b0;
					
					  local_be          <= 4'hf;
					  local_wdata       <= um2ddr_reg[95:64];
					  state             <= wr_mid_sd;
					 end
					else
					 begin
					  local_burstbegin  <= 1'b0;
					 
					  state             <= wr_mid_fs;
					 end
				end
			wr_mid_sd:
			   begin
			   local_write_req   <= 1'b0;
	 		      if(local_ready && local_init_done)
					 begin
					  local_write_req   <= 1'b1;
					  
					  local_be          <= 4'hf;
					  local_wdata       <= um2ddr_reg[63:32];
					  state             <= wr_end_s;
					 end
					else
					 begin
					  state             <= wr_mid_sd;
					 end
				end
			wr_end_s:
			   begin
			   local_write_req   <= 1'b0;
					if(local_ready && local_init_done)
					 begin
					  local_write_req   <= 1'b1;
					 
					  local_be          <= 4'hf;
					  local_wdata       <= um2ddr_reg[31:0];
					  op_addr           <= op_addr + 4'h8;
					  if(pkt_len == 7'h0)
					   begin
					    state      <= idle_s;
					   end
					  else
					   begin
					    
					    state             <= wait_w;
					   end
					 end
					else
					 begin
					  state             <= wr_end_s;
					 end
				end
			wait_w:begin
				local_write_req   <= 1'b0;
				state      <= wait_w1;
			end
			wait_w1:begin
				um2ddr_data_ready      <= 1'b1;
				state      <= wr_start_s;
			end
			
			
			
			
		   rd_start_s:begin
			
			      if(read_permit==1'b0)begin
					    state <= rd_start_s;
					  end
					else begin
					    rd_ddr2_size       <= pkt_len;
						 rd_ddr2_size_wrreq <= 1'b1;
						 state  <= rd_s;
					  end
			   end
			rd_s:begin 
			   rd_ddr2_size_wrreq <= 1'b0;
				if(local_ready && local_init_done)
			     begin
					 local_read_req   <= 1'b1;
					 local_burstbegin <= 1'b1;
                local_be         <= 4'hf;
					 local_address		<=	op_addr;
					 if(pkt_len > 7'h4)//zyl 8=>4
					   begin
 						  local_size <= 4'h4;
						  pkt_len    <= pkt_len - 4'h4;
						  op_addr    <= op_addr + 4'h8; 
						  state      <= wait_s;
					   end
					 else begin
						  local_size <= pkt_len[3:0];	//
						  state      <= idle_s;
					   end
				  end
				 else begin
				    local_read_req <= 1'b0;
				    state          <= rd_s;
				  end
			   end
			wait_s:begin
					
			       local_read_req <= 1'b0;
				    state          <= wait_s1;
				end
			wait_s1:begin
			       local_read_req <= 1'b0;
				    state          <= wait_s2;
				end
				
				
			wait_s2:begin
			       local_read_req <= 1'b0;
				    state          <= rd_s;
				end
			     
			default:begin
			     local_write_req      <= 1'b0;
		        local_read_req       <= 1'b0;
		        local_burstbegin     <= 1'b0;
              rd_ddr2_size_wrreq   <= 1'b0;
			     state <= idle_s; 
				end
		 endcase
	 end
end
endmodule