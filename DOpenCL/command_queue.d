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
struct CommandQueue {
  cl_command_queue _queue;
  alias _queue this;
  this(cl_command_queue queue) {
    _queue = queue;
  }
  this(cl_context context,cl_device_id device_id,cl_command_queue_properties properties) {
    cl_int err_code;
    _queue = clCreateCommandQueue(context,device_id,properties,&err_code);
    assert(err_code == CL_SUCCESS);
  }
  ~this() {
    auto err_code = clReleaseCommandQueue(this);
    assert(err_code == CL_SUCCESS);
  }
  void enqueue_nd_range_kernel(cl_kernel kernel,cl_uint work_dim,int size_t work_size[], in size_t local_work_size[]) {
    auto err_code = clEnqueueNDRangeKernel(this,kernel,work_dim,null,
    					work_size.ptr,local_work_size.ptr,
					0,null,null);
    assert(err_code == CL_SUCCESS);
  }
  void enqueue_task(cl_kernel kernel) {
    auto err_code = clEnqueueTask(this,kernel,0,null,null);
    assert(err_code == CL_SUCCESS);
  }
  //TODO: Native Kernel
}
