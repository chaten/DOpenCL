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

	static ImageFormat[] supportedImageFormats(Context c,MemFlags flags){
		return Image.supportedImageFormats(c,flags,MemObjectType.IMAGE2D);
	}
}
