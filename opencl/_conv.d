module opencl._conv;
import std.traits;
import opencl.types;
import opencl.c;
import opencl.platform_id;
import opencl.device_id;
import opencl.context;
import opencl.mem_object;
import opencl.command_queue;
import opencl.program;
import opencl.kernel;
import opencl.image_format;
/*
template arrayTarget(T:T[]) {
	alias T arrayTarget;
}
template to(T) {
	T to(A...)(A args) { return toImpl!T(args);}
}
T toImpl(T,S)(S source) if({

}
auto convert(T)(T value) if(!isArray!(T)) {
	return _convertImpl!T(value);
}
auto convert(T)(T array)if(isArray!(T)) {
	alias typeof(convert(array[0])) R;
	R[] r_array = new R[array.length];
	foreach(i,ref r;r_array) {
		r = convert(array[i]);
	}
	return r_array;
}
private {
	R lambda(T,R)(T value) if(hasMember!(T,"cl_type")) {
		return value.cl_type();
	}
	R lambda(T,R)(T value) if(is(R == class) && !hasMember!(T,"cl_type")) {
		return new R(value);
	}
	R lambda(T,R)(T value) if(is(R == struct) && !hasMember!(T,"cl_type")) {
		return R(value);
	}
	R lambda(T,R)(T value) if(is(R == enum)||is(T == enum)) {
		return cast(R) value;
	}
	auto _convertImpl(T)(T value) {
		static if(__traits(compiles,value.cl_type())) {
			return value.cl_type();
		} else static if(isPointer!(T)){
			const string type = mixin(convert_types_variable(pointerTarget!(T).stringof));
			mixin(type ~ " val = void;");
			alias typeof(val) Type;
			return lambda!(T,Type)(value);
		} else {
			pragma(msg,T.stringof);
			const string type = mixin(convert_types_variable(T.stringof));
			mixin(type ~ " val = void;");
			alias typeof(val) Type;
			return lambda!(T,Type)(value);
			
		}
	}
}
*/
