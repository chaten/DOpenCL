/*
   Copyright 2010 Michael Chaten

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.                                  
*/
/***
 * License: Apache 2.0
 */
module opencl.program;
import opencl.kernel;
import opencl.error;
import opencl.c;
import opencl.context;
import std.string;
import std.stdio;
import std.c.string;
import std.c.stdio;
import opencl.device_id;
/***
 * Represents an OpenCL Program Object
 */
struct Program {
  cl_program _program;
  alias _program this;
  /***
   * Create a program with the given source strings
   */
  this(Context context,in string[] strings) {
    cl_int err_code;
    const(char)* c_strings[] = new const(char)*[strings.length];
    size_t lengths[] = new size_t[strings.length];
    foreach(i,str;strings) {
      c_strings[i] = toStringz(str);
      lengths[i] = strlen(c_strings[i]);
      printf("C Strings[%d]: %s",i,c_strings[i]);
    }
    _program = clCreateProgramWithSource(context,strings.length,c_strings.ptr,
    					lengths.ptr,&err_code);
    throw_error(err_code);
    delete c_strings;
    delete lengths;
  }
  ///
  this(cl_program program) {
    _program = program;
  }
  this(this) {
    clRetainProgram(this);
  }
  ~this() {
    clReleaseProgram(this);
  }
  private {
    T get_program_info(T)(cl_program_info param_name){
      T param_value;
      auto err_code = clGetProgramInfo(this,param_name,T.sizeof,&param_value,null);
      throw_error(err_code);
      return param_value;
    }
    T[] get_program_info_array(T)(cl_program_info param_name) {
      T[] param_value;
      size_t param_value_len;
      auto err_code = clGetProgramInfo(this,param_name,0,null,&param_value_len);
      throw_error(err_code);
      param_value = new T[param_value_len];
      err_code = clGetProgramInfo(this,param_name,T.sizeof * param_value_len,param_value.ptr,null);
      throw_error(err_code);
      return param_value;
    }
    T get_program_build_info(T)(DeviceID device,cl_program_build_info param_name) {
      T param_value;
      auto err_code = clGetProgramBuildInfo(this,device,param_name,T.sizeof,&param_value,null);
      throw_error(err_code);
      return param_value;
    }
    T[] get_program_build_info_array(T)(DeviceID device,cl_program_build_info param_name) {
      T[] param_value;
      size_t param_value_len;
      auto err_code = clGetProgramBuildInfo(this,device,param_name,0,null,&param_value_len);
      throw_error(err_code);
      param_value = new T[param_value_len];
      err_code = clGetProgramBuildInfo(this,device,param_name,T.sizeof * param_value_len,param_value.ptr,null);
      throw_error(err_code);
      return param_value;
    }
  }
  void build() {
    build("");
  }
  void build(in string options) {
    build(cast(cl_device_id[])null,options);
  }
  void build(in cl_device_id device_list[],in string options) 
  in {

  } out {
    foreach(ref device;devices()) {
      assert(build_status(device) == CL_BUILD_SUCCESS);
    }
  }
  body {
    cl_int err_code;
    if(device_list == null) {
      err_code = clBuildProgram(this,0,null,toStringz(options),null,null);
    } else {
      err_code = clBuildProgram(this,device_list.length,
    			device_list.ptr,toStringz(options),null,null);
    }
    writefln("err_code %s",err_code); 
    throw_error(err_code);
  }
  ///
  void build(in DeviceID device_list[],in string options) {
    build(cast(const cl_device_id[])device_list,options);
  }
  ///
  cl_uint num_devices() {
    return get_program_info!(cl_uint)(CL_PROGRAM_NUM_DEVICES);
  }
  ////
  DeviceID[] devices() {
    return cast(DeviceID[])get_program_info_array!(cl_device_id)(CL_PROGRAM_DEVICES);
  }
  ///
  string source() {
    return cast(immutable)get_program_info_array!(char)(CL_PROGRAM_SOURCE);
  }
  Kernel [] kernels() {
    cl_uint num_kernels;
    auto err_code = clCreateKernelsInProgram(this,0,null,&num_kernels);
    throw_error(err_code);
    Kernel [] kernels = new Kernel[num_kernels];
    err_code = clCreateKernelsInProgram(this,num_kernels,cast(cl_kernel *)kernels.ptr,null);
    throw_error(err_code);
    return kernels;
  }
  ///
  string build_log(DeviceID device) {
    return cast(immutable)get_program_build_info_array!(char)(device,CL_PROGRAM_BUILD_LOG);
  }
  ///
  cl_build_status build_status(DeviceID device) {
    return get_program_build_info!(cl_build_status)(device,CL_PROGRAM_BUILD_STATUS);
  }
  ///
  string build_options(DeviceID device) {
    return cast(immutable)get_program_build_info_array!(char)(device,CL_PROGRAM_BUILD_OPTIONS);
  }
}
