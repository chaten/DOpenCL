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
import opencl.error;
import opencl.c;
import opencl.context;
import std.string;
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
      lengths[i] = str.length + 1;
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
  void build() {
    build("");
  }
  void build(in string options) {
    build(cast(cl_device_id[])null,options);
  }
  void build(in cl_device_id device_list[],in string options) {
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
    cl_uint ret;
    auto err_code = clGetProgramInfo(this,CL_PROGRAM_NUM_DEVICES,ret.sizeof,&ret,null);
    throw_error(err_code);
    return ret;
  }
  ////
  DeviceID[] devices() {
    cl_device_id * device_ids;
    size_t device_ids_len;
    auto err_code = clGetProgramInfo(this,CL_PROGRAM_DEVICES,device_ids.sizeof,&device_ids,&device_ids_len);
    DeviceID ret[] = new DeviceID[device_ids_len];
    for(auto i = 0;i<device_ids_len;i++) {
      ret[i] = DeviceID(device_ids[i]);
    }
    return ret;
  }
  ///
  string source() {
    char * src;
    size_t src_len;
    auto err_code = clGetProgramInfo(this,CL_PROGRAM_SOURCE,src.sizeof,&src,&src_len);
    throw_error(err_code);
    char ret[] = new char[src_len];
    for(int i=0;*src != '\0';i++) {
      ret[i] = *(src++);
    }
    return cast(immutable)ret;
  }
  ///
  string build_log(DeviceID device) {
    char * log;
    size_t log_len;
    auto err_code = clGetProgramBuildInfo(this,device,CL_PROGRAM_BUILD_LOG,
    						log.sizeof,&log,&log_len);
    char ret[] = new char[log_len];
    for(int i = 0;*log != '\0';i++) {
      ret[i] = *(log++);
    }
    return cast(immutable)ret;
  }
  ///
  cl_build_status build_status(DeviceID device) {
    cl_build_status status;
    auto err_code = clGetProgramBuildInfo(this,device,CL_PROGRAM_BUILD_STATUS,
    				status.sizeof,&status,null);
    throw_error(err_code);
    return status;
  }
  ///
  string build_options(DeviceID device) {
    char * options;
    size_t options_len;
    auto err_code =  clGetProgramBuildInfo(this,device,CL_PROGRAM_BUILD_OPTIONS
    					,options.sizeof,&options,&options_len);
    throw_error(err_code);
    char ret[] = new char[options_len];
    for(int i = 0;*options != '\0';i++) {
      ret[i] = *(options++);
    }
    return cast(immutable)ret;
  }
}
