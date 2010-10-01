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
import opencl._get_info;
import opencl.context;
import std.string;
import std.c.string;
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
  mixin get_info;
  private {
    cl_int delegate(size_t,A *,size_t *) info_delegate(A)(cl_program_info param_name) {
      return (size_t size,A *ptr,size_t * size_ret) { return clGetProgramInfo(this,param_name,size,ptr,size_ret);};
    }
    cl_int delegate(size_t,A *,size_t *) build_info_delegate(A)(DeviceID device,cl_program_build_info param_name) {
      return (size_t size,A * ptr,size_t * size_ret) { return clGetProgramBuildInfo(this,device,param_name,size,ptr,size_ret);};
    }
    T get_program_info(T)(cl_program_info param_name){
      return get_info(info_delegate!(T)(param_name));
    }
    T[] get_program_info_array(T)(cl_program_info param_name) {
      return get_info_array(info_delegate!(T)(param_name));
    }
    string get_program_info_string(cl_program_info param_name) {
      return get_info_string(info_delegate!(char)(param_name));
    }
    T get_program_build_info(T)(DeviceID device,cl_program_build_info param_name) {
      return get_info(build_info_delegate!(T)(device,param_name));
    }
    T[] get_program_build_info_array(T)(DeviceID device,cl_program_build_info param_name) {
      return get_info_array(build_info_delegate!(T)(device,param_name));
    }
    string get_program_build_info_string(DeviceID device,cl_program_build_info param_name) {
      return get_info_string(build_info_delegate!(char)(device,param_name));
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
    return get_program_info_array!(DeviceID)(CL_PROGRAM_DEVICES);
  }
  ///
  string source() {
    return get_program_info_string(CL_PROGRAM_SOURCE);
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
    return get_program_build_info_string(device,CL_PROGRAM_BUILD_LOG);
  }
  ///
  cl_build_status build_status(DeviceID device) {
    return get_program_build_info!(cl_build_status)(device,CL_PROGRAM_BUILD_STATUS);
  }
  ///
  string build_options(DeviceID device) {
    return get_program_build_info_string(device,CL_PROGRAM_BUILD_OPTIONS);
  }
}
