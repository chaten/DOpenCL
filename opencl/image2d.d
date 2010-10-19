module opencl.image2d;
import opencl.mem_object;
import opencl.types;
import opencl.c;
class Image2D : MemObject {
	this(cl_mem mem) {
		super(mem);
		MemObjectType type = this.TYPE();
		if(type != MemObjectType.IMAGE2D) throw new Exception("Mem Object must be of type Image2D");
	}

}
