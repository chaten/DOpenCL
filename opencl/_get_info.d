module opencl._get_info;
import opencl.error;
package {
  mixin template get_info() {
    private {
      A get_info(A)(cl_int delegate(size_t size,A * ptr,size_t * size_ret) info) {
         A value;
	 cl_int err_code = info(A.sizeof,&value,null);
	 throw_error(err_code);
	 return value;
      }
      A[] get_info_array(A)(cl_int delegate(size_t size,A * ptr,size_t * size_ret) info) {
         A[] value;
	 size_t value_size;
	 cl_int err_code = info(0,null,&value_size);
	 throw_error(err_code);
	 value = new A[value_size/A.sizeof];
	 err_code = info(value_size,value.ptr,null);
	 throw_error(err_code);
	 return value;
      }
      string get_info_string(cl_int delegate(size_t size,char * ptr,size_t * size_ret) info) {
         char[] value = get_info_array(info);
	 return cast(immutable)value[0..value.length-1];
      }
    }
  }
}

