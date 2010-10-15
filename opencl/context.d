module opencl.context;
import opencl.c;
import opencl._auto_impl;
import opencl._error_handling;
import opencl._context_properties_list;
import opencl._conv;
import opencl.types;
public import opencl.platform_id;
public import opencl.device_id;
class Context {
	private cl_context _context;
	cl_context cl_type() {
		return _context;
	}
	this(cl_context context) {
		_context = context;
	}
	this(PlatformID platform,DeviceID [] device_ids) {
		ContextPropertiesList list;
		list.add(ContextProperties.PLATFORM,platform);
		cl_int err_code;
		_context = clCreateContext(list.ptr,device_ids.length,convert(device_ids).ptr,null,null,&err_code);
		handle_error(err_code);
	}
	~this() {
		handle_error(clReleaseContext(_context));
	}
	private cl_int context_info(ContextInfo c,size_t size,void * ptr,size_t * size_ret) {
		return clGetContextInfo(convert(this),convert(c),size,ptr,size_ret);
	}
	mixin(ExpandGetInfoFunction!(ContextInfo,"context_info")());
}
