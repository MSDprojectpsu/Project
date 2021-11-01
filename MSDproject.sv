module msdproject;

int debug,mem_references,ctime;
string mem_referencesname, scan_input;
logic [32:0] mem_address;
logic [1:0] opcode;

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
	end
end
endmodule