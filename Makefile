DC = dmd
DCFLAGS = -w -wi -gc
INSTALL_PATH = /usr
LIBNAME = opencl
TARGET = lib/lib$(LIBNAME)_d.a
SRC = $(wildcard $(LIBNAME)/*.d)
SRC_I = $(wildcard $(LIBNAME)/*.di)
DST_I = $(addprefix include/,$(addsuffix .di,$(basename $(SRC_I))))
TST_SRC = $(wildcard test/*.d)
TST_SRC += $(SRC)
TST_SRC += $(SRC_I)
TST_TARGET = bin/test
TST_KERNEL_DIR = test/kernels
TST_KERNELS = $(wildcard $(TST_KERNEL_DIR)/*.clc)
OBJ = $(addprefix build/,$(addsuffix .o,$(basename $(SRC))))
OBJ += $(addprefix build/,$(addsuffix .o,$(basename $(SRC_I))))
TST_OBJ = $(addprefix test_build/,$(addsuffix .o,$(basename $(TST_SRC))))
DOCS = $(addprefix docs/,$(addsuffix .md,$(basename $(SRC))))
.PHONY: clean uninstall all install test docs build
all: build
build: $(TARGET) $(DST_I)
install: build
	@cp -rv include/* $(INSTALL_PATH)/include/d/$(LIBNAME)/
	@cp -v $(TARGET) $(INSTALL_PATH)/$(TARGET)
uninstall:
	@rm -v $(INSTALL_PATH)/$(TARGET)
	@rm -rv $(INSTALL_PATH)/include/d/$(LIBNAME)
clean:
	@rm -rfv $(OBJ) $(TARGET) lib include $(TST_OBJ) build docs bin test_build
docs: $(DOCS)

test: $(TST_TARGET)
$(TST_TARGET): $(TST_SRC) $(TST_KERNELS)
	$(DC) -J$(TST_KERNEL_DIR) -unittest $(DCFLAGS) $(TST_SRC) -of$(TST_TARGET) -L-ldl
$(TARGET): $(SRC)
	$(DC) -lib $(DCFLAGS) -of$@ $(SRC)
#	$(DC) -lib $^ -of$@
build/%.o: %.d
	$(DC) -c $(DCFLAGS) $< -of$@ -Hfinclude/$(basename $<).di
build/%.o: %.di
	$(DC) -c $(DCFLAGS) $< -of$@
test_build/%.o: %.d
	$(DC) -c $(DCFLAGS) $< -of$@ -Hfinclude/$(basename $<).di
test_build/%.o: %.di
	$(DC) -c $(DCFLAGS) $< -of$@ 
docs/%.md: %.d
	$(DC) -o- $< -Df$@ markdown.ddoc
include/%.di: %.di
	@mkdir -p include/$(LIBNAME)
	@cp -v $^ $@
