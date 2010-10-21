module opencl.buffer;
import opencl.mem_object;
import opencl.types;
import opencl.context;
import opencl.c;
import std.traits;
import opencl.conv;
import opencl._error_handling;
class Buffer : MemObject {
	this(cl_mem mem) {
		super(mem);
		assert(TYPE() == MemObjectType.BUFFER);
	}
	this(Context ctx,MemFlags flags,size_t size,void * ptr) {
		cl_int err_code;
		cl_mem buffer = clCreateBuffer(to!cl_context(ctx),to!cl_mem_flags(flags),size,ptr,&err_code);
		handle_error(err_code);
		this(buffer);
	}
}
