module opencl.cl_object;
import opencl.c;
import opencl._auto_impl;
import opencl.api;
class CLObject(CLType,InfoTypes...) if(InfoTypes.length >= 1){
	alias _cl_id this;
	CLType _cl_id;
	CLType clId() {
		return _cl_id;
	}
	this(CLType cl_id) {
		_cl_id = cl_id;
	}
	private final static string create_abstract_get_infos() {
		string ret;
		foreach(type;InfoTypes) {
			ret ~= "protected abstract cl_int get_info("~type.stringof~" e,size_t size,void* data,size_t * size_ret);";
		}
		return ret;
	}
	mixin(create_abstract_get_infos());
	mixin(ExpandGetInfoFunction!("get_info",InfoTypes));
}
