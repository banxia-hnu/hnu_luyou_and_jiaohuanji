ifneq ($(KERNELRELEASE),)
	obj-m := nm08.o
	nm08-objs += main_nm08.o
	nm08-objs += nm08_nl.o
else
	KERNELDIR ?=/lib/modules/$(shell uname -r)/build
	PWD :=$(shell pwd)
      default:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) clean
	$(MAKE) -C $(KERNELDIR) M=$(PWD) modules
endif
      clean:
	$(MAKE) -C $(KERNELDIR) M=$(PWD) clean
