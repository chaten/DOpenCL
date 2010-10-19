module opencl.context;
import opencl.c;
import opencl._context_properties_list;
import opencl.types;
import opencl.conv;
import opencl.cl_object;
import opencl.api;
import opencl._error_handling;
class Context:CLObject!(cl_context,ContextInfo) {
	this(cl_context context) {
		super(context);
	}
	this(PlatformID platform,DeviceID [] device_ids) {
		ContextPropertiesList list;
		list.add(ContextProperties.PLATFORM,to!cl_platform_id(platform));
		cl_int err_code;
		auto context = clCreateContext(list.ptr,device_ids.length,to!(cl_device_id[])(device_ids).ptr,null,null,&err_code);
		handle_error(err_code);
		this(context);
	}
	~this() {
		handle_error(clReleaseContext(_cl_id));
	}
	override cl_int get_info(ContextInfo c,size_t size,void * ptr,size_t * size_ret) {
		return clGetContextInfo(to!cl_context(this),c,size,ptr,size_ret);
	}
}
