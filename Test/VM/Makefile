image_name="bvm-test"
bvm_root="../../"
input="BVMAsm"

run:
	docker run -it -v "$(shell readlink -f $(bvm_root))":/var/bvm -v "$(shell readlink -f $(input))":/var/bvmasm breezevm/bvm

build:
	docker build -t breezevm/bvm .