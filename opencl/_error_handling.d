module opencl._error_handling;
import opencl.c;
import opencl.types;
import opencl.conv;
void handle_error(cl_int err_code) {
	opencl.types.Error e = cast(opencl.types.Error) err_code;
	switch(e) {
		case opencl.types.Error.SUCCESS:
			break;
		default:
			//TODO: Create an exception for each type of error
			throw new Exception("Error."~to!string(e));
	}
}
