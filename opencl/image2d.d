module opencl.image2d;
import opencl.image;
import opencl.types;
import opencl.c;
class Image2D : Image {
	this(cl_mem mem) {
		super(mem);
		MemObjectType type = this.TYPE();
		if(type != MemObjectType.IMAGE2D) throw new Exception("Mem Object must be of type Image2D");
	}

}
