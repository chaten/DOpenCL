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
module DOpenCL.buffer;
import DOpenCL.raw;
import DOpenCL.context;
import DOpenCL.command_queue;
struct Buffer {
  cl_mem mem;
  alias mem this;
  this(cl_context context,cl_mem_flags flags,size_t size,void * host_ptr) {
    cl_int err_code;
    mem = clCreateBuffer(context,flags,size,host_ptr,&err_code);
    assert (err_code == CL_SUCCESS);
  }
  this(cl_mem my_mem) {
    mem = my_mem;
  }
  ~this() {
    clReleaseMemObject(mem);
  }
  void enqueue_read(cl_command_queue cmd_queue,bool blocking_read,
  					size_t offset,size_t cb,void * ptr) {
    auto err_code = clEnqueueReadBuffer(cmd_queue,this,blocking_read,offset,cb,ptr,0,null,null);
    assert(err_code == CL_SUCCESS);
  }
  void enqueue_write(cl_command_queue cmd_queue,bool blocking_write,size_t offset,size_t cb,void * ptr) {
    auto err_code = clEnqueueWriteBuffer(cmd_queue,this,blocking_write,offset,cb,ptr,0,null,null);
    assert(err_code == CL_SUCCESS);
  }
}
