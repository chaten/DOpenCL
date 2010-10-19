module opencl.image3d;
import opencl.mem_object;
import opencl.types;
import opencl.conv;
import opencl.c;
import opencl.image_format;
class Image3D : MemObject {
	this(cl_mem mem) {
		super(mem);
		MemObjectType type = this.TYPE();
		if(type != MemObjectType.IMAGE3D) throw new Exception("Mem Object must be of type Image3D");
	}
	cl_int image_info(ImageInfo e,size_t size,void * ptr,size_t * size_ret) {
		return clGetImageInfo(to!cl_mem(this),e,size,ptr,size_ret);
	}
}
