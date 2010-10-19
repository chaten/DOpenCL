module opencl.image_format;
import opencl.c;
import opencl.types;
import opencl.conv;

class ImageFormat {
	ChannelOrder image_channel_order;
	ChannelType image_channel_data_type;
	this(cl_image_format format){ 
		image_channel_order = to!ChannelOrder(format.image_channel_order);
		image_channel_data_type = to!ChannelType(format.image_channel_data_type);
	}
}
