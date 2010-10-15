module opencl.event;
import opencl.c;
class Event {
	cl_event _event;
	cl_event cl_type() {
		return _event;
	}
}
