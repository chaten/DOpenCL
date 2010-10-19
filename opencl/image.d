module opencl.image;
import opencl.c;
import opencl.mem_object;
import opencl._auto_impl;
import opencl.types;
import opencl.conv;
import opencl.image_format;
class Image:MemObject {
	protected this(cl_mem mem) {
		super(mem);
	}
	cl_int image_info(ImageInfo e,size_t size,void * ptr,size_t * size_ret) {
		return clGetImageInfo(to!cl_mem(this),e,size,ptr,size_ret);
	}
	mixin(ExpandGetInfoFunction!("image_info",ImageInfo));
}
