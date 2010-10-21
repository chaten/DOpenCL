module test.samples;
import opencl.api;
import std.conv;
import std.stdio;
import std.traits;
import std.random;
import std.date;
//HelloWorld OpenCL
unittest {
	writeln("Running Sample 1: Hello World");
	scope(success) { writeln("Sample 1 Successful");}
	scope(failure) { writeln("Sample 1 Failed");}
	string kernel = import("sample1.clc");
	PlatformID [] ids = PlatformID.all();
	Context c = new Context(ids[0],ids[0].devices());
	CommandQueue queue = c.createCommandQueue(c.devices()[0]);
	Program p = c.createProgramWithSource([kernel]);
	p.build();
	char [] buffer = new char["Hello World\n".length];
	Buffer b = c.createBuffer(MemFlags.WRITE_ONLY | MemFlags.USE_HOST_PTR,buffer);
	Kernel k = p.createKernel("hello");
	k.setArg(0,b);
	queue.enqueueNDRangeKernel(k,[buffer.length]);
	queue.finish();
	write(to!string(buffer));
	assert(to!string(buffer) == "Hello World\n");
}
unittest {
	const size_t DATA_SIZE = 2^^14;
	writeln("Running Sample 2: Computing the Square of an Array");
	scope(success) { writeln("Sample 2 Successful");}
	scope(failure) { writeln("Sample 2 Failed");}
	string src = import("sample2.clc");
	PlatformID [] ids = PlatformID.all();
	Context ctx = new Context(ids[0],ids[0].devices());
        CommandQueue queue = ctx.createCommandQueue(ctx.devices()[0]);
	Program p = ctx.createProgramWithSource([src]);
	p.build();
	float[] data = new float[DATA_SIZE];
	float[] results = new float[DATA_SIZE];
	//Fill out data set with random float values
	Random random = rndGen();
	foreach(ref d;data) {
		d = cast(float) random.front();
		random.popFront();
	}
	Kernel k = p.createKernel("square");
	Buffer input = ctx.createBuffer(MemFlags.READ_ONLY | MemFlags.COPY_HOST_PTR,data);
	Buffer output = ctx.createBuffer(MemFlags.WRITE_ONLY,results.length*float.sizeof);
	k.setArg(0,input);
	k.setArg(1,output);
	Event run = queue.enqueueNDRangeKernel(k,[DATA_SIZE]);
	Event read = queue.enqueueReadBuffer(output,false,0,results,[run]);
	waitForEvents([run,read]);
	uint correct = 0;
	foreach(i,result;results) {
		if(data[i] ^^ 2 == results[i]) correct++;
	}
	scope(exit) { writefln("%d/%d correct",correct,DATA_SIZE);}
	assert(correct == DATA_SIZE);
}
template arrayTarget(T:T[]) {
	alias T arrayTarget;
}
unittest {
	const uint count = 1024^^2;
	const uint iterations = 100;
	const double min_error = 1e-7;
	string src = import("sample3.clc");
	PlatformID[] ids = PlatformID.all();
	Context ctx = new Context(ids[0],ids[0].devices());
	DeviceID device = ctx.devices()[0];
	CommandQueue queue = ctx.createCommandQueue(device);
	const uint max_workgroup_size = device.max_work_group_size();
	const uint max_groups = 64;
	const uint max_work_items = 64;
	void reduce(Type,uint channel)() {
		string type;
		static if(!isArray!Type) {
			type = Type.stringof;
		} else {
			type = arrayTarget!(Type).stringof~to!string(Type.length);
		}
		const size_t buffer_size = Type.sizeof * count;
		Type[] input_data = new Type[count];
		Random random = rndGen();
		for(int i = 0;i< count;i++) {
		 	static if(channel == 1) { 
				input_data[i] = random.front();
			} else {
				for(int j = 0;j<channel;j++) {
					input_data[i][j] = random.front();
					random.popFront();
				}
			}
		}
		Buffer input = ctx.createBuffer(MemFlags.READ_WRITE,buffer_size);
		Buffer partials = ctx.createBuffer(MemFlags.READ_WRITE,buffer_size);
		Buffer output = ctx.createBuffer(MemFlags.READ_WRITE,buffer_size);
		Event write = queue.enqueueWriteBuffer(input,false,0,buffer_size,input_data.ptr);
		size_t [] group_counts;
		size_t [] work_item_counts;
		uint [] operation_counts;
		uint [] entry_counts;
		int pass_count;
		create_reduction_pass_counts(count,max_workgroup_size,max_groups,max_work_items,pass_count,group_counts,work_item_counts,operation_counts,entry_counts);
		Buffer pass_swap;
		Buffer pass_input = output;
		Buffer pass_output = input;
		Kernel[] kernels = new Kernel[pass_count];
		for(int i = 0;i < pass_count;i++) {
			Program p = ctx.createProgramWithSource([src]);
			try {
				p.build("-D GROUP_SIZE="~to!string(group_counts[i])~" -D OPERATIONS="~to!string(operation_counts[i]));
			}catch(Exception) {
				writeln("Error building program: "~p.LOG());
				assert(false);
			}
			kernels[i] = p.createKernel("reduce_"~type);
		}
		for(int i = 0;i < pass_count;i++) {
			const size_t group_size = group_counts[i];
			const uint operations = operation_counts[i];
			const size_t local = work_item_counts[i];
			const size_t global = group_counts[i] * work_item_counts[i];
			const uint entries = entry_counts[i];
			writefln("Pass[%4d] Global[%4d] Local[%4d] Groups[%4d] WorkItems[%4d] Operations[%d] Entries[%d]",i,
					global,local,group_counts[i],work_item_counts[i],operations,entries);
			const size_t shared_size = Type.sizeof * channel * local * operations;
			pass_swap = pass_input;
			pass_input = pass_output;
			pass_output = pass_swap;
			kernels[i].setArg(0,pass_output);
			kernels[i].setArg(1,pass_input);
			kernels[i].setLocalArgSize(2,shared_size);
			kernels[i].setArg(3,entries);
			//After the first pass, use the partial sums for the next input values
			if(pass_input == input) pass_input = partials;
			queue.enqueueNDRangeKernel(kernels[i],[global],[local]);
		}
		queue.finish();
		//Start the timing loop and execute the kernel over several iterations
		writefln("Timing %d iterations of reduction with %d elements of type %s...",iterations,count,Type.stringof);
		void reduce() {
			for(int j = 0;j< iterations;j++) {
				for(int i = 0;i<pass_count;i++) {
					size_t global = group_counts[i] * work_item_counts[i];
					size_t local = work_item_counts[i];
					queue.enqueueNDRangeKernel(kernels[i],[global],[local]);
				}
			}
			queue.finish();
		}
		ulong[] times = benchmark!(reduce)(1);
		ulong ms = times[0];
		double sec = ms / 1000.0;
		writefln("Exec Time: %.2f ms", ms/cast(double)(iterations));
		writefln("Throughput: %.2f GB/sec",1e-9* buffer_size*Type.sizeof * iterations / sec);
		//TODO: Verify
	}
	void create_reduction_pass_counts(int count,int max_group_size,int max_groups,int max_work_items,ref int pass_count,ref size_t [] group_counts,ref size_t []work_item_counts,ref uint[] operation_counts,ref uint[] entry_counts) {
		//Here be dragons
		int work_items = (count < max_work_items *2)?count /2:max_work_items;
		if(count < 1) work_items = 1;
		int groups = count / (work_items * 2);
		groups = max_groups < groups ? max_groups : groups;
		int max_levels = 1;
		int s = groups;
		while(s > 1) {
			int my_work_items = (s < max_work_items *2)? s/2:max_work_items;
			s = s / (my_work_items *2);
			max_levels++;
		}
		group_counts = new size_t[max_levels];
		work_item_counts = new size_t[max_levels];
		operation_counts = new uint[max_levels];
		entry_counts = new uint[max_levels];
		pass_count = max_levels;
		group_counts[0] = groups;
		work_item_counts[0] = work_items;
		operation_counts[0] = 1;
		entry_counts[0] = count;
		if(max_group_size < work_items) {
			operation_counts[0] = work_items;
			work_item_counts[0] = max_group_size;
		}
		s = groups;
		int level = 1;
		while(s > 1) {
			int my_work_items = (s < max_work_items *2)?s/2:max_work_items;
			int my_groups = s / (my_work_items *2);
			groups = (max_groups < my_groups) ? max_groups: my_groups;
			group_counts[level] = my_groups;
			work_item_counts[level] = my_work_items;
			operation_counts[level] = 1;
			entry_counts[level] = s;
			if(max_group_size < my_work_items) {
				operation_counts[level] = my_work_items;
				work_item_counts[level] = max_group_size;
			}
			s = s / (my_work_items * 2);
			level++;
		}
	}
	writeln("Running Sample 3: Parallel Reduction");
	scope(success) { writeln("Sample 3 Successful");}
	scope(failure) { writeln("Sample 3 Failed");}
	reduce!(int,1);
	reduce!(int2,2);
	reduce!(int4,4);
	reduce!(float,1);
	reduce!(float2,2);
	reduce!(float4,4);
}
