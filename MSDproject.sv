module msdproject(clk);

input logic clk;

string queue[$:15],temp_q[$:15];
longint unsigned temp_req_time[$] ,count=0,last_req_time, temp_q_store_count[$];
longint temp_operation[$], temp_address[$];
int j,i,a;
longint debug,mem_references,request_time,stub,q_size,r;
string mem_referencesname, scan_input;
string str,str1;
string q;
logic [32:0] mem_address,t;
logic [1:0] opcode;
longint unsigned cpu_cycles,b;
logic [2:0]Byte;
logic [5:3]Low_column;
logic [7:6]Bank_group;
logic [9:8]Bank;
logic [17:10]High_column;
logic [32:18]Row;

initial
begin
$value$plusargs("debug=%d", debug);
if($value$plusargs("tracemem_references=%s", mem_referencesname))
	begin
		mem_references = $fopen(mem_referencesname, "r");
			if (mem_references == 0 && debug==1) 
				begin	
					$display ("ERROR: mem_references input file is empty");
					
				end
				
			else
				begin
					if(debug==1)
						begin
						while($fscanf(mem_references,"%d %d %h",request_time,opcode,mem_address)==3)
							begin
							if(request_time<0)
								begin
								$display("ERROR:INVALID REQUEST TIME");
								$stop;
								end
							else if(opcode<0 && opcode>4)
								begin
								$display("ERROR:INVALID OPCODE"); 
								$stop;
								end
							else if(mem_address<0)
								begin
								$display("ERROR:INVALID MEMORY ADDRESS");
								$stop;
								end
							else if(mem_references>3)
								begin
								$display("ERROR:INVALID CONTENTS");
								$stop;
								end
							else
							$display("%d %d %h",request_time,opcode,mem_address);
							end
						
						end
				end
			$display("\n");	
	
	
	end
	
	mem_references = $fopen(mem_referencesname, "r");
	
	while(!$feof(mem_references))
	begin
		$fgets(str,mem_references);
		q=str;
		temp_q.push_back(q);
		
	end
	
	foreach(temp_q[i])
			begin
				$display("queue[%0d]=%d ",i,temp_q[i]);
				//$display("mem_address[%0d]= %b %b %b %b %b %b ",i ,Row,Low_column,Bank,Bank_group,High_column,Byte);
			end
	
	while($fscanf(mem_references,"%d %d %h",request_time,opcode,mem_address)==3)
	begin
	//r=request_time;

			temp_req_time.push_back(request_time);
			temp_operation.push_back(opcode);
			temp_address.push_back(mem_address);
	end
		
		$display("NO.OF ITEMS IN QUEUE BEFORE REMOVAL%d",temp_q.size());
		$display("//////////////////////////////////////////////////");
	
end
		
always@(posedge clk)
begin
	count++;	
end		

always@(posedge clk)
begin
	$value$plusargs("tracefile=%s", mem_referencesname);
	mem_references = $fopen(mem_referencesname, "r");
	
	if(debug==1 && temp_q.size()<17)
	begin
	while($fscanf(mem_references,"%d %d %h",request_time,opcode,mem_address)==3)
		begin
		
	Byte=mem_address[2:0];
	Low_column=mem_address[5:3];
	Bank_group=mem_address[7:6];
	Bank=mem_address[9:8];
	High_column=mem_address[17:10];
	Row=mem_address[32:18];	

		end
	end
	
end

always@(posedge clk)
begin
	$value$plusargs("tracefile=%s", mem_referencesname);
	mem_references = $fopen(mem_referencesname, "r");
	while($fscanf(mem_references,"%d %d %h",request_time,opcode,mem_address)==3)
	begin

	r=request_time;
	if(count == r+100)
	begin
			temp_q = temp_q[1:$];
			$display("REMOVING AN ITEM FROM THE QUEUE @ %d\n",count);
		
				$display("queue[%0d]=%d ",count,temp_q[i]);
					
			$display("//////////////////////////////////////////////");
			temp_q.push_back(q);
	end 
	end
	//$display("NO.OF ITEMS IN QUEUE AFTER REMOVAL%d",temp_q.size());
		
end 


endmodule
