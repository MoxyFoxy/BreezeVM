image_name="bvm-test"
bvm_root="../../"

fibonacci:
	@docker run -it -v "$(shell readlink -f $(bvm_root))":/var/bvm -v "$(shell readlink -f "Fibonacci")":/var/bvmasm breezevm/bvm

hello-world:
	@docker run -it -v "$(shell readlink -f $(bvm_root))":/var/bvm -v "$(shell readlink -f "Hello-World")":/var/bvmasm breezevm/bvm

build:
	@docker build -t breezevm/bvm .