module opencl.types;
import opencl.c;
import std.conv;
import std.ctype;
import std.intrinsic;
import std.string;
import std.typecons;
import std.typetuple;
//import opencl.conv;
private alias CL_DRIVER_VERSION CL_DEVICE_DRIVER_VERSION;
mixin(create_declarations());
private {
string create_declarations() {
  string[] cl_types = ["char","uchar","short","ushort","int","uint","long","ulong","float"];
  string[] d_types = ["byte","ubyte","short","ushort","int","uint","long","ulong","float"];
  string[] widths = ["2","3","4","8","16"];
  assert(cl_types.length == d_types.length);
  string decls;
  for(int i = 0;i<cl_types.length;i++) {
     foreach(width;widths) {
       decls ~= "alias " ~ d_types[i] ~ "[" ~ width ~ "] " ~ cl_types[i] ~ width ~";";
     }
  }
  return decls;
}
string camelcase_to_underscore(string name) {
	string ret;
	foreach(c;name) {
		if(isupper(c)) {
			ret ~= "_";
		}
		ret ~= tolower(c);
	}
	return ret;
}
string d_type_to_c_type(string name) {
	return "cl"~camelcase_to_underscore(name);
}
string create_cl_type_enum(string name,string prefix,string [] types...) { 
	string c_type = d_type_to_c_type(name);
	string[] cl_types = new string[types.length];
	foreach(i,type;types) {
		cl_types[i] = prefix ~ "_" ~ type;
	}
	string params;
	for(auto i = 0;i<types.length;i++) {
		params ~= "\"" ~ types[i] ~"\"," ~ cl_types[i];
		if(i < types.length-1) {
			params ~= ",";
		}
	}

	string ret = "enum "~name~": "~c_type~"{";
	foreach(i,type;types) {
		ret ~= type ~ "= cast("~c_type~")" ~ cl_types[i];
		if(i < types.length - 1) {
			ret ~= ",";
		}
	}
	ret ~= "}\n";
	//ret ~= create_enum_to_string_func(name,types);
	return ret;
}

string create_cl_type_bitfield(string name,string prefix,string [] types...) {
	string c_type = d_type_to_c_type(name);
	string[] cl_types = new string[types.length];
	foreach(i,type;types) {
		cl_types[i] = prefix ~  "_" ~ type;
	}
	string ret;
	ret ~= "struct "~name~"{\n";
	ret ~= "private "~c_type~" bitfield;\n";
	ret ~= "this("~c_type~" value) { bitfield = value;}";
	ret ~= c_type ~" clId() { return bitfield;}";
	foreach(i,type;types) {
		ret ~= "@property\n";
		ret ~= "static "~name~" "~type~"() { return "~name~"("~cl_types[i]~");}\n";
		ret ~= "bool is"~type~"() {\n";
		if(type == "ALL" || type == "NONE") ret ~= "return bitfield == "~ cl_types[i]~";}";
		else {
			ret ~= "return (bitfield & "~cl_types[i]~") > 0;}";
		}
	}
	ret ~= c_type ~" opCast(T:"~c_type~")() { return bitfield;}";
	ret ~= create_bitfield_to_string_func(name,prefix,types);
	ret ~= "}\n";
	return ret;
}
string create_bitfield_to_string_func(string name,string cl_name,string[] types) {
	string ret;
	ret ~= "string toString() {";
	ret ~= "string ret;";
	ret ~= "auto value = clId();";
	foreach(type;types) {
		if(type == "ALL" || type == "NONE") {
			ret ~= "if(is"~type~") return \""~type~"\";\n";
		} else {
			ret ~= "if(is"~type~") ret ~= \""~type~"|\";\n";
		}
	}
	//Remove the last | symbol
	ret ~= "if(ret.length > 0) return ret[0..ret.length-1];";
	ret ~= "else return ret;";
	ret ~= "}";
	ret ~= "string cannonicalString("~name~" value) {";
	ret ~= "return \""~name~".(\"~value.toString()~\")\";";
	ret ~= "}";
	return ret;
}

string create_enum_to_string_func(string name,string[] types) {
	string ret;
	ret ~= "string name_of("~name~" value) {";
	ret ~= "final switch (value) {";
	foreach(type;types) {
		ret ~= "case "~name~"."~type~": return \""~type~"\";\n";
	}
	ret ~= "}}";
	ret ~= "string full_name_of("~name~" value) {";
	ret ~= "final switch (value) {";
	foreach(type;types) {
		ret ~= "case "~name~"."~type~": return \""~name~"."~type~"\";\n";
	}
	ret ~= "}}";
	return ret;
}
string map_info_enums_to_types(E)(string[E] types) if(is(E == enum)) {
	string ret;
	foreach(key;types.keys) {
		ret ~= map_info_enum_to_type(key,types[key]);
	}
	return ret;
}
string map_info_enum_to_type(E)(E value,string type) if(is(E == enum)) {
	string ret;
	ret ~= "const string "~convert_info_variable(value)~" = \"" ~ type ~ "\";";
	return ret;
}
}//END PRIVATE
/*
string convert_types_variable(string name) {
	return "_types_var_" ~ name;
}
string create_type_variable(string name,string equals){ 
	return "const string "~convert_types_variable(name)~" = \"" ~ equals ~ "\";";
}
*/
string convert_info_variable(T)(T t) if(is(T == enum)){
	return "_info_var" ~ T.stringof ~ to!string(t);
}
/*
string toString(E)(E value) if (is(E == enum)) {
	foreach(s;__traits(allMembers,E)) {
		if(value == mixin(E.stringof ~"." ~ s)) return s;
	}
	assert(0);
}
*/
private alias cl_int cl_error;
mixin(create_cl_type_enum("Error","CL","SUCCESS","DEVICE_NOT_FOUND","DEVICE_NOT_AVAILABLE","COMPILER_NOT_AVAILABLE","MEM_OBJECT_ALLOCATION_FAILURE","OUT_OF_RESOURCES","OUT_OF_HOST_MEMORY","PROFILING_INFO_NOT_AVAILABLE","MEM_COPY_OVERLAP","IMAGE_FORMAT_MISMATCH","IMAGE_FORMAT_NOT_SUPPORTED","BUILD_PROGRAM_FAILURE","MAP_FAILURE","MISALIGNED_SUB_BUFFER_OFFSET","EXEC_STATUS_ERROR_FOR_EVENTS_IN_WAIT_LIST","INVALID_VALUE","INVALID_DEVICE_TYPE","INVALID_PLATFORM","INVALID_DEVICE","INVALID_CONTEXT","INVALID_QUEUE_PROPERTIES","INVALID_COMMAND_QUEUE","INVALID_HOST_PTR","INVALID_MEM_OBJECT","INVALID_IMAGE_FORMAT_DESCRIPTOR","INVALID_IMAGE_SIZE","INVALID_BINARY","INVALID_BUILD_OPTIONS","INVALID_PROGRAM","INVALID_PROGRAM_EXECUTABLE","INVALID_KERNEL_NAME","INVALID_KERNEL_DEFINITION","INVALID_KERNEL","INVALID_ARG_INDEX","INVALID_ARG_VALUE","INVALID_ARG_SIZE","INVALID_KERNEL_ARGS","INVALID_WORK_DIMENSION","INVALID_WORK_GROUP_SIZE","INVALID_WORK_ITEM_SIZE","INVALID_GLOBAL_OFFSET","INVALID_EVENT_WAIT_LIST","INVALID_EVENT","INVALID_OPERATION","INVALID_GL_OBJECT","INVALID_BUFFER_SIZE","INVALID_MIP_LEVEL","INVALID_GLOBAL_WORK_SIZE","INVALID_PROPERTY"));

