module opencl.event;
import opencl.c;
import opencl.error;
import opencl.context;
import opencl._get_info;
import core.thread;
struct Event {
  cl_event _event;
  alias _event this;
  mixin get_info;
  this(Context context) {
    cl_int err_code;
    _event = clCreateUserEvent(context,&err_code);
    throw_error(err_code);
  }
  this(cl_event event) {
    _event = event;
  }
  this(this) {
    throw_error(clRetainEvent(this));
  }
  ~this() {
    throw_error(clReleaseEvent(this));
  }
  void set_user_event_status(cl_int execution_status) {
    throw_error(clSetUserEventStatus(this,execution_status));
  }
  void set_callback(cl_int execution_status,void function(Event,cl_int) callback) {
  //Wrapper around a d function to make it easier to callback
  //This function is most likely to be called from a pthread or a windows thread, which are not
  //Scanned by the gc.
    throw_error(clSetEventCallback(this,execution_status,&_callback_func,callback));
  }
}
extern(System) void _callback_func(cl_event event,cl_int status,void * user_data) {
  void function(Event,cl_int) callback = cast(void function(Event,cl_int))user_data;
  callback(Event(event),status);
}
void wait_for_events(const Event [] events) {
  throw_error(clWaitForEvents(events.length,(cast(const cl_event [])events).ptr));
}
