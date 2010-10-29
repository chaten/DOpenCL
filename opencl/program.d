module opencl.program;
import opencl.cl_object;
import opencl.c;
import opencl.types;
import opencl.context;
import opencl.conv;
import opencl.kernel;
import opencl.device_id;
import opencl._error_handling;
import opencl._auto_impl;
import std.traits;
import std.string;
class Program :CLObject!(cl_program,ProgramInfo){
	this(cl_program program) {
		super(program);
	}
	/** Create a Program from Source **/
	this(Context ctx,string[] strings) {
                cl_int err_code;
                const(char) *[] c_strings = new const(char)*[strings.length];
                size_t [] lengths = new size_t[strings.length];
                foreach(i,string;strings) {
                        c_strings[i] = toStringz(string);
                        lengths[i] = string.length;
                }
                cl_program program = clCreateProgramWithSource(to!cl_context(ctx),c_strings.length,c_strings.ptr,lengths.ptr,&err_code);
                handle_error(err_code);
		this(program);
        }
	/** Create a Program from Binaries **/
        this(Context ctx,const (ubyte)[][] binaries,DeviceID [] devices,out opencl.types.Error [] status) in {
                assert(devices.length == binaries.length);
        } body {
                cl_int err_code;
                status = new opencl.types.Error[devices.length];
                size_t [] lengths = new size_t[binaries.length];
                const (ubyte)*[] binary_ptrs = new ubyte*[binaries.length];
                foreach(i,binary;binaries) {
                        binary_ptrs[i] = binary.ptr;
                        lengths[i] = binary.length;
                }
                cl_program program = clCreateProgramWithBinary(to!cl_context(ctx),devices.length,to!(cl_device_id[])(devices).ptr,lengths.ptr,binary_ptrs.ptr,cast(cl_int *)status.ptr,&err_code);
                handle_error(err_code);
		this(program);
        }
	override cl_int get_info(ProgramInfo e,size_t size,void * ptr,size_t * size_ret) {
		return clGetProgramInfo(to!(cl_program)(this),e,size,ptr,size_ret);
	}
	private cl_int build_info(DeviceID d,ProgramBuildInfo e,size_t size,void * ptr,size_t * size_ret) {
		//TODO: Fix,Currently only does the first device that this program is built for
		//TODO: Need to add a parameter to ExpandGetInfoFunction to allow for an extra parameter
		//TODO: In order to input the device.
		return clGetProgramBuildInfo(to!(cl_program)(this),to!(cl_device_id)(DEVICES()[0]),e,size,ptr,size_ret);
	}
	override cl_int release() { 
		return clReleaseProgram(to!(cl_program)(this));
	}
	Kernel createKernel(string kernel_name) {
		return new Kernel(this,kernel_name);
	}
	Kernel[] createAllKernels() {
		cl_uint num_kernels;
		handle_error(clCreateKernelsInProgram(to!cl_program(this),0,null,&num_kernels));
		cl_kernel[] kernels = new cl_kernel[num_kernels];
		handle_error(clCreateKernelsInProgram(to!cl_program(this),num_kernels,kernels.ptr,null));
		return to!(Kernel[])(kernels);
	}

	void build(string options = "") {
		build(DEVICES(),options);
	}
	void build(DeviceID[] devices,string options = "") {
		handle_error(clBuildProgram(to!cl_program(this),devices.length,to!(cl_device_id[])(devices).ptr,toStringz(options),null,null));
	}
/*	auto opDispatch(string d)(DeviceID device)if(hasMember!(typeof(this),toupper(d))&&!hasMember!(typeof(super),toupper(d))){
		string create_str() {
			return toupper(d) ~ "(device)";
		}
		return mixin(create_str());
	}
*/	mixin(ExpandGetInfoFunction!("build_info",ProgramBuildInfo,DeviceID));
}
