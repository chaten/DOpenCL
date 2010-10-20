module opencl.device_id;
import std.traits;
import std.stdio;
import opencl.c;
import opencl.types;
import opencl._error_handling;
import opencl.conv;
import opencl.cl_object;
class DeviceID :CLObject!(cl_device_id,DeviceInfo) {
	this(cl_device_id id) {
		super(id);
	}
	override cl_int release() {
		return opencl.types.Error.SUCCESS;
	}
	override cl_int get_info(DeviceInfo e,size_t size,void * ptr,size_t * size_ret) {
		return clGetDeviceInfo(to!cl_device_id(this),e,size,ptr,size_ret);
	}
}
version(unittest) { import opencl.platform_id;}

unittest {
	writeln("Running DeviceID tests");
	//Print out every field
	PlatformID platform = PlatformID.all()[0];
	DeviceID[] ids = platform.devices();
	foreach(i,id;ids) {
		writefln("\nDeviceID[%s/%s]",i,ids.length-1);
		foreach(member;EnumMembers!(DeviceInfo)) {
			auto val = mixin("id."~to!string(member));
			string print_val;
			static if(is(typeof(val) == enum) || is(typeof(val) == struct)) {
				print_val = to!string(val);
			} else static if(is(typeof(val) == PlatformID)) {
				print_val = val.NAME();
			}else {
				print_val = to!(string)(val);
			}
			writefln("%s: %s",to!string(member),print_val);
		}
	}
}
