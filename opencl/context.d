module opencl.context;
import opencl.c;
import opencl._context_properties_list;
import opencl.types;
import opencl.conv;
import opencl.cl_object;
import opencl.api;
import std.traits;
import opencl._error_handling;
import std.string:toStringz;
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
	override cl_int release() {
		return clReleaseContext(to!cl_context(this));
	}
	override cl_int get_info(ContextInfo c,size_t size,void * ptr,size_t * size_ret) {
		return clGetContextInfo(to!cl_context(this),c,size,ptr,size_ret);
	}
	Program createProgramWithSource(string[] strings) {
		return new Program(this,strings);
	}
	Program createProgramWithBinary(const (ubyte)[][] binaries,DeviceID [] devices,out opencl.types.Error [] status) {
		return new Program(this,binaries,devices,status);
	}
	CommandQueue createCommandQueue(DeviceID id,CommandQueueProperties p = CommandQueueProperties(0)) {
		return new CommandQueue(this,id,p);
	}
	Buffer createBuffer(T)(MemFlags flags,T size) if(isIntegral!(T)) {
		return new Buffer(this,flags,size,null);
	}
	Buffer createBuffer(T)(MemFlags flags,T array)if(isArray!(T)) {
		alias arrayTarget!T Target;
		return new Buffer(this,flags,Target.sizeof * array.length,array.ptr);
	}
}
