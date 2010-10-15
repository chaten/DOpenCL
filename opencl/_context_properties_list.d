module opencl._context_properties_list;
import opencl.types;
import opencl._conv;
import opencl.c;
struct ContextPropertiesList {
	cl_context_properties [] _list = [null];
	void add(T)(ContextProperties p,T val) {
		_list = [cast(cl_context_properties)convert(p),
		      cast(cl_context_properties)convert(val)] ~ _list;
	}

	cl_context_properties * ptr(){ 
		return _list.ptr;
	}
}

