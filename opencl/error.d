module opencl.error;
import opencl.c;
import std.conv;
void throw_error(cl_int err_code) {
  switch(err_code) {
  	case CL_SUCCESS:			  return;
        case CL_DEVICE_NOT_FOUND:                 throw new Exception("Device not found.");
        case CL_DEVICE_NOT_AVAILABLE:             throw new Exception("Device not available");
        case CL_COMPILER_NOT_AVAILABLE:           throw new Exception("Compiler not available");
        case CL_MEM_OBJECT_ALLOCATION_FAILURE:    throw new Exception("Memory object allocation failure");
        case CL_OUT_OF_RESOURCES:                 throw new Exception("Out of resources");
        case CL_OUT_OF_HOST_MEMORY:               throw new Exception("Out of host memory");
        case CL_PROFILING_INFO_NOT_AVAILABLE:     throw new Exception("Profiling information not available");
        case CL_MEM_COPY_OVERLAP:                 throw new Exception("Memory copy overlap");
        case CL_IMAGE_FORMAT_MISMATCH:            throw new Exception("Image format mismatch");
        case CL_IMAGE_FORMAT_NOT_SUPPORTED:       throw new Exception("Image format not supported");
        case CL_BUILD_PROGRAM_FAILURE:            throw new Exception("Program build failure");
        case CL_MAP_FAILURE:                      throw new Exception("Map failure");
        case CL_INVALID_VALUE:                    throw new Exception("Invalid value");
        case CL_INVALID_DEVICE_TYPE:              throw new Exception("Invalid device type");
        case CL_INVALID_PLATFORM:                 throw new Exception("Invalid platform");
        case CL_INVALID_DEVICE:                   throw new Exception("Invalid device");
        case CL_INVALID_CONTEXT:                  throw new Exception("Invalid context");
        case CL_INVALID_QUEUE_PROPERTIES:         throw new Exception("Invalid queue properties");
        case CL_INVALID_COMMAND_QUEUE:            throw new Exception("Invalid command queue");
        case CL_INVALID_HOST_PTR:                 throw new Exception("Invalid host pointer");
        case CL_INVALID_MEM_OBJECT:               throw new Exception("Invalid memory object");
        case CL_INVALID_IMAGE_FORMAT_DESCRIPTOR:  throw new Exception("Invalid image format descriptor");
        case CL_INVALID_IMAGE_SIZE:               throw new Exception("Invalid image size");
        case CL_INVALID_SAMPLER:                  throw new Exception("Invalid sampler");
        case CL_INVALID_BINARY:                   throw new Exception("Invalid binary");
        case CL_INVALID_BUILD_OPTIONS:            throw new Exception("Invalid build options");
        case CL_INVALID_PROGRAM:                  throw new Exception("Invalid program");
        case CL_INVALID_PROGRAM_EXECUTABLE:       throw new Exception("Invalid program executable");
        case CL_INVALID_KERNEL_NAME:              throw new Exception("Invalid kernel name");
        case CL_INVALID_KERNEL_DEFINITION:        throw new Exception("Invalid kernel definition");
        case CL_INVALID_KERNEL:                   throw new Exception("Invalid kernel");
        case CL_INVALID_ARG_INDEX:                throw new Exception("Invalid argument index");
        case CL_INVALID_ARG_VALUE:                throw new Exception("Invalid argument value");
        case CL_INVALID_ARG_SIZE:                 throw new Exception("Invalid argument size");
        case CL_INVALID_KERNEL_ARGS:              throw new Exception("Invalid kernel arguments");
        case CL_INVALID_WORK_DIMENSION:           throw new Exception("Invalid work dimension");
        case CL_INVALID_WORK_GROUP_SIZE:          throw new Exception("Invalid work group size");
        case CL_INVALID_WORK_ITEM_SIZE:           throw new Exception("Invalid work item size");
        case CL_INVALID_GLOBAL_OFFSET:            throw new Exception("Invalid global offset");
        case CL_INVALID_EVENT_WAIT_LIST:          throw new Exception("Invalid event wait list");
        case CL_INVALID_EVENT:                    throw new Exception("Invalid event");
        case CL_INVALID_OPERATION:                throw new Exception("Invalid operation");
        case CL_INVALID_GL_OBJECT:                throw new Exception("Invalid OpenGL object");
        case CL_INVALID_BUFFER_SIZE:              throw new Exception("Invalid buffer size");
        case CL_INVALID_MIP_LEVEL:                throw new Exception("Invalid mip-map level");
	default:				  throw new Exception(text("Unknown Exception Code ",err_code));
  }
}
