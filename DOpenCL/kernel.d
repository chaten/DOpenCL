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
module DOpenCL.kernel;
import DOpenCL.raw;
import std.string;
import DOpenCL.program;
/***
 * Represents an OpenCL Kernel 
 *
 * To execute a kernel, see DOpenCL.command_queue
 */
struct Kernel { 
  cl_kernel _kernel;
  alias _kernel this;
  ///Create a Kernel from a Program with the given function name
  this(Program program,string name) {
    cl_int err_code;
    _kernel = clCreateKernel(program,toStringz(name),&err_code);
    assert(err_code == CL_SUCCESS);
  }
  ///Create a Kernel from an existing cl_kernel object
  this(cl_kernel kernel) {
    _kernel = kernel;
  }
  ~this() {
    clReleaseKernel(this);
  }
  ///
  void set_kernel_arg(cl_uint arg_index,in void[] ptr) {
    auto err_code = clSetKernelArg(this,arg_index,ptr.length,ptr.ptr);
    assert(err_code == CL_SUCCESS);
  }
}
