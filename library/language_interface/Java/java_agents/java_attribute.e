note
	description: "Java attribute"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	JAVA_ATTRIBUTE [RESULT_TYPE -> JAVA_TYPE create default_create, make_from_java_attribute end]

inherit
	JAVA_ROUTINE
		rename
			method_name as attribute_name,
			method_id as field_id,
			set_method_id as set_field_id
		redefine
			set_field_id
		end

create
	make

feature -- Access

	item (target: JAVA_OBJECT_REFERENCE): RESULT_TYPE
			--
		do
			create Result.make_from_java_attribute (target, field_id)
		end

feature {NONE} -- Implementation

	set_field_id (target: JAVA_OBJECT_REFERENCE; argument_types: EL_TUPLE_TYPE_ARRAY)
			--
		do
			field_id := target.field_id (attribute_name, return_type_signature)
		end

	return_type_signature: STRING
			-- Routines return type void
		local
			sample_attribute: RESULT_TYPE
		do
			create sample_attribute
			Result := sample_attribute.jni_type_signature
		end

end