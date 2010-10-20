module opencl.image3d;
import opencl.mem_object;
import opencl.types;
import opencl.conv;
import opencl.c;
import opencl.image;
import opencl.context;
import opencl.image_format;
class Image3D : Image {
	this(cl_mem mem) {
		super(mem);
		MemObjectType type = this.TYPE();
		if(type != MemObjectType.IMAGE3D) throw new Exception("Mem Object must be of type Image3D");
	}
	static ImageFormat[] supportedImageFormats(Context c,MemFlags f) {
		return Image.supportedImageFormats(c,f,MemObjectType.IMAGE3D);
	}
}
