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
module DOpenCL.context;
import DOpenCL.raw;
import DOpenCL.device_id;
/***
  Represents an OpenCL context
 */
struct Context {
  cl_context _context;
  alias _context this;
  /***
  */
  this(ref cl_context_properties properties[],cl_device_type device_type) {
    cl_int err_code;
    _context = clCreateContextFromType(properties.ptr,device_type,null,null,
    		&err_code);
    assert(err_code == CL_SUCCESS);
  }
  /***
  */
  this(ref cl_context_properties properties[],in cl_device_id devices[]) {
    cl_int err_code;
    _context = clCreateContext(properties.ptr,devices.length,devices.ptr,null,null,&err_code);
    assert(err_code == CL_SUCCESS);
  }
  /***
   * Create me from an exist OpenCL context
   */
  this(cl_context my_context) {
    _context = my_context;
  }
  ~this() {
    clReleaseContext(this);
  }
  /***
   * Get the number of devices that this context has
   */
  cl_uint num_devices() {
    cl_uint ret;
    cl_int err = clGetContextInfo(this,CL_CONTEXT_NUM_DEVICES,ret.sizeof,&ret,null);
    assert(err == CL_SUCCESS);
    return ret;
  }
  /***
   * Get all of the devices this context has
   */
  DeviceID[] device_ids() {
    cl_uint devices_len = num_devices();
    cl_device_id cl_device_ids[] = new cl_device_id[devices_len];
    cl_int err = clGetContextInfo(this,CL_CONTEXT_DEVICES,
		     cl_device_ids.length * cl_device_id.sizeof,
		     cl_device_ids.ptr,null);
    assert(err == CL_SUCCESS);
    DeviceID device_ids[] = new DeviceID[devices_len];
    foreach(i,device_id;cl_device_ids) {
      device_ids[i] = DeviceID(device_id);
    }
    delete cl_device_ids;
    return device_ids;
  }
  /* TODO: context properties */
}
