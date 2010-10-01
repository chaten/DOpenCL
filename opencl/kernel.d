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
 License: Apache 2.0
 */
module opencl.kernel;
import opencl.c;
import opencl._get_info;
import opencl.error;
import opencl.buffer;
import std.string;
import opencl.program;
/***
 * Represents an OpenCL Kernel 
 *
 * To execute a kernel, see opencl.command_queue
 */
struct Kernel { 
  cl_kernel _kernel;
  alias _kernel this;
  ///Create a Kernel from a Program with the given function name
  this(Program program,string name) {
    cl_int err_code;
    _kernel = clCreateKernel(program,toStringz(name),&err_code);
    throw_error(err_code);
  }
  ///Create a Kernel from an existing cl_kernel object
  this(cl_kernel kernel) {
    _kernel = kernel;
  }
  this(this) {
    clRetainKernel(this);
  }
  ~this() {
    clReleaseKernel(this);
  }
  ///
  void set_kernel_arg(T)(cl_uint arg_index,const T * data) {
    auto err_code = clSetKernelArg(this,arg_index,T.sizeof,data);
    throw_error(err_code);
  }
  mixin get_info;
  private cl_int delegate(size_t,A *,size_t *) info_delegate(A)(cl_kernel_info param_name) {
    return (size_t size,A * ptr,size_t * size_ret) { return clGetKernelInfo(this,param_name,size,ptr,size_ret);};
  }
  //Get the function name of the kernel
  string function_name() {
    return get_info_string(info_delegate!(char)(CL_KERNEL_FUNCTION_NAME));
  }
  int number_of_arguments() {
    return get_info(info_delegate!(cl_int)(CL_KERNEL_NUM_ARGS));
  }
}