mixin(create_cl_type_enum("PlatformInfo","CL_PLATFORM","PROFILE","VERSION","NAME","VENDOR","EXTENSIONS"));
mixin(map_info_enums_to_types!PlatformInfo([PlatformInfo.PROFILE:"string",PlatformInfo.VERSION:"string",PlatformInfo.NAME:"string",PlatformInfo.VENDOR:"string",PlatformInfo.EXTENSIONS:"string"]));
mixin(create_cl_type_bitfield("DeviceType","CL_DEVICE_TYPE","DEFAULT","CPU","GPU","ACCELERATOR","ALL"));

mixin(create_cl_type_enum("DeviceInfo","CL_DEVICE","TYPE","VENDOR_ID","MAX_COMPUTE_UNITS","MAX_WORK_ITEM_DIMENSIONS","MAX_WORK_GROUP_SIZE","MAX_WORK_ITEM_SIZES","PREFERRED_VECTOR_WIDTH_CHAR","PREFERRED_VECTOR_WIDTH_SHORT","PREFERRED_VECTOR_WIDTH_INT","PREFERRED_VECTOR_WIDTH_LONG","PREFERRED_VECTOR_WIDTH_FLOAT","PREFERRED_VECTOR_WIDTH_DOUBLE","MAX_CLOCK_FREQUENCY","ADDRESS_BITS","MAX_READ_IMAGE_ARGS","MAX_WRITE_IMAGE_ARGS","MAX_MEM_ALLOC_SIZE","IMAGE2D_MAX_WIDTH","IMAGE2D_MAX_HEIGHT","IMAGE3D_MAX_WIDTH","IMAGE3D_MAX_HEIGHT","IMAGE3D_MAX_DEPTH","IMAGE_SUPPORT","MAX_PARAMETER_SIZE","MAX_SAMPLERS","MEM_BASE_ADDR_ALIGN","MIN_DATA_TYPE_ALIGN_SIZE","SINGLE_FP_CONFIG","GLOBAL_MEM_CACHE_TYPE","GLOBAL_MEM_CACHELINE_SIZE","GLOBAL_MEM_CACHE_SIZE","GLOBAL_MEM_SIZE","MAX_CONSTANT_BUFFER_SIZE","MAX_CONSTANT_ARGS","LOCAL_MEM_TYPE","LOCAL_MEM_SIZE","ERROR_CORRECTION_SUPPORT","PROFILING_TIMER_RESOLUTION","ENDIAN_LITTLE","AVAILABLE","COMPILER_AVAILABLE","EXECUTION_CAPABILITIES","QUEUE_PROPERTIES","NAME","VENDOR","VERSION","PROFILE","DRIVER_VERSION","EXTENSIONS","PLATFORM","DOUBLE_FP_CONFIG","HALF_FP_CONFIG","PREFERRED_VECTOR_WIDTH_HALF","HOST_UNIFIED_MEMORY","NATIVE_VECTOR_WIDTH_CHAR","NATIVE_VECTOR_WIDTH_SHORT","NATIVE_VECTOR_WIDTH_INT","NATIVE_VECTOR_WIDTH_LONG","NATIVE_VECTOR_WIDTH_FLOAT","NATIVE_VECTOR_WIDTH_DOUBLE","NATIVE_VECTOR_WIDTH_HALF","OPENCL_C_VERSION"));
mixin(map_info_enums_to_types([DeviceInfo.ADDRESS_BITS:"cl_uint",DeviceInfo.AVAILABLE:"cl_bool",DeviceInfo.COMPILER_AVAILABLE:"cl_bool",DeviceInfo.DOUBLE_FP_CONFIG:"DeviceFpConfig",DeviceInfo.ENDIAN_LITTLE:"cl_bool",DeviceInfo.ERROR_CORRECTION_SUPPORT:"cl_bool",DeviceInfo.EXECUTION_CAPABILITIES:"DeviceExecCapabilities",DeviceInfo.EXTENSIONS:"string",DeviceInfo.GLOBAL_MEM_CACHE_SIZE:"cl_ulong",DeviceInfo.MAX_MEM_ALLOC_SIZE:"cl_ulong",DeviceInfo.GLOBAL_MEM_CACHE_TYPE:"DeviceMemCacheType",DeviceInfo.GLOBAL_MEM_CACHELINE_SIZE:"cl_uint",DeviceInfo.HALF_FP_CONFIG:"DeviceFpConfig",DeviceInfo.HOST_UNIFIED_MEMORY:"cl_bool",DeviceInfo.IMAGE_SUPPORT:"cl_bool",DeviceInfo.IMAGE2D_MAX_HEIGHT:"size_t",DeviceInfo.IMAGE2D_MAX_WIDTH:"size_t",DeviceInfo.GLOBAL_MEM_SIZE:"cl_ulong",DeviceInfo.IMAGE3D_MAX_DEPTH:"size_t",DeviceInfo.IMAGE3D_MAX_HEIGHT:"size_t",DeviceInfo.IMAGE3D_MAX_WIDTH:"size_t",DeviceInfo.LOCAL_MEM_SIZE:"cl_ulong",DeviceInfo.LOCAL_MEM_TYPE:"DeviceLocalMemType",DeviceInfo.MAX_CLOCK_FREQUENCY:"cl_uint",DeviceInfo.MAX_COMPUTE_UNITS:"cl_uint",DeviceInfo.MAX_CONSTANT_ARGS:"cl_uint",DeviceInfo.MAX_CONSTANT_BUFFER_SIZE:"cl_ulong",DeviceInfo.MAX_PARAMETER_SIZE:"size_t",DeviceInfo.MAX_READ_IMAGE_ARGS:"cl_uint",DeviceInfo.MAX_SAMPLERS:"cl_uint",DeviceInfo.MAX_WORK_GROUP_SIZE:"size_t",DeviceInfo.MAX_WORK_ITEM_DIMENSIONS:"cl_uint",DeviceInfo.MAX_WORK_ITEM_SIZES:"size_t[]",DeviceInfo.MAX_WRITE_IMAGE_ARGS:"cl_uint",DeviceInfo.MEM_BASE_ADDR_ALIGN:"cl_uint",DeviceInfo.MIN_DATA_TYPE_ALIGN_SIZE:"cl_uint",DeviceInfo.NAME:"string",DeviceInfo.NATIVE_VECTOR_WIDTH_CHAR:"cl_uint",DeviceInfo.NATIVE_VECTOR_WIDTH_SHORT:"cl_uint",DeviceInfo.NATIVE_VECTOR_WIDTH_INT:"cl_uint",DeviceInfo.NATIVE_VECTOR_WIDTH_LONG:"cl_uint",DeviceInfo.NATIVE_VECTOR_WIDTH_FLOAT:"cl_uint",DeviceInfo.NATIVE_VECTOR_WIDTH_DOUBLE:"cl_uint",DeviceInfo.NATIVE_VECTOR_WIDTH_HALF:"cl_uint",DeviceInfo.OPENCL_C_VERSION:"string",DeviceInfo.PLATFORM:"PlatformID",DeviceInfo.PREFERRED_VECTOR_WIDTH_CHAR:"cl_uint",DeviceInfo.PREFERRED_VECTOR_WIDTH_SHORT:"cl_uint",DeviceInfo.PREFERRED_VECTOR_WIDTH_INT:"cl_uint",DeviceInfo.PREFERRED_VECTOR_WIDTH_LONG:"cl_uint",DeviceInfo.PREFERRED_VECTOR_WIDTH_FLOAT:"cl_uint",DeviceInfo.PREFERRED_VECTOR_WIDTH_DOUBLE:"cl_uint",DeviceInfo.PREFERRED_VECTOR_WIDTH_HALF:"cl_uint",DeviceInfo.PROFILE:"string",DeviceInfo.PROFILING_TIMER_RESOLUTION:"size_t",DeviceInfo.QUEUE_PROPERTIES:"CommandQueueProperties",DeviceInfo.SINGLE_FP_CONFIG:"DeviceFpConfig",DeviceInfo.TYPE:"DeviceType",DeviceInfo.VENDOR:"string",DeviceInfo.VENDOR_ID:"cl_uint",DeviceInfo.VERSION:"string",DeviceInfo.DRIVER_VERSION:"string"]));

