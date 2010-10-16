module opencl.device_id;
import std.traits;
import std.stdio;
import opencl.c;
import opencl.types;
import opencl._error_handling;
import opencl._conv;
import opencl.platform_id;
import opencl._auto_impl;
mixin(create_type_variable("_cl_device_id","DeviceID"));
class DeviceID {
	cl_device_id _id;
	cl_device_id cl_type() {
		return _id;
	}
	this(cl_device_id id) {
		_id = id;
	}
	private cl_int device_info(DeviceInfo e,size_t size,void * ptr,size_t * size_ret) {
		return clGetDeviceInfo(convert(this),convert(e),size,ptr,size_ret);
	}
	mixin(ExpandGetInfoFunction!(DeviceInfo,"device_info")());
}

unittest {
	writeln("Running DeviceID tests");
	//Print out every field
	PlatformID platform = PlatformID.all()[0];
	DeviceID[] ids = platform.devices();
	foreach(id;ids) {
		foreach(member;EnumMembers!(DeviceInfo)) {
			writefln("%s: %s",name_of(member),mixin("id."~name_of(member)));
		}
	}
}
