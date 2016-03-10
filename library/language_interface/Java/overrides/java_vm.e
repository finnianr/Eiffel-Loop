note
	description: "[
		This class is used to initially load the JVM into the running program
	]"

	legal: "See notice at end of class."

	status: "See notice at end of class."

class
	JAVA_VM

inherit
	SHARED_DYNAMIC_API_LOADER
		undefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			--
		do
			create default_vm_args.make
			default_vm_args.set_version ({JAVA_VM_INIT_ARGS}.Jni_version_1_4)
			create class_path.make_empty
		end

feature {JAVA_ORB} -- Element change

	open (libjvm_path: EL_FILE_PATH; a_class_path: STRING)
			--
		local
			jvm_options: ARRAY [JAVA_VM_OPTION]
			l_option: JAVA_VM_OPTION
		do

			class_path := a_class_path

			create jvm_options.make (1, 1)
			create l_option.make
			l_option.set_option_string ("-Djava.class.path=" + class_path)
			jvm_options.put (l_option, 1)

			load_jvm (libjvm_path, jvm_options)
		end

feature -- Status query

	is_open: BOOLEAN

feature -- Access

	class_path: STRING

feature -- Element change

	load_jvm (libjvm_path: EL_FILE_PATH; jvm_options: ARRAY [JAVA_VM_OPTION])
			-- Create a JVM execution environment and specify a CLASSPATH
		local
			l_envp, l_jvmp, fn_create_jvm: POINTER
			error_occured: BOOLEAN
			error_number: INTEGER
			l_ex: EXCEPTIONS
		do
			jvm_library_handle := api_loader.load_library_from_path (libjvm_path.to_string.to_latin1)
			error_occured := jvm_library_handle = default_pointer

			if not error_occured then
				fn_create_jvm := api_loader.api_pointer (jvm_library_handle, "JNI_CreateJavaVM")
				error_occured := fn_create_jvm = default_pointer
				if not error_occured then
					default_vm_args.set_options (jvm_options)

						-- Store attribute into local variable as `$' operator is safer on
						-- local variables and not on attributes.
					l_envp := envp
					l_jvmp := jvmp
					error_number := c_create_jvm (fn_create_jvm, $l_jvmp, $l_envp, default_vm_args.item)
					error_occured := error_number /= 0
					is_open := not error_occured
					envp := l_envp
					jvmp := l_jvmp
				end
			end

			if error_occured then
				io.error.putstring ("*** Failed to load JVM=")
				io.error.putint (error_number)
				io.error.putstring ("  *** CLASSPATH=")
				io.error.putstring (class_path)
				io.error.new_line

				create l_ex
				l_ex.raise ("Failed to load java VM")
			end
		end

feature -- Disposal

	destroy_vm
			-- Destroy the JVM
		local
			err: INTEGER
		do
			if jvmp /= Default_pointer then
				err := c_destroy_jvm (jvmp)
				if err /= 0 then
					debug ("java_vm")
						io.error.putstring ("*** Failed to destroy JVM=")
						io.error.putint (err)
						io.error.new_line
					end
				else
					api_loader.unload_library (jvm_library_handle)
				end
			end
			jvmp := Default_pointer
		end

feature -- Thread

	attach_current_thread
			-- Attach to current thread of execution.
		local
			err: INTEGER
			l_envp: POINTER
		do
			l_envp := envp
			err := c_attach_current_thread (jvmp, $l_envp, default_vm_args.item)
			envp := l_envp
			if err /= 0 then
				debug ("java_vm")
					io.error.putstring ("Could not attach the current thread, err = ")
					io.error.putint (err)
					io.error.new_line
				end
			else
				debug ("java_vm")
					io.error.putstring ("Current thead attached successfully!!!")
					io.error.new_line
				end
			end
		end

	detach_current_thread
			-- Detach from current thread of execution.
		local
			err: INTEGER
		do
			err := c_detach_current_thread (jvmp)
			if err /= 0 then
				debug ("java_vm")
					io.error.putstring ("Could not detach the current thread, err = ")
					io.error.putint (err)
					io.error.new_line
				end
			else
				debug ("java_vm")
					io.error.putstring ("Current thead detached successfully")
					io.error.new_line
				end
			end
		end

feature {JAVA_ORB} -- Access

	envp: POINTER
			-- Environment pointer.

feature {NONE} -- Implementation

	default_vm_args: JAVA_VM_INIT_ARGS
			-- Pointer to default arguments for JVM.

	jvmp: POINTER
			-- Pointer to current JVM.

	jvm_library_handle: POINTER

feature {NONE} -- externals

--	c_create_jvm (libpath, jvm: POINTER; env: POINTER; args: POINTER): INTEGER
--		external
--			"C (char *, JavaVM **, void **, void *): EIF_INTEGER | <dljni.h>"
--		alias
--			"create_java_vm"
--		end

--	c_create_jvm (creation_func, jvm, env, args: POINTER): INTEGER
--			--
--        external
--            "C (fn_create_Java_VM_t *, JavaVM **, void **, void *): EIF_INTEGER | <dljni.h>"
--        alias
--        	"create_java_vm"
--        end

	c_create_jvm (a_creation_func, jvm, env, args: POINTER): INTEGER
			-- _JNI_IMPORT_OR_EXPORT_ jint JNICALL JNI_CreateJavaVM (JavaVM **pvm, void **penv, void *args)
		external
			"C inline use <jni.h>"
		alias
			"[
				return (FUNCTION_CAST (jint, (JavaVM **, void **, void *)) $a_creation_func) ((JavaVM **)$jvm, (void **)$env, (void *)$args)
			]"
		end

	c_destroy_jvm (jvm: POINTER): INTEGER
		external
			"C++ JavaVM use %"jni.h%""
		alias
			"DestroyJavaVM"
		end

	c_attach_current_thread (jvm: POINTER; env: POINTER; args: POINTER): INTEGER
		external
			"C++ JavaVM signature (void **, void *): EIF_INTEGER use %"jni.h%""
		alias
			"AttachCurrentThread"
		end

	c_detach_current_thread (jvm: POINTER): INTEGER
		external
			"C++ JavaVM use %"jni.h%""
		alias
			"DetachCurrentThread"
		end

note
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"




end

