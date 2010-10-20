module opencl.mem_object;
import opencl.types;
import opencl.cl_object;
import opencl.conv;
import opencl.c;
class MemObject:CLObject!(cl_mem,MemInfo) {
	this(cl_mem mem) {
		super(mem);
	}
	override cl_int get_info(MemInfo e,size_t size,void * ptr,size_t * size_ret) {
		return clGetMemObjectInfo(to!cl_mem(this),e,size,ptr,size_ret);
	}
	override cl_int release() {
		return clReleaseMemObject(to!cl_mem(this));
	}
}
