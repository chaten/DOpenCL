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
import DOpenCL.device_id;
import DOpenCL.context;
struct CommandQueue {
  cl_command_queue queue;
  this(cl_command_queue my_queue) {
    queue = my_queue;
  }
  this(Context context,DeviceID device_id,cl_command_queue_properties properties) {
    cl_int err_code;
    queue = clCreateCommandQueue(context.context,device_id.device_id,properties,&err_code);
    assert(err_code == CL_SUCCESS);
  }
  ~this() {
    auto err_code = clReleaseCommandQueue(queue);
    assert(err_code == CL_SUCCESS);
  }


}
