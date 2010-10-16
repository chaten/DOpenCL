module opencl._auto_impl;
import std.traits;
public import opencl.types;
import opencl._error_handling;
import opencl.platform_id;
import opencl.device_id;
import opencl.c;
A get_info(A,E)(E e,cl_int delegate(E,size_t size,void * ptr,size_t * size_ret) info) if(!isArray!A) {
	A value;
	handle_error(info(e,A.sizeof,&value,null));
	return value;
}
A get_info(A,E)(E e,cl_int delegate(E,size_t size,void * ptr,size_t * size_ret) info) if(isArray!A) {
	A a;
	alias typeof(*a.ptr) R;
	R[] value;
	size_t value_size;
	handle_error(info(e,0,null,&value_size));
	value = new R[value_size/R.sizeof];
	handle_error(info(e,value_size,value.ptr,null));
	return value;
}
string get_info(A:string,E)(E e,cl_int delegate(E,size_t size,void * ptr,size_t * size_ret) info) {
	char[] value;
	size_t value_size;
	handle_error(info(e,0,null,&value_size));
	value = new char[value_size/char.sizeof];
	handle_error(info(e,value_size,value.ptr,null));
	return cast(immutable)value[0..value.length-1];
}
string ExpandGetInfoFunction(T,string func)() if(is(T == enum)){
	string create_function(R)(T member) {
		string ret = "@property\n";
		const string member_str = toString(member);
		ret ~= R.stringof ~ " " ~ member_str ~ "() {";
		ret ~= "return get_info!("~R.stringof~","~T.stringof~")("~T.stringof~"."~toString(member)~",&"~func~");}";
		return ret;
	}
	string ret;
	foreach(member;EnumMembers!(T)) {
		const string type = mixin(convert_info_variable(cast(T)member));
		mixin(type ~ " val = void;");
		alias typeof(val) Type;
		ret ~= create_function!Type(member);
	}
	return ret;
}

