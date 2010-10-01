import std.stdio;
import opencl.platform_id;
import opencl.device_id;
void main() { 
  writefln("Platform Info");
  PlatformID ids[] = get_all_platform_ids();
  foreach(i,id;ids) {
    writefln("Platform[%d]",i);
    writefln("Name: %s",id.name());
    writefln("Extensions: %s",id.extensions());
    writefln("Version: %s",id.my_version());
    writefln("Vendor: %s",id.vendor());
    writefln("Profile: %s",id.profile());
    DeviceID devices[] = id.all_devices();
    foreach(j,device;devices) {
      writefln("Device[%d]:%s",j,device.name());
      writefln("Global Mem Size: %d",device.global_mem_size());
      writefln("Local Mem Size: %d",device.local_mem_size());
      writefln("Image Support: %s",device.has_image_support());
      writefln("Extensions: %s",device.extensions());
    }
  }
  writefln("Tests ran succesfully");
}
