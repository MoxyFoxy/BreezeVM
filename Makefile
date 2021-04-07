WINDOWS_BIN_DIR=bin/Windows
LINUX_BIN_DIR=bin/Linux

vm:
	@mkdir -p $(LINUX_BIN_DIR)
	@echo Compiling BVM for Linux...
	@odin build Source/BreezeVM -out=$(LINUX_BIN_DIR)/bvm -keep-temp-files -collection:breeze=Source/BreezeVM -collection:assembler=Source/Assembler
	@echo Linking to create binary...
	@clang $(LINUX_BIN_DIR)/bvm.ll -o $(LINUX_BIN_DIR)/bvm -Wno-override-module
	@echo Cleaning directory...
	@rm $(LINUX_BIN_DIR)/*.bc $(LINUX_BIN_DIR)/*.ll $(LINUX_BIN_DIR)/*.o
	@echo BVM for Linux is complete.
	@echo

assembler:
	@mkdir -p $(LINUX_BIN_DIR)
	@echo Compiling BVM Assembler for Linux...
	@odin build Source/Assembler -out=$(LINUX_BIN_DIR)/bvmasm -keep-temp-files -collection:breeze=Source/BreezeVM -collection:assembler=Source/Assembler
	@echo Linking to create binary...
	@clang $(LINUX_BIN_DIR)/bvmasm.ll -o $(LINUX_BIN_DIR)/bvmasm -Wno-override-module
	@echo Cleaning directory...
	@rm $(LINUX_BIN_DIR)/*.bc $(LINUX_BIN_DIR)/*.ll $(LINUX_BIN_DIR)/*.o
	@echo BVM Assembler for Linux is complete.
	@echo

vm-windows:
	@mkdir -p $(WINDOWS_BIN_DIR)
	@echo Compiling BVM for Windows...
	@odin build Source/BreezeVM -out=$(WINDOWS_BIN_DIR)/bvm -keep-temp-files -target:windows_amd64 -collection:breeze=Source/BreezeVM -collection:assembler=Source/Assembler
	@echo Linking to create binary...
	@clang $(WINDOWS_BIN_DIR)/bvm.ll -o $(WINDOWS_BIN_DIR)/bvm.exe --target=x86_64-pc-windows-gnu -Wno-override-module
	@echo Cleaning directory...
	@rm $(WINDOWS_BIN_DIR)/*.bc $(WINDOWS_BIN_DIR)/*.ll $(WINDOWS_BIN_DIR)/*.obj
	@echo BVM for Windows is complete.
	@echo

assembler-windows:
	@mkdir -p $(WINDOWS_BIN_DIR)
	@echo Compiling BVM Assembler for Windows...
	@odin build Source/Assembler -out=$(WINDOWS_BIN_DIR)/bvmasm -keep-temp-files -target:windows_amd64 -collection:breeze=Source/BreezeVM -collection:assembler=Source/Assembler
	@echo Linking to create binary...
	@clang $(WINDOWS_BIN_DIR)/bvmasm.ll -o $(WINDOWS_BIN_DIR)/bvmasm.exe --target=x86_64-pc-windows-gnu -Wno-override-module
	@echo Cleaning directory...
	@rm $(WINDOWS_BIN_DIR)/*.bc $(WINDOWS_BIN_DIR)/*.ll $(WINDOWS_BIN_DIR)/*.obj
	@echo BVM Assembler for Windows is complete.
	@echo

all-linux: vm assembler
all-windows: vm-windows assembler-windows
all: vm assembler vm-windows assembler-windows

update: update-breeze update-lib

update-breeze:
	git pull

update-lib:
ifeq "$(shell ls lib | wc -l)" "0"
	cd lib;
	# This is where any git pulls for dependencies would be added. 
else
	# https://stackoverflow.com/a/2108296
	for lib in lib/*/
	do
		lib=${lib%*/}
		cd lib; git pull
	done
endif

clean:
	find bin/* -not -name '.gitkeep' -delete
	@echo "Binary directory has been cleaned."