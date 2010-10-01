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
module opencl.platform_id;
import opencl.error;
import opencl.c;
import opencl._get_info;
import opencl.device_id;
import std.algorithm;
/***
 * Represents the ID of an OpenCL Platform
 * The default way to obtain a platform object is to use
 * get_all_platform_ids()
 */
struct PlatformID {
  cl_platform_id _id;
  alias _id this;
  ///
  this(cl_platform_id id) {
    _id = id;
  }
  mixin get_info;
  private {
    cl_int delegate(size_t,A *,size_t *) info_delegate(A)(cl_platform_info info) {
      return (size_t size,A * ptr,size_t * size_ret){return clGetPlatformInfo(this,info,size,ptr,size_ret);};
    }
    string get_str_info(cl_platform_info info) {
      return get_info_string(info_delegate!(char)(info));
    }
    DeviceID [] get_devices(cl_device_type type) {
      cl_uint num_devices;
      cl_device_id ids[];
      auto err_code = clGetDeviceIDs(this,type,0,null,&num_devices);
      throw_error(err_code);
      ids = new cl_device_id[num_devices];
      err_code = clGetDeviceIDs(this,type,cl_device_id.sizeof * num_devices,ids.ptr,null);
      throw_error(err_code);
      return cast(DeviceID[]) ids;
    }
  }
  ///
  string name() {
    return get_str_info(CL_PLATFORM_NAME);
  }
  ///
  string extensions() {
    return get_str_info(CL_PLATFORM_EXTENSIONS);
  }
  ///
  string my_version() {
    return get_str_info(CL_PLATFORM_VERSION);
  }
  ///
  string vendor() {
    return get_str_info(CL_PLATFORM_VENDOR);
  }
  ///
  string profile() {
    return get_str_info(CL_PLATFORM_PROFILE);
  }
  ///
  DeviceID [] all_devices() {
    return get_devices(CL_DEVICE_TYPE_ALL);
  }
  ///
  DeviceID [] gpu_devices() {
    return get_devices(CL_DEVICE_TYPE_GPU);
  }
  ///
  DeviceID [] cpu_devices() {
    return get_devices(CL_DEVICE_TYPE_CPU);
  }
  ///
  DeviceID [] accelerator_devices() {
    return get_devices(CL_DEVICE_TYPE_DEFAULT);
  }
}
/// Get all of the platforms available on this system
PlatformID[] get_all_platform_ids() {
  cl_uint num_platforms;
  auto err_code = clGetPlatformIDs(0,null,&num_platforms);
  throw_error(err_code);
  return get_platform_ids(num_platforms);
}
/// Get N platforms available on this system
PlatformID[] get_platform_ids(cl_uint num_platforms) {
  cl_platform_id cl_ids[] = new cl_platform_id[num_platforms];
  auto err_code = clGetPlatformIDs(num_platforms,cl_ids.ptr,&num_platforms);
  throw_error(err_code);
  PlatformID ids[] = new PlatformID[min(num_platforms,cl_ids.length)];
  foreach(i,id;ids) {
    ids[i] = PlatformID(cl_ids[i]);
  }
  return ids;
}
unittest {
  assert(get_platform_ids(1).length <= 1);
  assert(get_platform_ids(get_all_platform_ids().length + 2).length > 0);
}
unittest {
  assert(get_all_platform_ids().length > 0);
}
