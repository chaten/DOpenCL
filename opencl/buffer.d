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
module opencl.buffer;
import opencl.c;
import opencl.context;
import opencl.command_queue;
import opencl.error;
/*** A buffer reperesents memory stored on the opencl device */
struct Buffer {
  cl_mem _mem; ///The opencl memory structure buffer is based on
  alias _mem this;
  /***
   * Create a buffer with the given flags and from the given data.
   */
  this(Context context,cl_mem_flags flags,void [] host_ptr) {
    cl_int err_code;
    _mem = clCreateBuffer(context,flags,host_ptr.length,host_ptr.ptr,&err_code);
    throw_error(err_code);
    
  }
  this(this) {
    clRetainMemObject(this);
  }
  /***
   * Create a buffer from an existing opencl buffer
   */
  this(cl_mem mem) {
    _mem = mem;
  }
  ~this() {
    clReleaseMemObject(this);
  }
}
