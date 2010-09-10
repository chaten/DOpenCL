DC = dmd
DCFLAGS = 
INSTALL_PATH = /usr
LIBNAME = DOpenCL
TARGET = lib/lib$(LIBNAME).a
SRC = $(wildcard $(LIBNAME)/*.d)
TST_SRC = $(wildcard test/*.d)
OBJ = $(addprefix build/,$(addsuffix .o,$(basename $(SRC))))
TST_OBJ = $(addprefix build/,$(addsuffix .o,$(basename $(TST_SRC))))
DOCS = $(addprefix docs/,$(addsuffix .html,$(basename $(SRC))))
.PHONY: clean uninstall all install test docs
all: $(TARGET)
install: $(TARGET)
	@cp -r include $(INSTALL_PATH)/include/d/$(LIBNAME)
	@cp $(TARGET) $(INSTALL_PATH)/$(TARGET)
uninstall:
	@rm $(INSTALL_PATH)/$(TARGET)
	@rm -r $(INSTALL_PATH)/include/d/$(LIBNAME)
clean:
	@rm -rf $(OBJ) $(TARGET) lib include $(TST_OBJ) build docs bin
docs: $(DOCS)

test: DCFLAGS = -unittest 
test: $(OBJ) $(TST_OBJ)
	$(DC) $^ -ofbin/test -L-lOpenCL
$(TARGET): $(OBJ)
	$(DC) -lib $^ -of$@
build/%.o: %.d
	$(DC) -c $(DCFLAGS) $< -of$@ -Hfinclude/$(basename $<).di
docs/%.html: %.d
	$(DC) -o- $< -Df$@
