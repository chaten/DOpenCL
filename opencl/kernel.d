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
    assert(err_code == CL_SUCCESS);
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
  void set_kernel_arg(T)(cl_uint arg_index,const ref T[] ptr) {
    auto err_code = clSetKernelArg(this,arg_index,T.sizeof * ptr.length,ptr.ptr);
    throw_error(err_code);
    assert(err_code == CL_SUCCESS);
  }
  ///
  void set_kernel_arg(T)(cl_uint arg_index,const ref T data) {
    auto err_code = clSetKernelArg(this,arg_index,T.sizeof,data);
  }
  private {
    string get_string_info(cl_kernel_info info) {
      size_t str_size;
      cl_int err_code = clGetKernelInfo(this,info,0,null,&str_size);
      throw_error(err_code);
      assert(err_code == CL_SUCCESS);
      char[] str = new char[str_size];
      err_code = clGetKernelInfo(this,info,str_size,str.ptr,null);
      return cast(immutable) str;
    }
  }
  //Get the function name of the kernel
  string function_name() { 
    return get_string_info(CL_KERNEL_FUNCTION_NAME);
  }
  int number_of_arguments() {
    cl_int num_args;
    cl_int err_code = clGetKernelInfo(this,CL_KERNEL_NUM_ARGS,cl_int.sizeof,&num_args,null);
    throw_error(err_code);
    assert(err_code == CL_SUCCESS);
    return num_args;
  }
}
