/*
 1、UM包括4个接口：localbus、cdp input、cdp output和ddr2接口。
 2、此模板工作在pass-through模式，用户可以在端口2和端口3之间测试Ping报文的连通性。请注意，这两个端口对应FPGA内部的逻辑端口0和1，因为内部地址编码一般都从0开始。 
 3、UM的localbus 接口上定义了8个UM ID寄存器和8个UM RAM寄存器，其中ID0-ID3 为只读寄存器。
 4、出于测试和简单化的原因，此模块基于localbus接口完成DDR2访问。UM规范的DDR2接口定义了多字访问方式，此模板只支持单字访问。如果用户愿意，可以扩充到长达127字的访问方式， 这种方式下建议用户从实际报文中选取需要存储的数据。
 
 */
  
module UM(
 	 input      wire              clk,                 //125M系统时钟
  	 input      wire              reset,               //系统复位
  
  //-------------------localbus control--------------------//
  
  	 input      wire              localbus_cs_n,       //片选，低有效
  	 input      wire              localbus_rd_wr,      //读写操作，高读低写
  	 input      wire  [31:0]      localbus_data,       //地址数据复用总线，当localbus_ale=1时，对应地址相位，随后是数据相位。
         input      wire              localbus_ale,        //地址锁存 
  	 output     reg               localbus_ack_n,      //本地总线响应，低有效
   	 output     reg   [31:0]      localbus_data_out,   // UM寄存器读数据 
   
   //------------------ CDP input control-----------------//
   
   	 output     wire              um2cdp_path,        //CDP input_ctrl的资源空闲判断路径，见表1-1
   	 input      wire              cdp2um_data_valid,  //数据有效指示，来自CDP input_ctrl,高有效
    	 input      wire  [138:0]     cdp2um_data,        //来自CDP input_ctrl的报文数据  
   	 output     reg               um2cdp_tx_enable,   //送往CDP input_ctrl的发送使能，高有效
   
   //----------------- CDP output control----------------//
   
   	 output     reg               um2cdp_data_valid,  //数据有效指示，送往CDP output_ctrl，高有效
   	 output     reg   [138:0]     um2cdp_data,        //送往CDP output_ctrl的报文数据 
   	 input      wire              cdp2um_tx_enable,   //来自CDP output_ctrl的发送使能，高有效 
   	 output     reg   [29:0]      um2cdp_rule,        //送往CDP output_ctrl的规则信息
    	 output     reg               um2cdp_rule_wrreq,  //规则写请求
     	 input      wire  [4:0]       cdp2um_rule_usedw,  //规则fifo中的words数量 
     
     //----------------UM_DDR2 control------------------//
     
        output     wire              um2ddr_wrclk,      //ddr2写时钟,来自UM工作时钟
        output     reg               um2ddr_wrreq,      //ddr2写请求，高有效，写数据FIFO的写信号
        output     reg   [127:0]     um2ddr_wdata,      //ddr2写数据，写数据FIFO的128位写数据
        input      wire              ddr2um_command_ready,      //ddr2准备好信号，1：DDR2控制器就绪，UM可请求操作
        input                        ddr2um_data_ready,
        output     reg               um2ddr_command_wrreq,//ddr2命令FIFO的写请求 
        output     reg   [33:0]      um2ddr_command,      //ddr2命令操作，bit[33] :1-读DDR2    0-写DDR2
        output     wire              um2ddr_rdclk,       // ddr2读时钟,来自于UM工作时钟
        output     reg               um2ddr_rdreq,       //ddr2读请求，高有效
        input      wire  [127:0]     ddr2um_rdata,       //ddr2读数据
        output     reg               um2ddr_valid_rdreq, //ddr2信息fifo读请求
        input      wire  [6:0]       ddr2um_valid_rdata, //ddr2信息fifo读数据
        input      wire              ddr2um_valid_empty  //ddr2信息fifo空指示：1-FIFO空；0-FIFO非空即有返回的数据
		 
       );/* synthesis noprune */
   
   	
   	wire [138:0]      cdp2um_data_q/* synthesis keep */; 
    	reg               cdp2um_data_rdreq;
    	wire [7:0]        cdp2um_data_usedw;
    	
    	
    	reg [3:0]         input_port_reg; //输入端口号 
    	
    	reg [1:0]         cdp2um_state; //UM接收状态机 
    	
    	reg [2:0]         um2cdp_state; //UM发送状态机
    	
    	
    	parameter         pass_through_idle = 3'b000, pass_through_header1 = 3'b001; 
    	parameter         pass_through_header2 = 3'b010, pass_through_header3 = 3'b011; 
    	parameter         pass_through_header4 = 3'b100, pass_through_payload = 3'b101;
    	
    	
    	reg [27:0]        localbus_addr; 
    	
    	reg [31:0]        localbus_data_in;
    	reg [2:0]         localbus_state; 
    	
    	parameter         localbus_idle=3'b000, localbus_address=3'b001,localbus_write=3'b010; 
    	parameter         localbus_read=3'b011,localbus_ack=3'b100;
    	
    	
    	reg [31:0]        UM_ID0,UM_ID1,UM_ID2,UM_ID3;          //UM    ID寄存器 
    	reg [31:0]        UM_ID4,UM_ID5,UM_ID6,UM_ID7; 
    	reg [31:0]        UM_RAM0,UM_RAM1,UM_RAM2,UM_RAM3;      //UM    RAM寄存器 
    	reg [31:0]        UM_RAM4,UM_RAM5,UM_RAM6,UM_RAM7;
    	
    	
    	reg [2:0]         um2ddr_state; 
    	reg [31:0]        UM2DDR_WDATA0,UM2DDR_WDATA1;          //DDR2写数据寄存器 
    	reg [31:0]        UM2DDR_WDATA2,UM2DDR_WDATA3; 
    	reg [31:0]        UM2DDR_RDATA0,UM2DDR_RDATA1;          //DDR2读数据寄存器 
    	reg [31:0]        UM2DDR_RDATA2,UM2DDR_RDATA3; 
    	reg [31:0]        UM2DDR_COMMAND0, UM2DDR_COMMAND1;     //DDR2命令寄存器
    	
    	
    	parameter         um2ddr_idle=3'b000, um2ddr_order=3'b001; 
    	parameter         um2ddr_write=3'b010,um2ddr_valid_wait=3'b011; 
    	parameter         um2ddr_valid_read=3'b100,um2ddr_data_read=3'b101;
    	    	
    	
