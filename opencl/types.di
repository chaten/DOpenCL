module opencl.types;

mixin(create_declarations());
private string create_declarations() {
  string[] cl_types = ["char","uchar","short","ushort","int","uint","long","ulong","float"];
  string[] d_types = ["byte","ubyte","short","ushort","int","uint","long","ulong","float"];
  string[] widths = ["2","3","4","8","16"];
  assert(cl_types.length == d_types.length);
  string decls;
  for(int i = 0;i<cl_types.length;i++) {
     foreach(width;widths) {
       decls ~= "alias " ~ d_types[i] ~ "[" ~ width ~ "] " ~ cl_types[i] ~ width ~";";
     }
  }
  return decls;
}
