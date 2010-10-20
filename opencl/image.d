module opencl.image;
import opencl.c;
import opencl.mem_object;
import opencl._auto_impl;
import opencl.types;
import opencl.conv;
import opencl.image_format;
import opencl._error_handling;
import opencl.context;
import opencl.conv;
class Image:MemObject {
	protected this(cl_mem mem) {
		super(mem);
	}
	cl_int imageInfo(ImageInfo e,size_t size,void * ptr,size_t * size_ret) {
		return clGetImageInfo(to!cl_mem(this),e,size,ptr,size_ret);
	}
	static ImageFormat[] supportedImageFormats(Context c,MemFlags flags,MemObjectType type) in {
		assert(type != MemObjectType.BUFFER);
	} body {
		cl_image_format[] formats;
		uint num_image_formats;
		handle_error(clGetSupportedImageFormats(to!cl_context(c),to!cl_mem_flags(flags),type,0,null,&num_image_formats));
		formats = new cl_image_format[num_image_formats];
		handle_error(clGetSupportedImageFormats(to!cl_context(c),to!cl_mem_flags(flags),type,num_image_formats,formats.ptr,null));
		return to!(ImageFormat[])(formats);
	}
	mixin(ExpandGetInfoFunction!("imageInfo",ImageInfo));
}

