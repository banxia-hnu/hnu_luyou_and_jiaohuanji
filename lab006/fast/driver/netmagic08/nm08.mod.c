#include <linux/module.h>
#include <linux/vermagic.h>
#include <linux/compiler.h>

MODULE_INFO(vermagic, VERMAGIC_STRING);

__visible struct module __this_module
__attribute__((section(".gnu.linkonce.this_module"))) = {
	.name = KBUILD_MODNAME,
	.init = init_module,
#ifdef CONFIG_MODULE_UNLOAD
	.exit = cleanup_module,
#endif
	.arch = MODULE_ARCH_INIT,
};

static const struct modversion_info ____versions[]
__used
__attribute__((section("__versions"))) = {
	{ 0x96cec1da, __VMLINUX_SYMBOL_STR(module_layout) },
	{ 0x644a200, __VMLINUX_SYMBOL_STR(dev_get_by_name) },
	{ 0x1565ac30, __VMLINUX_SYMBOL_STR(param_ops_string) },
	{ 0x156eedb7, __VMLINUX_SYMBOL_STR(__netdev_alloc_skb) },
	{ 0xfb578fc5, __VMLINUX_SYMBOL_STR(memset) },
	{ 0x27e1a049, __VMLINUX_SYMBOL_STR(printk) },
	{ 0x3e4e37ad, __VMLINUX_SYMBOL_STR(netlink_kernel_release) },
	{ 0x128cf3fb, __VMLINUX_SYMBOL_STR(free_netdev) },
	{ 0x1a09356e, __VMLINUX_SYMBOL_STR(register_netdev) },
	{ 0x32d3f498, __VMLINUX_SYMBOL_STR(skb_push) },
	{ 0x586ab118, __VMLINUX_SYMBOL_STR(dev_remove_pack) },
	{ 0x9aa47afd, __VMLINUX_SYMBOL_STR(netlink_unicast) },
	{ 0x356facb3, __VMLINUX_SYMBOL_STR(skb_pull) },
	{ 0x65923edb, __VMLINUX_SYMBOL_STR(init_net) },
	{ 0xc067a67d, __VMLINUX_SYMBOL_STR(netif_receive_skb_sk) },
	{ 0xb0db5ee4, __VMLINUX_SYMBOL_STR(eth_type_trans) },
	{ 0xbdfb6dbb, __VMLINUX_SYMBOL_STR(__fentry__) },
	{ 0x8c2acb3e, __VMLINUX_SYMBOL_STR(__netlink_kernel_create) },
	{ 0x69acdf38, __VMLINUX_SYMBOL_STR(memcpy) },
	{ 0xe480aa2, __VMLINUX_SYMBOL_STR(unregister_netdev) },
	{ 0x2b7477e6, __VMLINUX_SYMBOL_STR(dev_add_pack) },
	{ 0x26565c5f, __VMLINUX_SYMBOL_STR(consume_skb) },
	{ 0xc4d0ec1e, __VMLINUX_SYMBOL_STR(skb_put) },
	{ 0x3767c91f, __VMLINUX_SYMBOL_STR(alloc_etherdev_mqs) },
};

static const char __module_depends[]
__used
__attribute__((section(".modinfo"))) =
"depends=";


MODULE_INFO(srcversion, "2E68D405723CA552BBAF8B7");
