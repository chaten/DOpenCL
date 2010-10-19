module opencl.kernel;
import opencl.c;
import opencl.cl_object;
import opencl.types;

class Kernel :CLObject!(cl_kernel,KernelInfo) {
	this(cl_kernel kernel) {
		super(kernel);
	}
	cl_int get_info(E:KernelInfo)(KernelInfo e,size_t size,void * ptr,size_t * size_ret){ 
		return clGetKernelInfo(convert(this),convert(e),size,ptr,size_ret);
	}
}
