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

import DOpenCL.raw;
struct DeviceID {
  cl_device_id _device_id;
  alias _device_id this;
  this(cl_device_id my_device_id) {
    _device_id = my_device_id;
  }
  private {
    T device_scalar_info(T)(cl_device_info param_name) {
      T param_value;
      auto err_code = clGetDeviceInfo(this,param_name,T.sizeof,&param_value,null);
      assert(err_code == CL_SUCCESS);
      return param_value;
    }
    T[] device_array_info(T)(cl_device_info param_name) {
      T[] param_value;
      size_t param_value_size_ret;
      auto err_code = clGetDeviceInfo(this,param_name,T.sizeof,null,&param_value_size_ret);
      assert(err_code == CL_SUCCESS);
      param_value = new T[param_value_size_ret];
      err_code = clGetDeviceInfo(this,param_name,T.sizeof * param_value_size_ret,param_value.ptr,null);
      assert(err_code == CL_SUCCESS);
      return param_value;
    }
  }
  cl_uint address_bits() {
    cl_uint ret;
    auto err_code = clGetDeviceInfo(this,CL_DEVICE_ADDRESS_BITS,ret.sizeof,&ret,null);
    assert(CL_SUCCESS == err_code);
    return ret;
  }
  bool available() {
    cl_bool ret;
    auto err_code = clGetDeviceInfo(this,CL_DEVICE_AVAILABLE,ret.sizeof,&ret,null);
    assert(CL_SUCCESS == err_code);
    return ret == CL_TRUE;
  }
  bool compiler_available() {
    cl_bool ret;
    auto err_code = clGetDeviceInfo(this,CL_DEVICE_COMPILER_AVAILABLE,ret.sizeof,&ret,null);
    assert(CL_SUCCESS == err_code);
    return ret == CL_TRUE;
  }/*
  cl_device_fp_config double_fp_config() {
    cl_device_fp_config ret;
    auto err_code = clGetDeviceInfo(this,CL_DEVICE_DOUBLE_FP_CONFIG,ret.sizeof,&ret,null);
    assert(CL_SUCCESS == err_code);
    return ret;
  }*/
  bool is_little_endian() {
    cl_bool ret;
    auto err_code = clGetDeviceInfo(this,CL_DEVICE_ENDIAN_LITTLE,ret.sizeof,&ret,null);
    assert(CL_SUCCESS == err_code);
    return ret == CL_TRUE;
  }
  bool has_ecc() {
    cl_bool ret;
    auto err_code = clGetDeviceInfo(this,CL_DEVICE_ERROR_CORRECTION_SUPPORT,ret.sizeof,&ret,null);
    assert(CL_SUCCESS == err_code);
    return ret == CL_TRUE;
  }
  cl_device_exec_capabilities execution_capabilities() {
    cl_device_exec_capabilities ret;
    auto err_code = clGetDeviceInfo(this,CL_DEVICE_EXECUTION_CAPABILITIES,ret.sizeof,&ret,null);
    assert(CL_SUCCESS == err_code);
    return ret;
  }
  string extensions() {
    char [] extensions;
    size_t extensions_len;
    auto err_code = clGetDeviceInfo(this,CL_DEVICE_EXTENSIONS,extensions.sizeof,null,&extensions_len);
    assert(CL_SUCCESS == err_code);
    extensions = new char[extensions_len];
    err_code = clGetDeviceInfo(this,CL_DEVICE_EXTENSIONS,char.sizeof*extensions_len,extensions.ptr,null);
    assert(CL_SUCCESS == err_code);
    return cast(immutable)extensions;
  }
  cl_ulong global_mem_cache_size() {
    cl_ulong ret;
    auto err_code = clGetDeviceInfo(this,CL_DEVICE_GLOBAL_MEM_CACHE_SIZE,ret.sizeof,&ret,null);
    assert(err_code == CL_SUCCESS);
    return ret;
  }
  cl_device_mem_cache_type global_mem_cache_type() {
    cl_device_mem_cache_type type;
    auto err_code = clGetDeviceInfo(this,CL_DEVICE_GLOBAL_MEM_CACHE_TYPE,type.sizeof,&type,null);
    assert(err_code == CL_SUCCESS);
    return type;
  }
  cl_uint global_mem_cacheline_size() {
    cl_uint ret;
    auto err_code = clGetDeviceInfo(this,CL_DEVICE_GLOBAL_MEM_CACHELINE_SIZE,ret.sizeof,&ret,null);
    assert(err_code == CL_SUCCESS);
    return ret;
  }
  cl_ulong global_mem_size() {
    cl_ulong ret;
    auto err_code = clGetDeviceInfo(this,CL_DEVICE_GLOBAL_MEM_SIZE,ret.sizeof,&ret,null);
    assert(err_code == CL_SUCCESS);
    return ret;
  }
 /* cl_device_fp_config half_fp_config() {
    cl_device_fp_config ret;
    auto err_code = clGetDeviceInfo(this,CL_DEVICE_HALF_FP_CONFIG,ret.sizeof,&ret,null);
    assert(err_code == CL_SUCCESS);
    return ret;
  } */
  bool has_image_support() {
    cl_bool ret;
    auto err_code = clGetDeviceInfo(this,CL_DEVICE_IMAGE_SUPPORT,ret.sizeof,&ret,null);
    assert(err_code == CL_SUCCESS);
    return ret == CL_TRUE;
  }
  //TODO: Image height,width,ect
  cl_ulong local_mem_size() {
    cl_ulong ret;
    auto err_code = clGetDeviceInfo(this,CL_DEVICE_LOCAL_MEM_SIZE,ret.sizeof,&ret,null);
    assert(err_code == CL_SUCCESS);
    return ret;
  }
  cl_device_local_mem_type local_mem_type() {
    cl_device_local_mem_type ret;
    auto err_code = clGetDeviceInfo(this,CL_DEVICE_LOCAL_MEM_TYPE,ret.sizeof,&ret,null);
    assert(err_code == CL_SUCCESS);
    return ret;
  }

  /* TODO: Implement get device info */
}