mixin(create_cl_type_bitfield("DeviceFpConfig","CL_FP","DENORM","INF_NAN","ROUND_TO_NEAREST","ROUND_TO_ZERO","ROUND_TO_INF","FMA","SOFT_FLOAT"));

mixin(create_cl_type_enum("DeviceMemCacheType","CL","NONE","READ_ONLY_CACHE","READ_WRITE_CACHE"));

mixin(create_cl_type_enum("DeviceLocalMemType","CL","LOCAL","GLOBAL"));

mixin(create_cl_type_bitfield("DeviceExecCapabilities","CL_EXEC","KERNEL","NATIVE_KERNEL"));

mixin(create_cl_type_bitfield("CommandQueueProperties","CL_QUEUE","OUT_OF_ORDER_EXEC_MODE_ENABLE","PROFILING_ENABLE"));

mixin(create_cl_type_enum("ContextInfo","CL_CONTEXT","REFERENCE_COUNT","DEVICES","PROPERTIES","NUM_DEVICES"));
mixin(map_info_enums_to_types([ContextInfo.REFERENCE_COUNT:"cl_uint",ContextInfo.DEVICES:"DeviceID[]",ContextInfo.PROPERTIES:"ContextProperties[]",ContextInfo.NUM_DEVICES:"cl_uint"]));

