module opencl._auto_impl;
import std.traits;
public import opencl.types;
import opencl._error_handling;
import opencl.conv;
import std.stdio;
import opencl.platform_id;
import opencl.device_id;
import opencl.program;
import opencl.kernel;
import opencl.image_format;
import opencl.context;
import opencl.command_queue;
import opencl.mem_object;
import opencl.c;
import std.string;

template arrayTarget(T:T[]) {
	alias T arrayTarget;
}

//A few cases for get_info.
//(A) can be an enum or a basic type, in which case nothing needs to be done as it is the same as the c abi
//(A) can be a class, in which case we need to get_info the type it corresponds to, and then convert that type to (A)
//(A) can be an array of any of the above.
//(A) can be a string, in which case we need to remove the last byte ('\0')
A _get_info(A,E)(E e,cl_int delegate(E,size_t,void*,size_t *)info) if(isArray!A && is(arrayTarget!A == class)) {
	alias typeof(arrayTarget!A._cl_id) T;
	return to!A(_get_info!(T[],E)(e,info));
}
A _get_info(A,E)(E e,cl_int delegate(E,size_t,void*,size_t *)info) if(!isArray!A && is(A == class) && hasMember!(A,"_cl_id")) {
	alias typeof(A._cl_id) B;
	return to!A(_get_info!(B,E)(e,info));
}
//Corresponds to enums and basic types. No conversion necessary
A _get_info(A,E)(E e,cl_int delegate(E,size_t,void*,size_t *) info) if(!isArray!A && !is(A == class)) {
	A value;
	handle_error(info(e,A.sizeof,&value,null));
	return value;
}
//Corresponds to enums and basic types. No conversion necessary
A _get_info(A,E)(E e,cl_int delegate(E,size_t,void*,size_t*) info) if(isArray!A && !is(arrayTarget!A == class)) {
	alias arrayTarget!A D;
	D[] value;
	size_t value_size;
	handle_error(info(e,0,null,&value_size));
	value = new D[value_size/D.sizeof];
	handle_error(info(e,value_size,value.ptr,null));
	return value;
}
//Corresponds to strings (duh!)
string _get_info(A:string,E)(E e,cl_int delegate(E,size_t,void*,size_t*) info) {
	char[] value;
	size_t value_size;
	handle_error(info(e,0,null,&value_size));
	value = new char[value_size/char.sizeof];
	handle_error(info(e,value_size,value.ptr,null));
	return cast(immutable)value[0..value.length-1];
}
bool _get_info(A:bool,E)(E e,cl_int delegate(E,size_t,void *,size_t *) info) {
	return cast(bool)_get_info!(cl_bool,E)(e,info);
}
template ExpandGetInfoFunction(string func,T,R = void) if(is(T == enum)){
	string ExpandGetInfoFunction() {
		string func_name = func;
		string create_function(ReturnType)(T member) {
			string ret;
			string arg_list = "";
			string arg = "";
			static if(!is(R == void)) {
				arg = "val,";
				arg_list = R.stringof ~ " val";
			}
			ret ~= "@property\n";
			const string member_str = to!string(member);
			// ReturnType functionName(args) {
			ret ~= ReturnType.stringof ~ " " ~ member_str ~ "("~arg_list~"){";
			//auto arg_curry = delegate ReturnType(T,size_t,void*,size_t*) { return func(arg1,arg2,...);};
			ret ~= "auto arg_curry = delegate cl_int("~T.stringof~" a,size_t b,void* c,size_t* d) { return "~func~"("~arg~"a,b,c,d);};";
			//get_info!(ReturnType,Type)(Type.x,&function_name);
			ret ~= "return _get_info!("~ReturnType.stringof~","~T.stringof~")("~T.stringof~"."~member_str~",arg_curry);}";
			return ret;
		}
		string create_op_dispatch() {
			string arg_list = "";
			string arg = "";
			static if(!is(R == void)) {
				arg = "val";
				arg_list = R.stringof ~ " "~arg;
			}
			//TODO: opDispatch for super that doesn't depend on args
			return "import std.string;
				import std.traits;
				auto opDispatch(string func)() if(hasMember!(typeof(super),toupper(func))) {
					string create_str() { return toupper(func) ~ \"()\";}
					return mixin(create_str());
				}
				auto opDispatch(string func)("~arg_list~") 
				if(hasMember!(typeof(this),toupper(func)) && !hasMember!(typeof(super),toupper(func))) {
					string create_str() { return toupper(func) ~ \"("~arg~")\";}
					return mixin(create_str());
				}";
		}
		string ret;
		foreach(member;EnumMembers!(T)) {
			const string type = mixin(convert_info_variable(cast(T)member));
			mixin(type ~ " val = void;");
			alias typeof(val) Type;
			ret ~= create_function!Type(member);
		}
		string arg = "";
		static if(!is(R == void)) {
			arg = R.stringof ~ " val";
		}
		ret ~= create_op_dispatch();
		return ret;
	}
}
