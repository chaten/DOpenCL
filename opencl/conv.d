module opencl.conv;
import std.traits;
import opencl.cl_object;
static import std.conv;
template arrayTarget(T:T[]) {
	alias T arrayTarget;
}
template canConstruct(T,A...) if(is(T == class) || is(T == struct)) {
	bool canConstruct(A args) {
		static if(is(T == class)) {
			return __traits(compiles,new T(args));
		} else static if(is(T == struct)) {
			return __traits(compiles,T(args));
		}
	}
}
template to(T) {
	T to(A...)(A args) { 
		static if(__traits(compiles,std.conv.to!T(args))){
			return std.conv.to!T(args);
		} else {
			return toImpl!T(args);
		}
	}
}
T toImpl(T,S)(S source) if(is(S == struct) && S.sizeof == T.sizeof) {
	return cast(T)source;
}
T toImpl(T,S)(S source) if(is(T == struct) && canConstruct!(T,S)) {
	return T(source);
}
T toImpl(T,S)(S source) if(isImplicitlyConvertible!(T,S)) {
	return cast(T)source;
}
T toImpl(T,S)(S source) if(is(T == class) && is(typeof(T._cl_id) == S)) {
	return new T(source);
}
T toImpl(T,S)(S source) if(is(S == class) && is(T == typeof(S._cl_id))) {
	return source._cl_id;
}
T toImpl(T,S)(S source) if(isArray!(T) && isArray!(S)) {
	alias arrayTarget!T Target;
	Target[] t = new Target[source.length];
	foreach(i,s;source) {
		t[i] = to!Target(s);
	}
	return t;
}