mixin(create_cl_type_enum("ContextProperties","CL_CONTEXT","PLATFORM"));

mixin(create_cl_type_enum("CommandQueueInfo","CL_QUEUE","CONTEXT","DEVICE","REFERENCE_COUNT","PROPERTIES"));
mixin(map_info_enums_to_types([CommandQueueInfo.CONTEXT:"Context",CommandQueueInfo.DEVICE:"DeviceID",CommandQueueInfo.REFERENCE_COUNT:"cl_uint",CommandQueueInfo.PROPERTIES:"CommandQueueProperties"]));

mixin(create_cl_type_bitfield("MemFlags","CL_MEM","READ_WRITE","WRITE_ONLY","READ_ONLY","USE_HOST_PTR","ALLOC_HOST_PTR","COPY_HOST_PTR"));

mixin(create_cl_type_enum("ChannelOrder","CL","R","A","RG","RA","RGB","RGBA","BGRA","ARGB","INTENSITY","LUMINANCE","Rx","RGx","RGBx"));

mixin(create_cl_type_enum("ChannelType","CL","SNORM_INT8","SNORM_INT16","UNORM_INT8","UNORM_INT16","UNORM_SHORT_565","UNORM_SHORT_555","UNORM_INT_101010","SIGNED_INT8","SIGNED_INT16","SIGNED_INT32","UNSIGNED_INT8","UNSIGNED_INT16","UNSIGNED_INT32","HALF_FLOAT","FLOAT"));

