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
module opencl.command_queue;
import opencl.error;
import opencl.event;
import opencl.c;
import opencl.buffer;
import opencl.kernel;
import opencl.context;
import opencl.device_id;
import std.stdio;
/***
  Represents an OpenCL Command Queue.
 */
struct CommandQueue {
  cl_command_queue _queue;
  alias _queue this;
  /***
   * Create this from an existing command queue
   */
  this(cl_command_queue queue) {
    _queue = queue;
  }
  /***
   * Create a Command Queue. 
   */
  this(Context context,DeviceID device_id,cl_command_queue_properties properties) {
    cl_int err_code;
    _queue = clCreateCommandQueue(context,device_id,properties,&err_code);
    throw_error(err_code);
  }
  this(this) {
    throw_error(clRetainCommandQueue(this));
  }
  ~this() {
    throw_error(clReleaseCommandQueue(this));
  }
  /****/
  Event enqueue_nd_range_kernel(Kernel kernel,cl_uint work_dim,const size_t work_size[], const size_t local_work_size[]) {
    const size_t * local_work_size_ptr = local_work_size is null?null:local_work_size.ptr;
    cl_event event;
    throw_error(clEnqueueNDRangeKernel(this,kernel,work_dim,null,
    					work_size.ptr,local_work_size_ptr,
					0,null,&event));
    return Event(event);
  }
  ///
  Event enqueue_task(Kernel kernel) {
    cl_event event;
    throw_error(clEnqueueTask(this,kernel,0,null,&event));
    return Event(event);
  }
  //TODO: Native Kernel
  /***
   *  Read data from the buffer into the array
   */
  Event enqueue_read_buffer(Buffer buffer,bool blocking,out void [] data) {
    cl_event event;
    throw_error(clEnqueueReadBuffer(this,buffer,blocking,0,data.length,data.ptr,0,null,&event));
    return Event(event);
  }
  /***
   * Write data into the buffer from the array
   */
  Event enqueue_write_buffer(Buffer buffer,bool blocking,in void [] data) {
    cl_event event;
    throw_error(clEnqueueWriteBuffer(this,buffer,blocking,0,data.length,data.ptr,0,null,&event));
    return Event(event);
  }
}
