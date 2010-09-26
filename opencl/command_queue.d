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
import opencl.c;
import opencl.buffer;
import opencl.kernel;
import opencl.context;
import opencl.device_id;
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
    assert(err_code == CL_SUCCESS);
  }
  ~this() {
    auto err_code = clReleaseCommandQueue(this);
    assert(err_code == CL_SUCCESS);
  }
  /****/
  void enqueue_nd_range_kernel(Kernel kernel,cl_uint work_dim,in size_t work_size[], in size_t local_work_size[]) {
    auto err_code = clEnqueueNDRangeKernel(this,kernel,work_dim,null,
    					work_size.ptr,local_work_size.ptr,
					0,null,null);
    assert(err_code == CL_SUCCESS);
  }
  ///
  void enqueue_task(Kernel kernel) {
    auto err_code = clEnqueueTask(this,kernel,0,null,null);
    assert(err_code == CL_SUCCESS);
  }
  //TODO: Native Kernel
  /***
   *  Read data from the buffer into the array
   */
  void enqueue_read_buffer(Buffer buffer,bool blocking,out void [] data) {
    auto err_code = clEnqueueReadBuffer(this,buffer,blocking,0,data.length,data.ptr,0,null,null);
    assert(err_code == CL_SUCCESS);
  }
  /***
   * Write data into the buffer from the array
   */
  void enqueue_write_buffer(Buffer buffer,bool blocking,in void [] data) {
    auto err_code = clEnqueueWriteBuffer(this,buffer,blocking,0,data.length,data.ptr,0,null,null);
    assert(err_code == CL_SUCCESS);
  }
}
