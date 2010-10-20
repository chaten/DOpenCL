module opencl.platform_id;
import opencl.c;
import opencl.device_id;
import opencl._error_handling;
import opencl.types;
import opencl.cl_object;
import opencl.conv;
class PlatformID:CLObject!(cl_platform_id,PlatformInfo) {
	this(cl_platform_id id) {
		super(id);
	}
	static PlatformID[] all() {
		cl_uint num_platforms;
		cl_platform_id [] platforms;
		handle_error(clGetPlatformIDs(0,null,&num_platforms));
		platforms = new cl_platform_id[num_platforms];
		handle_error(clGetPlatformIDs(num_platforms,platforms.ptr,null));
		return to!(PlatformID[])(platforms);
	}
	override cl_int get_info(PlatformInfo e,size_t size,void * ptr,size_t * size_ret) {
		return clGetPlatformInfo(to!cl_platform_id(this),e,size,ptr,size_ret);
	}
	override cl_int release() { 
		return opencl.types.Error.SUCCESS;
	}
	DeviceID [] devices(DeviceType d = DeviceType.ALL) {
		cl_uint num_devices;
		handle_error(clGetDeviceIDs(to!cl_platform_id(this),to!cl_device_type(d),0,null,&num_devices));
		cl_device_id [] ret = new cl_device_id[num_devices];
		handle_error(clGetDeviceIDs(to!cl_platform_id(this),to!cl_device_type(d),num_devices,ret.ptr,null));
		return to!(DeviceID[])(ret);
	}
}
import std.traits;
import std.stdio;
unittest {
	PlatformID[] ids = PlatformID.all();
	foreach(i,id;ids) {
		writefln("\nPlatformID[%s]",i);
		foreach(member;EnumMembers!(PlatformInfo)) {
			writefln("%s: %s",to!string(member),mixin("id."~to!string(member)));
		}
	}
}
