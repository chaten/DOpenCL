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
import DOpenCL.program;
import DOpenCL.command_queue;
import std.string;
struct Kernel { 
  cl_kernel _kernel;
  alias _kernel this;
  this(Program program,string name) {
    cl_int err_code;
    _kernel = clCreateKernel(program,toStringz(name),&err_code);
    assert(err_code == CL_SUCCESS);
  }
  this(cl_kernel kernel) {
    _kernel = kernel;
  }
  ~this() {
    clReleaseKernel(this);
  }
  void set_kernel_arg(cl_uint arg_index,size_t size,const(void) * ptr) {
    auto err_code = clSetKernelArg(this,arg_index,size,ptr);
    assert(err_code == CL_SUCCESS);
  }
  void enqueue_nd_range(CommandQueue cmd_queue,cl_uint work_dim,in size_t work_size[],in size_t local_work_size[]) {
    auto err_code = clEnqueueNDRangeKernel(cmd_queue,this,work_dim,null,work_size.ptr,local_work_size.ptr,0,null,null);
    assert(err_code == CL_SUCCESS);
  }
}
