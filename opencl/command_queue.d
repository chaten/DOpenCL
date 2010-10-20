module opencl.command_queue;

import opencl.c;
import opencl.cl_object;
import opencl.types;
import opencl.context;
import opencl.conv;
import opencl.kernel;
import opencl.image;
import opencl.event;
import opencl.buffer;
import opencl.mem_object;
import opencl._error_handling;
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
	Event enqueueNDRangeKernel(Kernel kernel,Event[] wait_list,const size_t [] global_work_size,const size_t [] local_work_size = null,const size_t[] global_work_offset = null) in {
		if(local_work_size != null)
			assert(global_work_size.length == local_work_size.length);
		if(global_work_offset != null) //As of OpenCL 1.1, it is invalid for the offset to be anything but null.
			assert(global_work_size.length == global_work_offset.length);
	} body { 
		cl_event event_ret;
		handle_error(clEnqueueNDRangeKernel(to!cl_command_queue(this),to!cl_kernel(kernel),global_work_size.length,global_work_size.ptr,local_work_size.ptr,global_work_offset.ptr,wait_list.length,(to!(cl_event[])(wait_list)).ptr,&event_ret));
		return to!Event(event_ret);
	}
	Event enqueueTask(Kernel kernel,Event[] wait_list = null) {
		cl_event event_ret;
		handle_error(clEnqueueTask(to!cl_command_queue(this),to!cl_kernel(kernel),wait_list.length,(to!(cl_event[])(wait_list)).ptr,&event_ret));
		return to!Event(event_ret);
	}
	//TODO: Native Kernels
	Event enqueueMarker(Event e){ 
		cl_event event_ret;
		handle_error(clEnqueueMarker(to!cl_command_queue(this),&event_ret));
		return to!Event(event_ret);
	}
	void enqueueWaitForEvents(Event[] wait_list){ 
		handle_error(clEnqueueWaitForEvents(to!cl_command_queue(this),wait_list.length,(to!(cl_event[])(wait_list)).ptr));
	}
	void enqueueBarrier() {
		handle_error(clEnqueueBarrier(to!cl_command_queue(this)));
	}
	void finish() { 
		handle_error(clFinish(to!cl_command_queue(this)));
	}
	void flush() { 
		handle_error(clFlush(to!cl_command_queue(this)));
	}
	Event enqueueReadBuffer(Buffer b,bool blocking_read,size_t offset,size_t size,void * ptr,Event[] wait_list = null) {
		cl_event event_ret;
		handle_error(clEnqueueReadBuffer(to!cl_command_queue(this),to!cl_mem(b),blocking_read,offset,size,ptr,wait_list.length,(to!(cl_event[])(wait_list)).ptr,&event_ret));
		return to!Event(event_ret);
	}
	Event enqueueWriteBuffer(Buffer b,bool blocking_write,size_t offset,size_t size,void * ptr,Event[] wait_list = null) {
		cl_event event_ret;
		handle_error(clEnqueueWriteBuffer(to!cl_command_queue(this),to!cl_mem(b),blocking_write,offset,size,ptr,wait_list.length,(to!(cl_event[])(wait_list)).ptr,&event_ret));
		return to!Event(event_ret);
	}
	Event enqueueCopyBuffer(Buffer src,Buffer dest,size_t src_offset,size_t dst_offset,size_t size,Event[] wait_list = null) {
		cl_event event_ret;
		handle_error(clEnqueueCopyBuffer(to!cl_command_queue(this),to!cl_mem(src),to!cl_mem(dest),src_offset,dst_offset,size,wait_list.length,(to!(cl_event[])(wait_list)).ptr,&event_ret));
		return to!Event(event_ret);
	}
	Event enqueueMapBuffer(Buffer b,bool blocking,MapFlags flags,size_t offset,size_t cb,out void * ptr,Event[] wait_list = null) {
		cl_int err_code;
		cl_event event_ret;
		ptr = clEnqueueMapBuffer(to!cl_command_queue(this),to!cl_mem(b),blocking,to!cl_map_flags(flags),offset,cb,wait_list.length,(to!(cl_event[])(wait_list)).ptr,&event_ret,&err_code);
		handle_error(err_code);
		return to!Event(event_ret);
	}
	//TODO enqueue{Map,Copy,Read,Write}Image
	Event enqueueUnmapMemObject(MemObject mem,void * ptr,Event[] wait_list = null) {
		cl_event event_ret;
		handle_error(clEnqueueUnmapMemObject(to!cl_command_queue(this),to!cl_mem(mem),ptr,wait_list.length,(to!(cl_event[])(wait_list)).ptr,&event_ret));
		return to!Event(event_ret);
	}
}
