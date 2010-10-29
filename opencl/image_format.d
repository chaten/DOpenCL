module opencl.image_format;
import opencl.c;
public import opencl.types:ChannelOrder,ChannelType;
import opencl.conv;

struct ImageFormat {
	private ChannelOrder image_channel_order;
	private ChannelType image_channel_data_type;
	this(cl_image_format format){ 
		image_channel_order = to!ChannelOrder(format.image_channel_order);
		image_channel_data_type = to!ChannelType(format.image_channel_data_type);
	}
	this(ChannelOrder order,ChannelType type) {
		image_channel_order = order;
		image_channel_data_type = type;
	}
	cl_image_format opCast() {
		cl_image_format ret;
		ret.image_channel_order = to!cl_channel_order(image_channel_order);
		ret.image_channel_data_type = to!cl_channel_type(image_channel_data_type);
		return ret;
	}
	ChannelOrder order() { 
		return image_channel_order;
	}
	ChannelType data_type() {
		return image_channel_data_type;
	}
}
