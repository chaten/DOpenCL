module opencl.platform_id;
import opencl.c;
import opencl._auto_impl;
import opencl._conv;
import opencl._error_handling;
import opencl.types;
mixin(create_type_variable("_cl_platform_id","PlatformID"));
class PlatformID {
	private cl_platform_id _id;
	cl_platform_id cl_type() {
		return _id;
	}
	this(cl_platform_id id) {
		_id = id;
	}
	static PlatformID[] all() {
		cl_uint num_platforms;
		cl_platform_id [] platforms;
		handle_error(clGetPlatformIDs(0,null,&num_platforms));
		platforms = new cl_platform_id[num_platforms];
		handle_error(clGetPlatformIDs(num_platforms,platforms.ptr,null));
		return convert(platforms);
	}
	private cl_int platform_info(PlatformInfo e,size_t size,void * ptr,size_t * size_ret) {
		return clGetPlatformInfo(convert(this),convert(e),size,ptr,size_ret);
	}
	DeviceID [] devices(DeviceType d = DeviceType.ALL) {
		cl_uint num_devices;
		handle_error(clGetDeviceIDs(convert(this),convert(d),0,null,&num_devices));
		cl_device_id [] ret = new cl_device_id[num_devices];
		handle_error(clGetDeviceIDs(convert(this),convert(d),num_devices,ret.ptr,null));
		return convert(ret);
	}
	mixin(ExpandGetInfoFunction!(PlatformInfo,"platform_info"));
}
