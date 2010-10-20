module opencl.command_queue;

import opencl.c;
import opencl.cl_object;
import opencl.types;
import opencl.context;
import opencl.conv;
class CommandQueue : CLObject!(cl_command_queue,CommandQueueInfo){
	this(cl_command_queue queue) {
		super(queue);
	}
	override cl_int get_info(CommandQueueInfo e,size_t size,void * ptr,size_t * size_ret) {
		return clGetCommandQueueInfo(to!(cl_command_queue)(this),e,size,ptr,size_ret);
	}
	override cl_int release() {
		return clReleaseCommandQueue(to!cl_command_queue(this));
	}
}
