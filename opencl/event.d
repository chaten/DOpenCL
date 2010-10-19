module opencl.event;
import opencl.c;
import opencl.types;
import opencl.cl_object;
class Event : CLObject!(cl_event,EventInfo) {
	this(cl_event event) {
		super(event);
	}
	cl_int get_info(E:EventInfo)(EventInfo e,size_t size,void * ptr,size_t * size_ret) {
		return clGetEventInfo(convert(this),convert(e),size,ptr,size_ret);
	}
}
