module opencl.buffer;
import opencl.mem_object;
import opencl.types;
import opencl.c;
class Buffer : MemObject {
	this(cl_mem mem) {
		super(mem);
		auto t = TYPE();
		if(t != MemObjectType.BUFFER) throw new Exception("Mem Object must be of type Buffer");
	}

}
