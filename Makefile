DC = dmd
DCFLAGS =
INSTALL_PATH = /usr
LIBNAME = DOpenCL
TARGET = lib/lib$(LIBNAME).a
SRC = $(wildcard $(LIBNAME)/*.d)
TST_SRC = $(wildcard test/*.d)
OBJ = $(addsuffix .o,$(basename $(SRC)))
TST_OBJ = $(addsuffix .o,$(basename $(TST_SRC)))
.PHONY: clean uninstall
all: $(TARGET)
install: $(TARGET)
	@cp -r include $(INSTALL_PATH)/include/d/$(LIBNAME)
	@cp $(TARGET) $(INSTALL_PATH)/$(TARGET)
uninstall:
	@rm $(INSTALL_PATH)/$(TARGET)
	@rm -r $(INSTALL_PATH)/include/d/$(LIBNAME)
clean:
	@rm -rf $(OBJ) $(TARGET) lib include $(TST_OBJ) build
test: DCFLAGS = -unittest 
test: $(OBJ) $(TST_OBJ)
	$(DC) $^ -ofbuild/test -L-lOpenCL
$(TARGET): $(OBJ)
	$(DC) -lib $^ -of$@
%.o: %.d
	$(DC) -c $(DCFLAGS) $< -of$@ -Hfinclude/$(basename $<).di
