module msdproject(clk);

input logic clk;

//queues
string queue[$:15];
longint unsigned temp_req_time[$:15],temp_q_store_count[$:15],temp_operation[$:15], temp_address[$:15],temp_q[$:15];

int j,i,a,outputfile,cyc=0,count;
longint unsigned debug,mem_references,request_time,stub,q_size,r,last_req_time;
string mem_referencesname, scan_input;
string str,str1,initial_request;
string q;
logic [32:0] mem_address,t;
logic [1:0] opcode;
longint unsigned cpu_cycles,b;

//Memory address split
logic [2:0]Byte;
logic [5:3]Low_column;
logic [7:6]Bank_group;
logic [9:8]Bank;
logic [17:10]High_column;
logic [32:18]Row;

event jab;
logic flag;

function void queuepop;

		queue.pop_front;
		
endfunction

function void queuepush;
	
	while(!$feof(mem_references))
	begin
			$fscanf(mem_references,"%d %d %h",request_time,opcode,mem_address);
			
			temp_req_time.push_back(request_time);
			temp_operation.push_back(opcode);
			temp_address.push_back(mem_address);
			
	end
		
endfunction


function void open_file;

		$value$plusargs("debug=%d", debug);
		if($value$plusargs("tracemem_references=%s", mem_referencesname))
		begin
		mem_references = $fopen(mem_referencesname, "r");
		//$display("%d This is one mem ref",mem_references);
		outputfile = $fopen("Output.txt","w");
		end
		
endfunction
	

initial
begin
	open_file();
			if (mem_references == 0 && debug==1) 
				begin	
					$display ("ERROR: Mem_references input file is empty");
					$stop;
					
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
								else
									begin
									$display("%d %d %h",request_time,opcode,mem_address);
									end
									
							end
							$display("//////////////////////////////////////////////////");
							
						end
				end
	end
									
									
always@(posedge clk)
begin
									
	open_file();
	count++;
	while($fscanf(mem_references,"%d %d %h",request_time,opcode,mem_address)==3)
	begin

	queuepush();

	//$display("%p",temp_req_time);
		foreach(temp_req_time[i])
			begin
				$display("%d queue[%0d]=%d ",i+1,i,temp_req_time[i]);
				//$display("mem_address[%0d]= %b %b %b %b %b %b ",i ,Row,Low_column,Bank,Bank_group,High_column,Byte);
			end
			
		foreach(temp_address[i])
			begin
				$display("%d queue[%0d]=%d ",i+1,i,temp_address[i]);
				//$display("mem_address[%0d]= %b %b %b %b %b %b ",i ,Row,Low_column,Bank,Bank_group,High_column,Byte);
			end
		foreach(temp_operation[i])
			begin
				$display("%d queue[%0d]=%d ",i+1,i,temp_operation[i]);
				//$display("mem_address[%0d]= %b %b %b %b %b %b ",i ,Row,Low_column,Bank,Bank_group,High_column,Byte);
			end
		
				
		
			
		
		
		if(temp_operation[1]==2)
				begin
				$display("GOT ");
					$fwrite(outputfile,"FETCH");
				//$display("mem_address[%0d]= %b %b %b %b %b %b ",i ,Row,Low_column,Bank,Bank_group,High_column,Byte);
			end
			
			end
		$display("\n");	
			
end
		
/*always@(posedge clk)
begin
	count++;	
	open_file();
	
	if(queue.size()==0)
	begin
		count=request_time;
	end
	
	if(count>=request_time && !$feof(mem_references) && temp_req_time.size()<16)
									begin
									queuepush();
									$display("%d request_time queue[%0d]=%d ",count,i,temp_req_time[i]);
									end
									
									foreach(temp_req_time[i])
			begin
				$display("%d request_time queue[%0d]=%d ",count,i,temp_req_time[i]);
				//$display("mem_address[%0d]= %b %b %b %b %b %b ",i ,Row,Low_column,Bank,Bank_group,High_column,Byte);
			end
end	*/	


/*always@(posedge clk)
begin

	open_file();
	
		do
		begin
			if (not QueueFull) // then see if there's a request we can add¬
				begin
				if (not HavePendingRequest)
					begin
					if (not EndOfFile(TraceFile))
						begin
						if (Request = ReadNextLine(TraceFile)) successful)¬
						HavePendingRequest = true; 
						else if (not EndOfFile(TraceFile))¬
							begin
							Error("Syntax error"); // provide line number and context¬
							$stop;
							end
						end
					end

				if (HavePendingRequest)
					begin
						if (QueueEmpty) // no need to just increment ticks if queue is empty¬
							if (count < Request.Time)
							count = Request.Time; 

						if (count >= Request.Time) // or count could have been advanced by ++¬
						begin
							InsertInQueue(Request);
							HavePendingRequest = false;
						end
					end
				end

		if (not QueueEmpty)
		MagicHappensHere();

		count++;

		end
		while (not QueueEmpty || HavePendingRequest || not EndOfFile(TraceFile));
	end
	
/*always@(posedge clk)
begin

	//open_file();
	//$sscanf(mem_references,"%d %d %h",request_time,opcode,mem_address);
	begin
	
	r=request_time;
	$display("%d",r);
	if(count == r+100)
	begin
			queuepop();
			flag=1;
			$display("REMOVING AN ITEM FROM THE QUEUE @ %d",count);
			$display("=====================================");
			
			//queuepush();
			//$display("queue[%0d]=%d ",count,temp_q[i]);
	end 
	
	if(temp_q.size()<16 )
			begin
			
			$sscanf(temp_q,"%d %d %h",request_time,opcode,mem_address);
			$display("Inseretd->queue[%0d]=%d\n ",count,temp_q[i]);
			end
	end
	
	
	if(debug == 1 && temp_q.size()<17)
		begin
		//initial_request=temp_q[0];
		$sscanf(initial_request,"%d %d %h",request_time,opcode,mem_address);
		
		Byte=mem_address[2:0];
		Low_column=mem_address[5:3];
		Bank_group=mem_address[7:6];
		Bank=mem_address[9:8];
		High_column=mem_address[17:10];
		Row=mem_address[32:18];	
	
		$display(" %d  WRITE  %h %h %h %h %h %h \n",count,Row,Low_column,Bank,Bank_group,High_column,Byte);
		cyc++;
		if(opcode == 1)
		begin
		//$display("%d",opcode);
		$fwrite(outputfile,"  %d  WRITE  %h %h %h %h %h %h \n",count,Row,Low_column,Bank,Bank_group,High_column,Byte);
	
		end
		end
		//$sscanf(initial_request,"%d %d %h",request_time,opcode,mem_address);
end*/

endmodule
