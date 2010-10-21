module opencl.kernel;
import opencl.c;
import opencl.cl_object;
import opencl.types;
import opencl.conv;
import opencl.sampler;
import opencl.mem_object;
import opencl.program;
import std.string;
import std.traits;
import opencl._error_handling;
class Kernel :CLObject!(cl_kernel,KernelInfo) {
	this(cl_kernel kernel) {
		super(kernel);
	}
	this(Program p,string kernel_name) {
		cl_int err_code;
		cl_kernel kernel = clCreateKernel(to!cl_program(p),toStringz(kernel_name),&err_code);
		handle_error(err_code);
		this(kernel);
	}
	void setArg(T)(cl_uint arg_index,T arg) if(!isArray!(T)) {
		handle_error(clSetKernelArg(to!cl_kernel(this),arg_index,arg.sizeof,&arg));
	}
	void setArg(T:Sampler)(cl_uint arg_index,T arg) {
		cl_sampler_t b = to!cl_sampler_t(arg);
		setArg(arg_index,b);
	}
	void setArg(T:MemObject)(cl_uint arg_index,T mem) {
		cl_mem b = to!cl_mem(mem);
		setArg(arg_index,b);
	}
	void setLocalArgSize(cl_uint arg_index,size_t size) {
		handle_error(clSetKernelArg(to!cl_kernel(this),arg_index,size,null));
	}
	override cl_int get_info(KernelInfo e,size_t size,void * ptr,size_t * size_ret){ 
		return clGetKernelInfo(to!cl_kernel(this),e,size,ptr,size_ret);
	}
	override cl_int release() {
		return clReleaseKernel(to!cl_kernel(this));
	}
}
