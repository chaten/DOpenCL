/*
  Copyright 2010 Michael CHaten
	
  Licensed under the Apache LIcense, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and 
  limitations under the License.
*/
extern(System) {
	alias byte		cl_char;
	alias ubyte		cl_uchar;
	alias short		cl_short;
	alias ushort	cl_ushort;
	alias int		cl_int;
	alias uint		cl_uint;
	alias long		cl_long;
	alias ulong		cl_ulong;
	alias short		cl_half;
	alias float cl_float;
	alias double cl_double;
	alias uint		cl_GLuint;
	alias int cl_GLint;
	alias uint		cl_GLenum; 
	alias void *cl_platform_id;
	alias void *cl_device_id;
	alias void *cl_context;
	alias void *cl_command_queue;
	alias void *cl_mem;
	alias void *cl_program;
	alias void *cl_kernel;
	alias void *cl_event;
	alias void *cl_sampler;
	alias cl_uint cl_bool; 
	alias cl_ulong cl_bitfield;
	alias cl_bitfield cl_device_type;
	alias cl_uint cl_platform_info;
	alias cl_uint cl_device_info;
	alias cl_bitfield cl_device_address_info;
	alias cl_bitfield cl_device_fp_config;
	alias cl_uint cl_device_mem_cache_type;
	alias cl_uint cl_device_local_mem_type;
	alias cl_bitfield cl_device_exec_capabilities;
	alias cl_bitfield cl_command_queue_properties;
	alias int * cl_context_properties;
	alias cl_uint cl_context_info;
	alias cl_uint cl_command_queue_info;
	alias cl_uint cl_channel_order;
	alias cl_uint cl_channel_type;
	alias cl_bitfield cl_mem_flags;
	alias cl_uint cl_mem_object_type;
	alias cl_uint cl_mem_info;
	alias cl_uint cl_image_info;
	alias cl_uint cl_addressing_mode;
	alias cl_uint cl_filter_mode;
	alias cl_uint cl_sampler_info;
	alias cl_bitfield cl_map_flags;
	alias cl_uint cl_program_info;
	alias cl_uint cl_program_build_info;
	alias cl_int cl_build_status;
	alias cl_uint cl_kernel_info;
	alias cl_uint cl_kernel_work_group_info;
	alias cl_uint cl_event_info;
	alias cl_uint cl_command_type;
	alias cl_uint cl_profiling_info;
	struct cl_image_format {
		cl_channel_order image_channel_order;
		cl_channel_type image_channel_data_type;
	}
	cl_int clGetPlatformIDs(cl_uint,cl_platform_id *,cl_uint *);
	cl_int clGetPlatformInfo(cl_platform_id ,cl_platform_info , size_t , void * , size_t * ); 
	cl_int clGetDeviceIDs(cl_platform_id,cl_device_type,cl_uint,cl_device_id *,cl_uint *);
	cl_int clGetDeviceInfo(cl_device_id,cl_device_info,size_t,void *,size_t *);
	cl_context clCreateContext( cl_context_properties * ,cl_uint, cl_device_id *,
									void function( char *,void *, size_t, void *),
									void *, cl_int *);
	cl_context clCreateContextFromType( cl_context_properties * ,cl_device_type , void function(char *,void *,size_t,void*),
									void * ,cl_int *);
	cl_int clRetainContext(cl_context );
	cl_int clReleaseContext(cl_context );
	cl_int clGetContextInfo(cl_context,cl_context_info,size_t,void *,size_t *); 
	cl_command_queue clCreateCommandQueue(cl_context,cl_device_id,cl_command_queue_properties,cl_int *);
	cl_int clRetainCommandQueue(cl_command_queue );
	cl_int clReleaseCommandQueue(cl_command_queue );
	cl_int clGetCommandQueueInfo(cl_command_queue,cl_command_queue_info ,size_t,void *,size_t *);
	cl_int clSetCommandQueueProperty(cl_command_queue,cl_command_queue_properties,cl_bool,cl_command_queue_properties *);
	cl_mem clCreateBuffer(cl_context,cl_mem_flags ,size_t,void *,cl_int *); 
	cl_mem clCreateImage2D(cl_context,cl_mem_flags, cl_image_format * ,size_t,size_t,size_t,void *,cl_int *);
	cl_mem clCreateImage3D(cl_context,cl_mem_flags, cl_image_format * , size_t, size_t,
							size_t ,
							size_t ,
							size_t ,
							void * ,
							cl_int * ); 
	cl_int clRetainMemObject(cl_mem ); 
	cl_int clReleaseMemObject(cl_mem );
	cl_int clGetSupportedImageFormats(cl_context ,
						cl_mem_flags ,
						cl_mem_object_type ,
						cl_uint,
	 					cl_image_format *,
						cl_uint *); 
	cl_int clGetMemObjectInfo(cl_mem ,
						cl_mem_info,
						size_t ,
						void * ,
						size_t * ); 
	cl_int clGetImageInfo(cl_mem ,
						cl_image_info,
						size_t ,
						void * ,
						size_t * ); 
	cl_sampler clCreateSampler(cl_context,
							cl_bool ,
							cl_addressing_mode,
							cl_filter_mode,
							cl_int *);
	cl_int clRetainSampler(cl_sampler );
	cl_int clReleaseSampler(cl_sampler );
	cl_int clGetSamplerInfo(cl_sampler ,
							cl_sampler_info,
							size_t ,
							void * ,
							size_t * ); 
	cl_program clCreateProgramWithSource(cl_context,
							cl_uint ,
							char ** ,
							size_t *,
							cl_int *);
	cl_program clCreateProgramWithBinary(cl_context ,
							cl_uint,
							cl_device_id * ,
							size_t * ,
							char ** ,
							cl_int * ,
							cl_int * );
	cl_int clRetainProgram(cl_program );
	cl_int clReleaseProgram(cl_program ); 
	cl_int clBuildProgram(cl_program ,
						 cl_uint ,
						cl_device_id * ,
						char * ,
						void function(cl_program,void *),
					void * ); 
	cl_int clUnloadCompiler();
	cl_int clGetProgramInfo(cl_program ,
						cl_program_info,
						size_t ,
						void * ,
						size_t * ); 
	cl_int clGetProgramBuildInfo(cl_program,cl_device_id,
					cl_program_build_info ,
						size_t,
						void *,
						size_t *); 
	cl_kernel clCreateKernel(cl_program,
						char *,
						cl_int *);
	cl_int clCreateKernelsInProgram(cl_program ,
						cl_uint,
						cl_kernel *,
						cl_uint *); 
	cl_int clRetainKernel(cl_kernel);
	cl_int clReleaseKernel(cl_kernel );
	cl_int clSetKernelArg(cl_kernel,
					cl_uint,
						size_t ,
						void * );
	cl_int clGetKernelInfo(cl_kernel ,
						cl_kernel_info,
						size_t,
						void *,
						size_t *);
	cl_int clGetKernelWorkGroupInfo(cl_kernel,
	 				cl_device_id ,
						cl_kernel_work_group_info,
						size_t ,
						void * ,
						size_t * ); 
	cl_int clWaitForEvents(cl_uint ,
						cl_event *);
	cl_int clGetEventInfo(cl_event ,
					 cl_event_info,
					 size_t ,
					 void * ,
					 size_t * );
	cl_int clRetainEvent(cl_event );
	cl_int clReleaseEvent(cl_event ); 
	cl_int clGetEventProfilingInfo(cl_event,
							cl_profiling_info ,
							size_t,
							void *,
							size_t *); 
	cl_int clFlush(cl_command_queue );
	cl_int clFinish(cl_command_queue ); 
	cl_int clEnqueueReadBuffer(cl_command_queue,
							cl_mem,
							cl_bool ,
							size_t,
							size_t,
							void *,
							cl_uint ,
							cl_event *,
							cl_event *);
	cl_int clEnqueueWriteBuffer(cl_command_queue ,
						 cl_mem ,
						 cl_bool,
						 size_t ,
						 size_t ,
						void * ,
						 cl_uint,
						cl_event * ,
						 cl_event * );
		 cl_int clEnqueueCopyBuffer(cl_command_queue,
							cl_mem,
							cl_mem,
							size_t,
							size_t,
							size_t,
							cl_uint ,
							 cl_event *,
							cl_event *);
		 cl_int clEnqueueReadImage(cl_command_queue ,
						 cl_mem ,
						 cl_bool,
							size_t * ,
							size_t * ,
						 size_t ,
						 size_t ,
						 void * ,
						 cl_uint,
							cl_event * ,
						 cl_event * );
		 cl_int clEnqueueWriteImage(cl_command_queue,
							cl_mem,
							cl_bool ,
							 size_t *,
							 size_t *,
							size_t,
							size_t,
							 void *,
							cl_uint ,
							 cl_event *,
							cl_event *);
		 cl_int clEnqueueCopyImage(cl_command_queue ,
						 cl_mem ,
						 cl_mem ,
							size_t * ,
							size_t * ,
							size_t * ,
						 cl_uint,
							cl_event * ,
						 cl_event * );
		 cl_int clEnqueueCopyImageToBuffer(cl_command_queue ,
								 cl_mem ,
								 cl_mem ,
									size_t * ,
									size_t * ,
								 size_t ,
								 cl_uint,
									cl_event * ,
								 cl_event * ); 
		 cl_int clEnqueueCopyBufferToImage(cl_command_queue ,
								 cl_mem ,
								 cl_mem ,
								 size_t ,
									size_t * ,
									size_t * ,
								 cl_uint,
									cl_event * ,
								 cl_event * );
		 void * clEnqueueMapBuffer(cl_command_queue ,
						 cl_mem ,
						 cl_bool,
						 cl_map_flags ,
						 size_t ,
						 size_t ,
						 cl_uint,
						 cl_event * ,
						 cl_event * ,
						 cl_int * );
		 void * clEnqueueMapImage(cl_command_queue,
						cl_mem,
						cl_bool ,
						cl_map_flags,
						size_t *,
						size_t *,
						size_t *,
						size_t *,
						cl_uint ,
						cl_event *,
						cl_event *,
						cl_int *);
		 cl_int clEnqueueUnmapMemObject(cl_command_queue ,
								cl_mem ,
								void * ,
								cl_uint,
								 cl_event *,
								cl_event *);
		 cl_int clEnqueueNDRangeKernel(cl_command_queue ,
							 cl_kernel,
							 cl_uint,
								size_t * ,
								size_t * ,
								size_t * ,
							 cl_uint,
								cl_event * ,
							 cl_event * );
		 cl_int clEnqueueTask(cl_command_queue,
					cl_kernel ,
					cl_uint ,
					 cl_event *,
					cl_event *); 
	 cl_int clEnqueueNativeKernel(cl_command_queue,
						void function(void *),
					void * ,
						size_t,
						cl_uint ,
						cl_mem * ,
						void ** ,
						cl_uint ,
						cl_event * ,
						cl_event * );
	 cl_int clEnqueueMarker(cl_command_queue,
						cl_event *);
	 cl_int clEnqueueWaitForEvents(cl_command_queue ,
						 cl_uint,
						 cl_event * );
	 cl_int clEnqueueBarrier(cl_command_queue );
	 void * clGetExtensionFunctionAddress( char * );
}
