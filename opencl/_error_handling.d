module opencl._error_handling;
import opencl.c;
import opencl.types;
void handle_error(cl_int err_code) {
	opencl.types.Error e = cast(opencl.types.Error) err_code;
	switch(e) {
		case opencl.types.Error.SUCCESS:
			break;
		default: 
			throw new Exception(full_name_of(e));
	}
}
