module opencl.event;
import opencl.c;
import opencl.types;
import opencl.cl_object;
import opencl.conv;
import std.container;
import opencl._error_handling;
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
	/*
	void setCallback(cl_int on_status,shared void delegate(Event e,cl_int status) callback) {
		synchronized(callbacks) {
			callbacks.insert(callback);
			scope(failure) { callbacks.removeFront();}
			handle_error(clSetEventCallback(to!cl_event(this),on_status,&_callbackHandler,cast(void *)callback));
		}
	}
	void setCallback(cl_int on_status,void delegate(Event e,cl_int status,void * data) callback,void * data) {
		void callback_func(Event e,cl_int status) {
			callback(e,status,data);
		}
		setCallback(on_status,(Event e,cl_int status) { return callback(e,status,data);});
	}
	*/
	void setStatus(cl_int status) {
		handle_error(clSetUserEventStatus(to!cl_event(this),status));
	}
}
/+
private {
	class CallbackHandler {
		SList!(void delegate(Event e,cl_int status))

	}
	shared SList!(void delegate(Event e,cl_int status)) callbacks;
	extern(C) private void _callbackHandler(cl_event event,cl_int status,void * data) {
		synchronized(callbacks) {
			void delegate(Event e,cl_int status) callback = cast(void delegate(Event,cl_int)) data;
			foreach(i,saved_callbacks;callbacks) {
				if(saved_callbacks == callback) {
					callbacks.remove(i);
					break;
				}
			}
		}
		callback(to!Event(event),status);
	}
}
}
+/
void waitForEvents(const Event[] events) {
	handle_error(clWaitForEvents(events.length,(to!(cl_event[])(events)).ptr));
}
