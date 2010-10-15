module opencl._error_handling;
import opencl.c;
import opencl.types: Error,toString;
void handle_error(cl_int err_code) {
	Error e = cast(Error) err_code;
	switch(e) {
		case Error.SUCCESS:
			break;
		default: 
			throw new Exception(toString(e));
	}
}
