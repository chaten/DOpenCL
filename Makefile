DC = dmd
DCFLAGS = -w -wi -gc
INSTALL_PATH = /usr
LIBNAME = opencl
TARGET = lib/lib$(LIBNAME)_d.a
SRC = $(wildcard $(LIBNAME)/*.d)
INCLUDE = $(addprefix include/,$(addsuffix .d,$(basename $(SRC))))
TST_SRC = $(wildcard test/*.d)
TST_SRC += $(SRC)
TST_TARGET = bin/test
TST_KERNEL_DIR = test/kernels
TST_KERNELS = $(wildcard $(TST_KERNEL_DIR)/*.clc)
OBJ = $(addprefix build/,$(addsuffix .o,$(basename $(SRC))))
OBJ += $(addprefix build/,$(addsuffix .o,$(basename $(SRC_I))))
TST_OBJ = $(addprefix test_build/,$(addsuffix .o,$(basename $(TST_SRC))))
DOCS = $(addprefix docs/,$(addsuffix .md,$(basename $(SRC))))
.PHONY: clean uninstall all install test docs build include
all: build include
build: $(TARGET)
include: $(INCLUDE)
install: build include
	@mkdir -pv $(INSTALL_PATH)/include/d/$(LIBNAME)
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
docs/%.md: %.d
	$(DC) -o- $< -Df$@ markdown.ddoc
include/%.d: %.d
	@mkdir -pv include/$(LIBNAME)
	@cp -v $< $@
