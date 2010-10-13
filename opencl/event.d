module opencl.event;
import opencl.c;
import opencl.error;
import opencl.context;
import opencl._get_info;
import opencl._malloc;
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
}
void wait_for_events(const Event [] events) {
  throw_error(clWaitForEvents(events.length,(cast(const cl_event [])events).ptr));
}
