module opencl._conv;
import std.traits;
import opencl.types;
import opencl.c;
import opencl.platform_id;
import opencl.device_id;
import std.stdio;
auto convert(T)(T value) if(!isArray!(T)) {
	return _convertImpl!T(value);
}
auto convert(T)(T array)if(isArray!(T)) {
	auto first = convert(array[0]);
	alias typeof(first) R;
	R[] r_array = new R[array.length];
	r_array[0] = first;
	foreach(i,ref r;r_array[1..array.length]) {
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
			const string type = mixin(convert_types_variable(T.stringof));
			mixin(type ~ " val = void;");
			alias typeof(val) Type;
			return lambda!(T,Type)(value);
			
		}
	}
}
