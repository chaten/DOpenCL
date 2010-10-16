module opencl._auto_impl;
import std.traits;
public import opencl.types;
import opencl._error_handling;
import opencl.platform_id;
import opencl.device_id;
import opencl.c;
import opencl._conv;
//A few cases for get_info.
//(A) can be an enum or a basic type, in which case nothing needs to be done as it is the same as the c abi
//(A) can be a class, in which case we need to get_info the type it corresponds to, and then convert that type to (A)
//(A) can be an array of any of the above.
//(A) can be a string, in which case we need to remove the last byte ('\0')

//Corresponds to enums and basic types. No conversion necessary
A get_info(A,E)(E e,cl_int delegate(E,size_t,void*,size_t *) info) if(!isArray!A && !is(A == class)) {
	A value;
	handle_error(info(e,A.sizeof,&value,null));
	return value;
}
//Corresponds to enums and basic types. No conversion necessary
A get_info(A,E)(E e,cl_int delegate(E,size_t,void*,size_t*) info) if(isArray!A && !is(arrayTarget!A == class)) {
	A a;
	alias typeof(*a.ptr) R;
	R[] value;
	size_t value_size;
	handle_error(info(e,0,null,&value_size));
	value = new R[value_size/R.sizeof];
	handle_error(info(e,value_size,value.ptr,null));
	return value;
}
//Corresponds to strings (duh!)
string get_info(A:string,E)(E e,cl_int delegate(E,size_t,void*,size_t*) info) {
	char[] value;
	size_t value_size;
	handle_error(info(e,0,null,&value_size));
	value = new char[value_size/char.sizeof];
	handle_error(info(e,value_size,value.ptr,null));
	return cast(immutable)value[0..value.length-1];
}
A get_info(A,E)(E e,cl_int delegate(E,size_t,void*,size_t*) info) if(is(A == class)||(isArray!A && is(arrayTarget!A == class))) {
	alias typeof(convert(A)) CType;
	CType val = get_info!(CType,E)(e,info);
	return convert(val);
}

string ExpandGetInfoFunction(T,string func)() if(is(T == enum)){
	string create_function(R)(T member) {
		string ret = "@property\n";
		const string member_str = name_of(member);
		ret ~= R.stringof ~ " " ~ member_str ~ "() {";
		ret ~= "return get_info!("~R.stringof~","~T.stringof~")("~T.stringof~"."~member_str~",&"~func~");}";
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