mixin(create_cl_type_enum("MemObjectType","CL_MEM_OBJECT","BUFFER","IMAGE2D","IMAGE3D"));

mixin(create_cl_type_enum("MemInfo","CL_MEM","TYPE","FLAGS","SIZE","HOST_PTR","MAP_COUNT","REFERENCE_COUNT","CONTEXT","ASSOCIATED_MEMOBJECT","OFFSET"));
mixin(map_info_enums_to_types([MemInfo.TYPE:"MemObjectType",MemInfo.FLAGS:"MemFlags",MemInfo.SIZE:"size_t",MemInfo.HOST_PTR:"void *",MemInfo.MAP_COUNT:"cl_uint",MemInfo.REFERENCE_COUNT:"cl_uint",MemInfo.CONTEXT:"Context",MemInfo.ASSOCIATED_MEMOBJECT:"MemObject",MemInfo.OFFSET:"size_t"]));

mixin(create_cl_type_enum("ImageInfo","CL_IMAGE","FORMAT","ELEMENT_SIZE","ROW_PITCH","SLICE_PITCH","WIDTH","HEIGHT","DEPTH"));
mixin(map_info_enums_to_types([ImageInfo.FORMAT:"ImageFormat",ImageInfo.ELEMENT_SIZE:"size_t",ImageInfo.ROW_PITCH:"size_t",ImageInfo.SLICE_PITCH:"size_t",ImageInfo.WIDTH:"size_t",ImageInfo.HEIGHT:"size_t",ImageInfo.DEPTH:"size_t"]));

mixin(create_cl_type_enum("AddressingMode","CL_ADDRESS","NONE","CLAMP_TO_EDGE","CLAMP","REPEAT","MIRRORED_REPEAT"));

mixin(create_cl_type_enum("FilterMode","CL_FILTER","NEAREST","LINEAR"));

mixin(create_cl_type_enum("SamplerInfo","CL_SAMPLER","REFERENCE_COUNT","CONTEXT","NORMALIZED_COORDS","ADDRESSING_MODE","FILTER_MODE"));
mixin(map_info_enums_to_types([SamplerInfo.REFERENCE_COUNT:"cl_uint",SamplerInfo.CONTEXT:"Context",SamplerInfo.ADDRESSING_MODE:"AddressingMode",SamplerInfo.FILTER_MODE:"FilterMode",SamplerInfo.NORMALIZED_COORDS:"cl_bool"]));

mixin(create_cl_type_bitfield("MapFlags","CL_MAP","READ","WRITE"));

