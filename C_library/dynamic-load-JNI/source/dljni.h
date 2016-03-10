/*
	note: "Header for dynamic loading of JNI libjvm.so or jvm.dll"
	author: "Finnian Reilly"
	copyright: "Copyright (c) 2006-2010 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2 August 2010"
*/

#ifndef DLJNI_H
#define DLJNI_H

#include <jni.h>
//#include <stdlib.h>
//#include <dlfcn.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef jint (JNICALL fn_create_Java_VM_t)(JavaVM**, void**, void*);

//_JNI_IMPORT_OR_EXPORT_ jint JNICALL
//create_java_vm (char *libpath, JavaVM **pvm, void **penv, void *args);
//create_java_vm (create_java_vm_t, JavaVM **pvm, void **penv, void *args);


// It looks like this function is now no longer necessary. No library required, only header.
jint JNICALL create_java_vm (fn_create_Java_VM_t *dl_create_java_vm, JavaVM **pvm, void **penv, void *args);

#ifdef __cplusplus
} /* extern "C" */
#endif /* __cplusplus */

#endif
