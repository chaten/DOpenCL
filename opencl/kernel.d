module opencl.kernel;
import opencl.c;
import opencl.cl_object;
import opencl.types;
import opencl.conv;

class Kernel :CLObject!(cl_kernel,KernelInfo) {
	this(cl_kernel kernel) {
		super(kernel);
	}
	override cl_int get_info(KernelInfo e,size_t size,void * ptr,size_t * size_ret){ 
		return clGetKernelInfo(to!cl_kernel(this),e,size,ptr,size_ret);
	}
	override cl_int release() {
		return clReleaseKernel(to!cl_kernel(this));
	}
}
