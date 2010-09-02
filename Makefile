DC = dmd
DCFLAGS := 
#Output flag is different between dmd and gdc
INSTALL_PATH = /usr
LIBNAME = DOpenCL
TARGET = lib/lib$(LIBNAME).a
SRC = $(wildcard $(LIBNAME)/*.d)
OBJ = $(addsuffix .o,$(basename $(SRC)))

all: $(TARGET)
install: $(TARGET)
	@cp -r include $(INSTALL_PATH)/include/d/$(LIBNAME)
	@cp $(TARGET) $(INSTALL_PATH)/$(TARGET)
uninstall:
	@rm $(INSTALL_PATH)/$(TARGET)
	@rm -r $(INSTALL_PATH)/include/d/$(LIBNAME)
clean:
	@rm -rf $(OBJ) $(TARGET) lib include
$(TARGET): $(OBJ)
	$(DC) -lib $^ -of$@
%.o: %.d
	$(DC) -c $(DCFLAGS) $< -of$@ -Hfinclude/$(basename $<).di
