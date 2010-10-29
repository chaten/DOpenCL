module opencl.image2d;
import opencl.image;
import opencl.types;
import opencl.context;
import opencl.c;
import opencl._error_handling;
import opencl.conv;
import opencl.image_format;
class Image2D : Image {
	this(cl_mem mem) {
		super(mem);
		MemObjectType type = this.TYPE();
		if(type != MemObjectType.IMAGE2D) throw new Exception("Mem Object must be of type Image2D");
	}
	this(Context c,MemFlags flags,ImageFormat format,size_t width,size_t height,size_t pitch,void * ptr) {
		cl_int err_code;
		cl_image_format fmt = to!cl_image_format(format);
		cl_mem mem = clCreateImage2D(to!cl_context(c),to!cl_mem_flags(flags),&fmt,width,height,pitch,ptr,&err_code);
		handle_error(err_code);
		super(mem);
	}

	static ImageFormat[] supportedImageFormats(Context c,MemFlags flags){
		return Image.supportedImageFormats(c,flags,MemObjectType.IMAGE2D);
	}
}