//------------------锁存输入输出端口号实验代码在此输入-----------//
//always@(posedge clk or negedge reset)
//      if(!reset)
//	      begin
//	      	um2cdp_rule <=30'b0; 
//	      	um2cdp_rule_wrreq <= 1'b0;
//	      	input_port_reg <= 4'b0;		
//	      end
//      else
//	      begin 
//	      	if((cdp2um_data_valid==1'b1)&&(cdp2um_data[138:136]==3'b101)) //报文头到达
//	      		input_port_reg <= cdp2um_data[131:128]; //锁存输入端口号
//	      	//定义转发规则：决定输出端口号、全文转发、摘要转发或丢弃报文。
//	      	//如果查表算法较复杂，需要一边接收报文一边查表，以在报文尾到达时产生规
//	      	//则信息。路由表可以放在UM的内部RAM中，也可以放在外部DDR2中。 
//	      	//这里只实现了最简单的端口交换行为，因此未进行IP层的查表。
//	      	else if((cdp2um_data_valid==1'b1)&&(cdp2um_data[138:136]==3'b110)&&(cdp2um_rule_usedw<5'd30)) //报文尾到达
//	      		begin		//端口号交换
//	      			if(input_port_reg==4'b0001) //来自外部端口2（逻辑端口1）
//	      				begin 
//	      					um2cdp_rule <=30'h00000004; //送往外部端口3（逻辑端口2） //最高位固定为0，告诉CDP output_ctrl报文来自UM
//	      					um2cdp_rule_wrreq <=1'b1; //写规则
//	      				end
//	      			else if(input_port_reg==4'b0010) //来自外部端口3（逻辑端口2）	
//	      				begin
//	      					um2cdp_rule <=30'h00000002; //送往外部端口2（逻辑端口1） 
//	      					um2cdp_rule_wrreq <=1'b1;	
//	      				end
//	      			else 
//	      				um2cdp_rule_wrreq <=1'b0; //来自其它端口，不写规则
//	      		end	
//	      	else
//	      		um2cdp_rule_wrreq <= 1'b0;	
//	      end
always@(posedge clk or negedge reset)
	if(!reset)
		begin
			um2cdp_rule<=30'b0;
			um2cdp_rule_wrreq<=1'b0;
			input_port_reg<=4'b0;
		end	
	else
		begin
			if((cdp2um_data_valid==1'b1)&&(cdp2um_data[138:136]==3'b101)) 
				input_port_reg<=cdp2um_data[131:128];
			else if((cdp2um_data_valid==1'b1)&&(cdp2um_data[138:136]==3'b110)&&(cdp2um_rule_usedw<5'd30))
				begin
					if(input_port_reg==4'b0001)
						begin
							um2cdp_rule<=30'h0000000d;
							um2cdp_rule_wrreq<=1'b1;
						end
					else if(input_port_reg==4'b0010) //来自外部端口3 (逻辑端口2)
						begin
							um2cdp_rule <=30'h0000000b; //送往外部端口2 (逻辑端口1)
							um2cdp_rule_wrreq <=1'b1;
						end
					else if(input_port_reg==4'b0011) //来自外部端口4 (逻辑端口3)
						begin
							um2cdp_rule <=30'h00000007; 
							um2cdp_rule_wrreq <=1'b1;
						end
					else if(input_port_reg==4'b0000) //来自外部端口1 (逻辑端口0)
						begin
							um2cdp_rule <=30'h0000000e; 
							um2cdp_rule_wrreq <=1'b1;
						end
					else
						um2cdp_rule_wrreq <=1'b0; //来自其它端口,不写规则
				end
			else
				um2cdp_rule_wrreq <= 1'b0;
		end

		
//---------------------输出使能信号 um2cdp_tx_enable 给CDP input_ctrl--------------//	
	
always@(posedge clk or negedge reset)	
	if(!reset)
		begin
			um2cdp_tx_enable <= 1'b0; 
			cdp2um_state <= 2'b00;
		end
	else
		case(cdp2um_state)
			2'b00: if((cdp2um_data_usedw<8'd161) && (cdp2um_data_valid==1'b0)) //UM内部pass_through fifo未满且cdp input_ctrl空闲
					begin  
						um2cdp_tx_enable <= 1'b1; 
						cdp2um_state <= 2'b01;
					end
			2'b01: if(cdp2um_data_valid==1'b1)
					begin
						um2cdp_tx_enable <= 1'b0; 
						cdp2um_state <= 2'b00;
						
					end
			default: begin
					um2cdp_tx_enable <= 1'b0; 
					cdp2um_state <= 2'b00;
				  
		        end			
					
		endcase
		
		
	//如果um2cdp_path = 0，告诉cdp input_ctrl，看um2cdp_tx_enable是否有效来 
	//决定是否向UM输出报文。如果um2cdp_path =1，告诉cdp input_ctrl，自行判 
	//断内部输入输出缓冲FIFO的占用空间值，来决定是否从上游FIFO接收报文。 
	//如果能接收报文，将报文送往内部输入输出缓冲FIFO的同时，也送往UM，便于UM实现路由查找算法并形成转发规则。
	
	assign um2cdp_path = um2cdp_rule[29];
	
	
	//读取报文，如果愿意可以修改报文的前64字节，CRC由其它模块自动产生。
	 
	//This is the simplest pass_through operation;报文传输路径
	
always@(posedge clk or negedge reset)
	if(!reset)
		begin
			cdp2um_data_rdreq <= 1'b0; 
			um2cdp_data_valid <=1'b0; 
			um2cdp_data <= 139'b0; 
			um2cdp_state <= pass_through_idle;
		end
	else 
		case(um2cdp_state)
			pass_through_idle: 	begin
							cdp2um_data_rdreq <= 1'b0; 
							um2cdp_data_valid <= 1'b0; 
							um2cdp_data <= 139'b0;
							if(cdp2um_tx_enable == 1'b1) //CDP output_ctrl资源空闲
								begin
									cdp2um_data_rdreq <= 1'b1; //读CDP2UM_DATA_FIFO 
									um2cdp_state <= pass_through_header1;
								end
			end
			pass_through_header1:	begin
							cdp2um_data_rdreq <= 1'b1; 
							um2cdp_data_valid <= 1'b1; //输出报文开始 
							um2cdp_data <= cdp2um_data_q; //可以从这里开始修改报文的头部信息，CRC值将会在其它模块中自动产生 
							um2cdp_state <= pass_through_header2;
			end	
				
			pass_through_header2: 	begin 
							cdp2um_data_rdreq <= 1'b1; 
							um2cdp_data_valid <= 1'b1; 
							um2cdp_data <= cdp2um_data_q; 
							um2cdp_state <= pass_through_header3;	
			end		   
					   
			pass_through_header3:   begin 
							cdp2um_data_rdreq <= 1'b1;                                                                  	   
				                        um2cdp_data_valid <= 1'b1; 
				                        um2cdp_data <= cdp2um_data_q; 
				                        um2cdp_state <= pass_through_header4;                                                                  	   
		        end  
		                        	
		        pass_through_header4:   begin
		        				cdp2um_data_rdreq <= 1'b1; 
		        				um2cdp_data_valid <= 1'b1; 
		        				um2cdp_data <= cdp2um_data_q; 
		        				if(cdp2um_data_q[138:136]==3'b110) //报文尾到达 
		        				        um2cdp_state <= pass_through_idle; 
		        				else 
		        				        um2cdp_state <= pass_through_payload;
		        end          
		        pass_through_payload:   begin
		                                        cdp2um_data_rdreq <= 1'b1; 
		                                        um2cdp_data_valid <= 1'b1; 
		                                        um2cdp_data <= cdp2um_data_q; 
		                                        if(cdp2um_data_q[138:136]==3'b110) //报文尾到达 
		                                                um2cdp_state <= pass_through_idle; 
		                                        else 
		                                                um2cdp_state <= pass_through_payload;
		        end              	
		                        	
		        default              :  begin
		                                        cdp2um_data_rdreq <= 1'b0; 
		                                        um2cdp_data_valid <= 1'b0; 
		                                        um2cdp_data <= 139'b0; 
		                                        um2cdp_state <= pass_through_idle;
		        end  
		        
		                      	
		endcase	 
		
          
	
//--------------------------localbus寄存器读写---------------------------// 
		
always@(posedge clk or negedge reset)
      if(!reset)
            begin
                  UM_ID0 <= 32'h554D; //554D=ASCII code "UM"; 
                  UM_ID1 <= 32'h0609; //UM 开发者名称 
                  UM_ID2 <= 32'h0528; //UM 开发日期
                  UM_ID3 <= 32'h0526; //UM 版本 
                  UM_ID4 <= 32'h0; 
                  UM_ID5 <= 32'h0; 
                  UM_ID6 <= 32'h0; 
                  UM_ID7 <= 32'h0; 
                  UM_RAM0 <= 32'h0; 
                  UM_RAM1 <= 32'h0; 
                  UM_RAM2 <= 32'h0; 
                  UM_RAM3 <= 32'h0; 
                  UM_RAM4 <= 32'h0; 
                  UM_RAM5 <= 32'h0; 
                  UM_RAM6 <= 32'h0; 
                  UM_RAM7 <= 32'h0; 
                  UM2DDR_WDATA0 <= 32'h0; 
                  UM2DDR_WDATA1 <= 32'h0; 
                  UM2DDR_WDATA2 <= 32'h0; 
                  UM2DDR_WDATA3 <= 32'h0; 
                  UM2DDR_COMMAND0 <= 32'h0;//{UM2DDR_COMMAND1[0],UM2DDR_COMMAND0[31:26]}=连续访问的地址数目，UM2DDR_COMMAND0[25:0]= 起始地址
                  UM2DDR_COMMAND1 <= 32'h0;//UM2DDR_COMMAND1[2]=1，开始ddr2访问 ;UM2DDR_COMMAND1[1]=1，读ddr2；=0，写ddr2
                  localbus_addr <= 28'b0; 
                  localbus_ack_n <= 1'b1; 
                  localbus_data_in <=32'b0; 
                  localbus_data_out <= 32'b0; 
                  localbus_state <= localbus_idle;
            end
     else
            case(localbus_state)
                  localbus_idle: if(localbus_ale == 1'b1 && localbus_data[31:28] == 4'b0001) //UM registers;
                                          begin
                                                localbus_addr <= localbus_data[27:0]; //only localbus_addr[7:0] are used while access UM ID registers; 
                                                localbus_state <= localbus_address;
                                          end
                 localbus_address: if(localbus_cs_n == 1'b0 && localbus_rd_wr == 1'b0) //写数据  
                                          begin
                                                localbus_data_in <= localbus_data; 
                                                localbus_state <= localbus_write;
                                          end 
                                   else if(localbus_cs_n == 1'b0 && localbus_rd_wr == 1'b1) //读数据 
                                          localbus_state <= localbus_read;
                 localbus_write:   if(localbus_addr[27:26] == 2'b00) //UM ID 寄存器 
                                          begin
                                                localbus_ack_n <= 1'b0; 
                                                localbus_state <= localbus_ack;
                                                case(localbus_addr[7:0])
                                                      8'h04: UM_ID4 <= localbus_data_in;//UM ID0-ID3为只读寄存器
                                                      8'h05: UM_ID5 <= localbus_data_in;
                                                      8'h06: UM_ID6 <= localbus_data_in;
                                                      8'h07: UM_ID7 <= localbus_data_in; //用户可在此添加更多ID或模式寄存器  
                                                      default:begin end
                                                endcase       
                                          end 
                                   else if(localbus_addr[27:26] == 2'b01) //UM RAM寄存器  
                                          begin
                                                localbus_ack_n <= 1'b0; 
                                                localbus_state <= localbus_ack;
                                                case(localbus_addr[7:0])
                                                      8'h00: UM_RAM0 <= localbus_data_in; 
                                                      8'h01: UM_RAM1 <= localbus_data_in; 
                                                      8'h02: UM_RAM2 <= localbus_data_in; 
                                                      8'h03: UM_RAM3 <= localbus_data_in; 
                                                      8'h04: UM_RAM4 <= localbus_data_in;
                                                      8'h05: UM_RAM5 <= localbus_data_in; 
                                                      8'h06: UM_RAM6 <= localbus_data_in; 
                                                      8'h07: UM_RAM7 <= localbus_data_in;
                                                      //用户可在此添加更多RAM寄存器
                                                      default:begin end
                                                endcase
                                          end 
                                   else if(localbus_addr[27:26] == 2'b10) //UM DDR2间接寄存器
                                          begin
                                                localbus_ack_n <= 1'b0; 
                                                localbus_state <= localbus_ack;
                                                case(localbus_addr[7:0]) 
                                                      8'h00: UM2DDR_WDATA0 <= localbus_data_in;//4个字的localbus数据拼成1个字的 UM2DDR_WDATA  
                                                      8'h01: UM2DDR_WDATA1 <= localbus_data_in; 
                                                      8'h02: UM2DDR_WDATA2 <= localbus_data_in; 
                                                      8'h03: UM2DDR_WDATA3 <= localbus_data_in; 
                                                      8'h04: UM2DDR_COMMAND0 <= localbus_data_in;//写入操作命令低32位  
                                                      8'h05: UM2DDR_COMMAND1 <= localbus_data_in;//写入操作命令其余高位，包括启动位  
                                                      //用户可在此添加更多DDR2间接寄存器
                                                      default:begin end
                                                endcase
                                          end 
                                    else  
                                           begin
                                                localbus_ack_n <= 1'b0;
                                                localbus_state <= localbus_ack;
                                          end  
                                          
                 localbus_read:    if(localbus_addr[27:26] == 2'b00) //UM ID寄存器; 
                                          begin
                                                localbus_ack_n <= 1'b0; 
                                                localbus_state <= localbus_ack;
                                                case(localbus_addr[7:0]) 
                                                      8'h00: localbus_data_out <= UM_ID0; 
                                                      8'h01: localbus_data_out <= UM_ID1; 
                                                      8'h02: localbus_data_out <= UM_ID2; 
                                                      8'h03: localbus_data_out <= UM_ID3; 
                                                      8'h04: localbus_data_out <= UM_ID4; 
                                                      8'h05: localbus_data_out <= UM_ID5; 
                                                      8'h06: localbus_data_out <= UM_ID6;
                                                      8'h07: localbus_data_out <= UM_ID7; 
                                                      //用户可在此添加更多ID或模式寄存器
                                                      default:localbus_data_out <= 32'b0;
                                                endcase
                                          end                    
                                  else if(localbus_addr[27:26] == 2'b01) //UM RAM寄存器 
                                          begin
                                                localbus_ack_n <= 1'b0; 
                                                localbus_state <= localbus_ack;
                                                case(localbus_addr[7:0]) 
                                                      8'h00: localbus_data_out <= UM_RAM0; 
                                                      8'h01: localbus_data_out <= UM_RAM1; 
                                                      8'h02: localbus_data_out <= UM_RAM2; 
                                                      8'h03: localbus_data_out <= UM_RAM3;
                                                      8'h04: localbus_data_out <= UM_RAM4; 
                                                      8'h05: localbus_data_out <= UM_RAM5; 
                                                      8'h06: localbus_data_out <= UM_RAM6; 
                                                      8'h07: localbus_data_out <= UM_RAM7; //用户可在此添加更多RAM寄存器
                                                      default:localbus_data_out <= 32'b0;
                                                endcase      
                                          end
                                  else if(localbus_addr[27:26] == 2'b10) //UM DDR2间接寄存器 
                                          begin
                                                localbus_ack_n <= 1'b0; 
                                                localbus_state <= localbus_ack;
                                                case(localbus_addr[7:0]) 
                                                      8'h00: localbus_data_out <= UM2DDR_WDATA0; //读出上一次准备写入DDR2中的数据 
                                                      8'h01: localbus_data_out <= UM2DDR_WDATA1; 
                                                      8'h02: localbus_data_out <= UM2DDR_WDATA2; 
                                                      8'h03: localbus_data_out <= UM2DDR_WDATA3; 
                                                      8'h04: localbus_data_out <= UM2DDR_COMMAND0; //读出上一次写入DDR2中的命令 
                                                      8'h05: localbus_data_out <= UM2DDR_COMMAND1; 
                                                      8'h06: localbus_data_out <= UM2DDR_RDATA0;  //读出DDR2中的数据 
                                                      8'h07: localbus_data_out <= UM2DDR_RDATA1; 
                                                      8'h08: localbus_data_out <= UM2DDR_RDATA2; 
                                                      8'h09: localbus_data_out <= UM2DDR_RDATA3; 
                                                      //用户可在此添加更多DDR2间接寄存器
                                                      default:localbus_data_out <= 32'b0;
                                                endcase      
                                          end   
                                 else 
                                    begin 
                                          localbus_data_out <= 32'b0; 
                                          localbus_ack_n <= 1'b0; 
                                          localbus_state <= localbus_ack;                                  
                                    end 
                                    
                localbus_ack:    if(localbus_cs_n == 1'b1) 
                                          begin 
                                                localbus_ack_n <= 1'b1; 
                                                localbus_state <= localbus_idle; 
                                          end 
                                 else if(um2ddr_state == um2ddr_order)
                                          UM2DDR_COMMAND1 <= 32'h0; //清除DDR2启动位  
                  default:       begin 
                                          localbus_ack_n <= 1'b1; 
                                          localbus_state <= localbus_idle; 
                                          
                  end                                           
            endcase
      
      
      assign    um2ddr_wrclk = clk; 
      assign    um2ddr_rdclk = clk;
      
      
      /*UM2DDR接口 在这个模板中，DDR2接口是基于本地总线采用间址方式访问的。
      UM规范本身支持多字访问，出于简单化的原因，这里仅支持单字访问方式。
      如果用户需要长达127个字的连续DDR2访问，
      可以从外部端口基于以太网报文的方式读写数据。 
      UM2DDR_COMMAND1[2]是DDR2的访问启动位，1-开始，0-停止。
      这一位由本地总线写入并在DDR2访问开始后自动清0 。
      用户也可以定义另一个信号或另一种方式来启动和停止DDR2访问。 
      */
      	
always@(posedge clk or negedge reset)  
      if(!reset)  
            begin
                  um2ddr_command_wrreq <= 1'b0; 
                  um2ddr_command <= 34'b0; 
                  um2ddr_wrreq <= 1'b0; 
                  um2ddr_wdata <= 128'b0; 
                  um2ddr_valid_rdreq <= 1'b0; 
                  um2ddr_rdreq <= 1'b0; 
                  UM2DDR_RDATA0 <= 32'b0; 
                  UM2DDR_RDATA1 <= 32'b0; 
                  UM2DDR_RDATA2 <= 32'b0; 
                  UM2DDR_RDATA3 <= 32'b0; 
                  um2ddr_state <= um2ddr_idle;
            end 
      else
            case(um2ddr_state) 
                  um2ddr_idle: if(ddr2um_command_ready == 1'b1 && UM2DDR_COMMAND1[2] == 1'b1) //ddr2空闲而且本地总线发出了启动命令
                                    begin
                                          um2ddr_command_wrreq <= 1'b1; //写入命令 
                                          um2ddr_command <= {UM2DDR_COMMAND1[1:0],UM2DDR_COMMAND0[31:0]}; 
                                          um2ddr_state <= um2ddr_order;
                                    end
                  um2ddr_order: begin
                                    um2ddr_command_wrreq <= 1'b0;
                                    if(um2ddr_command[33]==1'b0 && ddr2um_data_ready==1'b1)
                                          begin
                                                um2ddr_wrreq <= 1'b1; //写入数据 
                                                um2ddr_wdata<={UM2DDR_WDATA3,UM2DDR_WDATA2,UM2DDR_WDATA1,UM2DDR_WDATA0}; //4 UM2DDR_WDATA = 1 um2ddr_wdata; 
                                                um2ddr_state <= um2ddr_write;
                                          end
                                     else       //准备读ddr2寄存器
                                          um2ddr_state <= um2ddr_valid_wait; //等待信息FIFO有效    
                  end   
                  um2ddr_write: begin
                                    um2ddr_wrreq <= 1'b0; 
                                    um2ddr_state <= um2ddr_idle;
                  end   
                  um2ddr_valid_wait: if(ddr2um_valid_empty == 1'b0) //信息FIFO输出有效 
                                          begin 
                                                um2ddr_valid_rdreq <= 1'b1;//读信息FIFO 
                                                um2ddr_state <= um2ddr_valid_read;
                                          end 
                  um2ddr_valid_read: begin 
                                          um2ddr_valid_rdreq <= 1'b0; 
                                          um2ddr_rdreq <= 1'b1; 
                                          um2ddr_state <= um2ddr_data_read;                        
                  end
                  um2ddr_data_read:  begin //4 UM2DDR_RDATA = 1 um2ddr_rdata; 
                                          um2ddr_rdreq <= 1'b0; 
                                          UM2DDR_RDATA0 <= ddr2um_rdata[31:0]; 
                                          UM2DDR_RDATA1 <= ddr2um_rdata[63:32]; 
                                          UM2DDR_RDATA2 <= ddr2um_rdata[95:64]; 
                                          UM2DDR_RDATA3 <= ddr2um_rdata[127:96]; 
                                          um2ddr_state <= um2ddr_idle; 
                  end                       
                  default:  begin
                  end                      
                                                                                            
            endcase                       	
		                        	
		                        	
		                        	
//使用与input2output_fifo 大小相同的FIFO缓存来自CDP input_ctrl的报文 
		
input2output_128_139    CDP2UM_DATA_FIFO( 
		        .aclr   (!reset), 
		        .clock  (clk), 
		        .data   (cdp2um_data), 
		        .rdreq  (cdp2um_data_rdreq), 
		        .wrreq  (cdp2um_data_valid), //数据开始往UM里面写的标志
		        .q      (cdp2um_data_q), 
		        .usedw  (cdp2um_data_usedw)                        	
		        );	
		                        	
		                        	
endmodule	