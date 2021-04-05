vm:
	odin build Source/BreezeVM -out=bin/bvm -collection:breeze=Source/BreezeVM -collection:assembler=Source/Assembler

assembler:
	odin build Source/Assembler -out=bin/bvmasm -collection:breeze=Source/BreezeVM -collection:assembler=Source/Assembler

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