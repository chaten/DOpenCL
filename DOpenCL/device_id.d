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
module DOpenCL.device_id;
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
    return device_scalar_info!(cl_uint)(CL_DEVICE_ADDRESS_BITS);
  }
  bool available() {
    return device_scalar_info!(cl_bool)(CL_DEVICE_AVAILABLE) == CL_TRUE;
  }
  bool compiler_available() {
    return device_scalar_info!(cl_bool)(CL_DEVICE_COMPILER_AVAILABLE) == CL_TRUE;
  }
  cl_device_fp_config double_fp_config() {
    return device_scalar_info!(cl_device_fp_config)(CL_DEVICE_DOUBLE_FP_CONFIG);
  }
  bool is_little_endian() {
    return device_scalar_info!(cl_bool)(CL_DEVICE_ENDIAN_LITTLE) == CL_TRUE;
  }
  bool has_ecc() {
    return device_scalar_info!(cl_bool)(CL_DEVICE_ERROR_CORRECTION_SUPPORT) == CL_TRUE;
  }
  cl_device_exec_capabilities execution_capabilities() {
    return device_scalar_info!(cl_device_exec_capabilities)(CL_DEVICE_EXECUTION_CAPABILITIES);
  }
  string extensions() {
    return cast(immutable)device_array_info!(char)(CL_DEVICE_EXTENSIONS);
  }
  cl_ulong global_mem_cache_size() {
    return device_scalar_info!(cl_ulong)(CL_DEVICE_GLOBAL_MEM_CACHE_SIZE);
  }
  cl_device_mem_cache_type global_mem_cache_type() {
    return device_scalar_info!(cl_device_mem_cache_type)(CL_DEVICE_GLOBAL_MEM_CACHE_TYPE);
  }
  cl_uint global_mem_cacheline_size() {
    return device_scalar_info!(cl_uint)(CL_DEVICE_GLOBAL_MEM_CACHELINE_SIZE);
  }
  cl_ulong global_mem_size() {
    return device_scalar_info!(cl_ulong)(CL_DEVICE_GLOBAL_MEM_SIZE);
  }
  cl_device_fp_config half_fp_config() {
    return device_scalar_info!(cl_device_fp_config)(CL_DEVICE_HALF_FP_CONFIG);
  } 
  bool has_image_support() {
    return device_scalar_info!(cl_bool)(CL_DEVICE_IMAGE_SUPPORT) == CL_TRUE;
  }
  size_t image2d_max_height() {
    return device_scalar_info!(size_t)(CL_DEVICE_IMAGE2D_MAX_HEIGHT);
  }
  size_t image2d_max_width() {
    return device_scalar_info!(size_t)(CL_DEVICE_IMAGE2D_MAX_WIDTH);
  }
  size_t image3d_max_depth() {
    return device_scalar_info!(size_t)(CL_DEVICE_IMAGE3D_MAX_DEPTH);
  }
  size_t image3d_max_height() {
    return device_scalar_info!(size_t)(CL_DEVICE_IMAGE3D_MAX_HEIGHT);
  }
  size_t image3d_max_width() {
    return device_scalar_info!(size_t)(CL_DEVICE_IMAGE3D_MAX_WIDTH);
  }
  cl_ulong local_mem_size() {
    return device_scalar_info!(cl_ulong)(CL_DEVICE_LOCAL_MEM_SIZE);
  }
  cl_device_local_mem_type local_mem_type() {
    return device_scalar_info!(cl_device_local_mem_type)(CL_DEVICE_LOCAL_MEM_TYPE);
  }
  cl_uint max_clock_frequency() {
    return device_scalar_info!(cl_uint)(CL_DEVICE_MAX_CLOCK_FREQUENCY);
  }
  cl_uint max_compute_units() {
    return device_scalar_info!(cl_uint)(CL_DEVICE_MAX_COMPUTE_UNITS);
  }
  cl_uint max_constant_args() {
    return device_scalar_info!(cl_uint)(CL_DEVICE_MAX_CONSTANT_ARGS);
  }
  cl_ulong max_constant_buffer_size() {
    return device_scalar_info!(cl_ulong)(CL_DEVICE_MAX_CONSTANT_BUFFER_SIZE);
  }
  cl_ulong max_mem_alloc_size() {
    return device_scalar_info!(cl_ulong)(CL_DEVICE_MAX_MEM_ALLOC_SIZE);
  }
  size_t max_parameter_size() {
    return device_scalar_info!(size_t)(CL_DEVICE_MAX_PARAMETER_SIZE);
  }
  cl_uint max_read_image_args() {
    return device_scalar_info!(cl_uint)(CL_DEVICE_MAX_READ_IMAGE_ARGS);
  }
  cl_uint max_samplers() {
    return device_scalar_info!(cl_uint)(CL_DEVICE_MAX_SAMPLERS);
  }
  size_t[] max_work_item_sizes() {
    return device_array_info!(size_t)(CL_DEVICE_MAX_WORK_ITEM_SIZES);
  }
  cl_uint max_write_image_args() {
    return device_scalar_info!(cl_uint)(CL_DEVICE_MAX_WRITE_IMAGE_ARGS);
  }
  cl_uint mem_base_addr_align() {
    return device_scalar_info!(cl_uint)(CL_DEVICE_MEM_BASE_ADDR_ALIGN);
  }
  cl_uint min_data_type_align_size() {
    return device_scalar_info!(cl_uint)(CL_DEVICE_MIN_DATA_TYPE_ALIGN_SIZE);
  }
  string name() {
    return cast(immutable)device_array_info!(char)(CL_DEVICE_NAME);
  }
  cl_uint preferred_vector_width_char() {
    return device_scalar_info!(cl_uint)(CL_DEVICE_PREFERRED_VECTOR_WIDTH_CHAR);
  }
  cl_uint preferred_vector_width_short() {
    return device_scalar_info!(cl_uint)(CL_DEVICE_PREFERRED_VECTOR_WIDTH_SHORT);
  }
  cl_uint preferred_vector_width_int() {
    return device_scalar_info!(cl_uint)(CL_DEVICE_PREFERRED_VECTOR_WIDTH_INT);
  }
  cl_uint preferred_vector_width_long() {
    return device_scalar_info!(cl_uint)(CL_DEVICE_PREFERRED_VECTOR_WIDTH_LONG);
  }
  cl_uint preferred_vector_width_float() {
    return device_scalar_info!(cl_uint)(CL_DEVICE_PREFERRED_VECTOR_WIDTH_FLOAT);
  }
  cl_uint preferred_vector_width_double() {
    return device_scalar_info!(cl_uint)(CL_DEVICE_PREFERRED_VECTOR_WIDTH_DOUBLE);
  }
  string profile() {
    return cast(immutable)device_array_info!(char)(CL_DEVICE_PROFILE);
  }
  size_t profiling_timer_resolution() {
    return device_scalar_info!(size_t)(CL_DEVICE_PROFILING_TIMER_RESOLUTION);
  }
  cl_command_queue_properties queue_properties() {
    return device_scalar_info!(cl_command_queue_properties)(CL_DEVICE_QUEUE_PROPERTIES);
  }
  cl_device_fp_config single_fp_config() {
    return device_scalar_info!(cl_device_fp_config)(CL_DEVICE_SINGLE_FP_CONFIG);
  }
  cl_device_type type() {
    return device_scalar_info!(cl_device_type)(CL_DEVICE_TYPE);
  }
  string vendor() {
    return cast(immutable)device_array_info!(char)(CL_DEVICE_VENDOR);
  }
  cl_uint vendor_id() {
    return device_scalar_info!(cl_uint)(CL_DEVICE_VENDOR_ID);
  }
  string cl_version() {
    return cast(immutable)device_array_info!(char)(CL_DEVICE_VERSION);
  }
  string driver_version() {
    return cast(immutable)device_array_info!(char)(CL_DRIVER_VERSION);
  }
}
