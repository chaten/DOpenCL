module opencl.cl_object;
import opencl.c;
import opencl._auto_impl;
import opencl.api;
import std.string;
import std.traits;
import std.stdarg;
import opencl._error_handling;
class CLObject(CLType,InfoTypes...) if(InfoTypes.length >= 1){
	alias _cl_id this;
	CLType _cl_id;
	CLType clId() {
		return _cl_id;
	}
	this(CLType cl_id) {
		_cl_id = cl_id;
	}
	~this(){ 
		handle_error(release());
	}
	/*
	auto opDispatch(string d)() if(hasMember!(typeof(this),toupper(d))) {
		string create_str(){ 
			return toupper(d) ~ "()";
		}
		return mixin(create_str());
	}*/
	protected abstract cl_int release();
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
