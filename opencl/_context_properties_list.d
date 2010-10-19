module opencl._context_properties_list;
import opencl.types;
import opencl.conv;
import opencl.c;
struct ContextPropertiesList {
	cl_context_properties [] _list = [0];
	void add(T)(ContextProperties p,T val){
		_list = [p,cast(cl_context_properties)(val)] ~ _list;
	}

	cl_context_properties * ptr(){ 
		return _list.ptr;
	}
}

