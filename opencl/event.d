module opencl.event;
import opencl.c;
import opencl.types;
import opencl.cl_object;
import opencl.conv;
class Event : CLObject!(cl_event,EventInfo) {
	this(cl_event event) {
		super(event);
	}
	override cl_int release() {
		return clReleaseEvent(to!cl_event(this));
	}
	override cl_int get_info(EventInfo e,size_t size,void * ptr,size_t * size_ret) {
		return clGetEventInfo(to!cl_event(this),e,size,ptr,size_ret);
	}
}
