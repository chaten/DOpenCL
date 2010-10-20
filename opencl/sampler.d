module opencl.sampler;
import opencl.c;
import opencl.cl_object;
import opencl.conv;
import opencl.types;
class Sampler:CLObject!(cl_sampler,SamplerInfo) {
	this(cl_sampler c) {
		super(c);
	}
	override cl_int get_info(SamplerInfo e,size_t s,void * ptr,size_t * size_ret) {
		return clGetSamplerInfo(to!cl_sampler(this),e,s,ptr,size_ret);
	}
	override cl_int release() {
		return clReleaseSampler(to!cl_sampler(this));
	}
}
