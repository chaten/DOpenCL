DC = dmd
DCFLAGS = -w -wi 
INSTALL_PATH = /usr
LIBNAME = opencl
TARGET = lib/lib$(LIBNAME)_d.a
SRC = $(wildcard $(LIBNAME)/*.d)
SRC_I = $(wildcard $(LIBNAME)/*.di)
DST_I = $(addprefix include/,$(addsuffix .di,$(basename $(SRC_I))))
TST_SRC = $(wildcard test/*.d)
OBJ = $(addprefix build/,$(addsuffix .o,$(basename $(SRC))))
TST_OBJ = $(addprefix build/,$(addsuffix .o,$(basename $(TST_SRC))))
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
	@rm -rfv $(OBJ) $(TARGET) lib include $(TST_OBJ) build docs bin
docs: $(DOCS)

test: DCFLAGS += -unittest 
test: $(OBJ) $(TST_OBJ)
	$(DC) $^ -ofbin/test -L-lOpenCL
$(TARGET): $(OBJ)
	$(DC) -lib $^ -of$@
build/%.o: %.d
	$(DC) -c $(DCFLAGS) $< -of$@ -Hfinclude/$(basename $<).di
docs/%.md: %.d
	$(DC) -o- $< -Df$@ markdown.ddoc
include/%.di: %.di
	@cp -v $^ $@
