module opencl.program;
import opencl.cl_object;
import opencl.c;
import opencl.types;
import opencl.conv;
class Program :CLObject!(cl_program,ProgramInfo){
	this(cl_program program) {
		super(program);
	}
	override cl_int get_info(ProgramInfo e,size_t size,void * ptr,size_t * size_ret) {
		return clGetProgramInfo(to!(cl_program)(this),e,size,ptr,size_ret);
	}
}
