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
module opencl.context;
import opencl.error;
import opencl.c;
import opencl.platform_id;
import std.stdio;
import opencl._get_info;
import opencl.device_id;
/***
  Represents an OpenCL context
 */
struct Context {
  cl_context _context;
  alias _context this;
  mixin get_info;
  /***
  */
  this(ref cl_context_properties properties[],cl_device_type device_type) {
    cl_int err_code;
    _context = clCreateContextFromType(properties.ptr,device_type,null,null,
    		&err_code);
    throw_error(err_code);
  }
  /***
  */
  this(ref cl_context_properties properties[],in cl_device_id devices[]) {
    cl_int err_code;
    _context = clCreateContext(properties.ptr,devices.length,devices.ptr,null,null,&err_code);
    throw_error(err_code);
  }
  this(PlatformID platform,in cl_device_id devices[]) {
    cl_int err_code;
    cl_context_properties []properties = create_context_properties(platform);
    _context = clCreateContext(properties.ptr,devices.length,devices.ptr,null,null,&err_code);
    throw_error(err_code);
  }
  this(PlatformID platform,cl_device_type device_type) { 
    cl_int err_code;
    cl_context_properties [] properties = create_context_properties(platform);
    _context = clCreateContextFromType(properties.ptr,device_type,null,null,&err_code);
    throw_error(err_code);
  }
  this(this) {
    throw_error(clRetainContext(this));
  }
  /***
   * Create me from an exist OpenCL context
   */
  this(cl_context my_context) {
    _context = my_context;
  }
  ~this() {
    throw_error(clReleaseContext(this));
  }
  private cl_int delegate(size_t,A *,size_t *) info_delegate(A)(cl_context_info param_name) {
    return (size_t size,A * ptr,size_t * size_ret) { return clGetContextInfo(this,param_name,size,ptr,size_ret);};
  }
  /***
   * Get the number of devices that this context has
   */
  cl_uint num_devices() {
    return get_info(info_delegate!(cl_uint)(CL_CONTEXT_NUM_DEVICES));
  }
  /***
   * Get all of the devices this context has
   */
  DeviceID[] device_ids() {
    return get_info_array(info_delegate!(DeviceID)(CL_CONTEXT_DEVICES));
  }
  /* TODO: context properties */
}
cl_context_properties[] create_context_properties(PlatformID platform) {
  cl_context_properties[] properties = new cl_context_properties[3];
  properties[0] = cast(cl_context_properties)CL_CONTEXT_PLATFORM;
  properties[1] = cast(cl_context_properties)platform._id;
  properties[2] = null;
  return properties;
}