mixin(create_cl_type_enum("ProgramInfo","CL_PROGRAM","REFERENCE_COUNT","CONTEXT","NUM_DEVICES","DEVICES","SOURCE","BINARY_SIZES","BINARIES"));
mixin(map_info_enums_to_types([ProgramInfo.REFERENCE_COUNT:"cl_uint",ProgramInfo.CONTEXT:"Context",ProgramInfo.NUM_DEVICES:"cl_uint",ProgramInfo.DEVICES:"DeviceID[]",ProgramInfo.SOURCE:"string",ProgramInfo.BINARY_SIZES:"size_t[]",ProgramInfo.BINARIES:"ubyte *[]"]));

mixin(create_cl_type_enum("ProgramBuildInfo","CL_PROGRAM_BUILD","STATUS","OPTIONS","LOG"));
mixin(map_info_enums_to_types([ProgramBuildInfo.STATUS:"BuildStatus",ProgramBuildInfo.OPTIONS:"string",ProgramBuildInfo.LOG:"string"]));

mixin(create_cl_type_enum("BuildStatus","CL_BUILD","SUCCESS","NONE","ERROR","IN_PROGRESS"));

mixin(create_cl_type_enum("KernelInfo","CL_KERNEL","FUNCTION_NAME","NUM_ARGS","REFERENCE_COUNT","CONTEXT","PROGRAM"));
mixin(map_info_enums_to_types([KernelInfo.FUNCTION_NAME:"string",KernelInfo.NUM_ARGS:"cl_uint",KernelInfo.REFERENCE_COUNT:"cl_uint",KernelInfo.CONTEXT:"Context",KernelInfo.PROGRAM:"Program"]));

mixin(create_cl_type_enum("KernelWorkGroupInfo","CL_KERNEL","WORK_GROUP_SIZE","COMPILE_WORK_GROUP_SIZE","LOCAL_MEM_SIZE","PREFERRED_WORK_GROUP_SIZE_MULTIPLE","PRIVATE_MEM_SIZE"));
mixin(map_info_enums_to_types([KernelWorkGroupInfo.WORK_GROUP_SIZE:"size_t",KernelWorkGroupInfo.COMPILE_WORK_GROUP_SIZE:"size_t[3]",KernelWorkGroupInfo.LOCAL_MEM_SIZE:"cl_ulong"]));

mixin(create_cl_type_enum("EventInfo","CL_EVENT","COMMAND_QUEUE","COMMAND_TYPE","REFERENCE_COUNT","COMMAND_EXECUTION_STATUS","CONTEXT"));
mixin(map_info_enums_to_types([EventInfo.COMMAND_QUEUE:"CommandQueue",EventInfo.COMMAND_TYPE:"CommandType",EventInfo.COMMAND_EXECUTION_STATUS:"CommandExecutionStatus",EventInfo.CONTEXT:"Context",EventInfo.REFERENCE_COUNT:"cl_uint"]));

mixin(create_cl_type_enum("CommandType","CL_COMMAND","NDRANGE_KERNEL","TASK","NATIVE_KERNEL","READ_BUFFER","WRITE_BUFFER","COPY_BUFFER","READ_IMAGE","WRITE_IMAGE","COPY_IMAGE","COPY_IMAGE_TO_BUFFER","COPY_BUFFER_TO_IMAGE","MAP_BUFFER","MAP_IMAGE","UNMAP_MEM_OBJECT","MARKER","ACQUIRE_GL_OBJECTS","RELEASE_GL_OBJECTS","READ_BUFFER_RECT","WRITE_BUFFER_RECT","COPY_BUFFER_RECT","USER"));

private alias cl_int cl_command_execution_status;
mixin(create_cl_type_enum("CommandExecutionStatus","CL","COMPLETE","RUNNING","SUBMITTED","QUEUED"));

mixin(create_cl_type_enum("BufferCreateType","CL_BUFFER_CREATE_TYPE","REGION"));

mixin(create_cl_type_enum("ProfilingInfo","CL_PROFILING_COMMAND","QUEUED","SUBMIT","START","END"));
mixin(map_info_enums_to_types([ProfilingInfo.QUEUED:"cl_ulong",ProfilingInfo.SUBMIT:"cl_ulong",ProfilingInfo.SUBMIT:"cl_ulong",ProfilingInfo.START:"cl_ulong",ProfilingInfo.END:"cl_ulong"]));
