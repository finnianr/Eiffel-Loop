note
	description: "Java class reference"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-31 11:22:07 GMT (Monday 31st March 2025)"
	revision: "10"

class
	JAVA_CLASS_REFERENCE

inherit
	JAVA_OBJECT_OR_CLASS
		undefine
			is_equal
		end

	JAVA_CLASS
		rename
			object_method as obsolete_object_method,
			object_attribute as obsolete_object_attribute,
			make as obsolete_make,
			name as qualified_class_name
		undefine
			obsolete_object_method,
			obsolete_object_attribute
		end

	EL_CHARACTER_8_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (package_name, jclass_name: STRING)
			--
		local
			sg: EL_STRING_GENERAL_ROUTINES
		do
			if package_name.count > 0 then
				qualified_class_name := Dot.joined (package_name, jclass_name)
			else
				qualified_class_name := jclass_name
			end
			create jni_type_signature.make (qualified_class_name.count + 2)
			jni_type_signature.append (qualified_class_name)
			sg.super_8 (jni_type_signature).replace_character ('.', '/')
			-- use in intermediate stage
			java_class_id := jni.find_class_pointer (jni_type_signature)

			-- finish off
			jni_type_signature.prepend_character ('L')
			jni_type_signature.append_character (';')
		end

feature -- Access

	jni_type_signature: STRING
		-- a fully-qualified class name (that is, a package name, delimited by "/",
		-- followed by the class name).
		-- If the name begins with "[" (the array jni_type_name character),
		-- it returns an array class.

feature -- calling static methods

	object_method (lmethod_id: POINTER; args: JAVA_ARGS): POINTER
			--
		local
			argp: POINTER
		do
			if args /= Void then
				argp := args.to_c
			end
			Result := jni.call_static_object_method (java_class_id, lmethod_id, argp)
		end

feature -- Access to static attributes

	object_attribute (fid: POINTER): POINTER
			-- get the value of OBJECT static field
		do
			Result := jni.get_static_object_field (java_class_id, fid)
		end

end