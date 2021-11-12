module msdproject;

string queue[$:16];

int j,i;
int debug,mem_references,ctime,stub;
string mem_referencesname, scan_input;
string str;
string q;
logic [32:0] mem_address;
logic [1:0] opcode;
longint unsigned cpu_cycles,b;

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
						while($fscanf(mem_references,"%d %d %h",ctime,opcode,mem_address)==3)
							begin
							$display("%d %d %h",ctime,opcode,mem_address);
							end
						
						end
				end
			$display("\n");	
	end
	
			mem_references = $fopen(mem_referencesname, "r");
				for(i=0;i<16;i++)
				begin
					b=cpu_cycles+i;
					$fgets(str,mem_references);
					q=str;
					queue.push_back(q);
					$display("%d=>queue[%0d] = %d",b,i ,queue[i]);
				end
		$display("QUEUE SIZE BEFORE REMOVAL%d",queue.size());
		$display("===================================");
		
		$value$plusargs("stub=%d", stub);	
		
end
		

initial
	begin
	$value$plusargs("tracemem_references=%s", mem_referencesname);
	cpu_cycles=0;
		mem_references = $fopen(mem_referencesname, "r");
		do begin
		
			cpu_cycles++;
		
		end while($fscanf(mem_references,"%d %d %h",ctime,opcode,mem_address)==3);
		
		$display("THE CPU CYCLES => %d",cpu_cycles);
		$display("===================================");
		
		
		if(stub==1 && debug==1 && cpu_cycles>=100)
			begin
				queue=queue[0:$-1];
				$display("REMOVING AN ITEM FROM THE QUEUE\n");
				
				foreach(queue[i])
					begin
						$display(" queue[%0d]=%d ",i ,queue[i]);
					end
				$display("=======================================");
				$display("QUEUE SIZE AFTER REMOVAL%d",queue.size());
			end
		else
			queue=queue;
	end
endmodule
