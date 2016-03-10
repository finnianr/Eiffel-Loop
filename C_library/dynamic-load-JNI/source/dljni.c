/*
	note: "Dynamic loading of JNI libjvm.so"
	author: "Finnian Reilly"
	copyright: "Copyright (c) 2006-2010 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2 August 2010"
*/


#include "dljni.h"

#ifdef __cplusplus
extern "C" {
#endif
/*
jint JNICALL create_java_vm (char *libpath, JavaVM **pvm, void **penv, void *args)

{
	void* lib_handle = 0;
	create_java_vm_t dl_create_java_vm = 0;

	lib_handle = dlopen (libpath, RTLD_LAZY);
	if (lib_handle != NULL) {
		dl_create_java_vm = (create_java_vm_t) dlsym(lib_handle, "JNI_CreateJavaVM");
		return dl_create_java_vm (pvm, penv, args);
	}

}*/

jint JNICALL create_java_vm (fn_create_Java_VM_t *p_fn_create_Java_VM, JavaVM **pvm, void **penv, void *args)

{
	void *ptr;
	jint error = ((fn_create_Java_VM_t *)ptr) (pvm, penv, args);
	return p_fn_create_Java_VM (pvm, penv, args);

}

#ifdef __cplusplus
} /* extern "C" */
#endif /* __cplusplus */

