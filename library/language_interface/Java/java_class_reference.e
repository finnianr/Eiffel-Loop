note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "3"

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

create
	make

feature {NONE} -- Initialization

	make (package_name, jclass_name: STRING)
			--
		do
			create qualified_class_name.make_empty
			if package_name.count > 0 then
				qualified_class_name.append_string (package_name)
				qualified_class_name.append_character ('.')
			end
			qualified_class_name.append_string (jclass_name)
			java_class_id := jni.find_class_pointer (qualified_jni_class_name)

		end

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

	qualified_jni_class_name: STRING
			--
		do
			create Result.make_from_string (qualified_class_name)
			Result.replace_substring_all (".","/")
		end

end -- class JAVA_CLASS_REFERENCE
