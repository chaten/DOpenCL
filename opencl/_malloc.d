mixin template malloced_object() {
import core.exception;
import std.stdio;
  new (size_t size) {
    void * p = std.c.stdlib.malloc(size);
    writeln("Malloced a pointer %s",p);
    if(!p) throw new core.exception.OutOfMemoryError(__FILE__,__LINE__);
    return p;
  }
  delete (void * p) {
    writeln("Free a pionter %s",p);
    if(p) std.c.stdlib.free(p);
  }
}
