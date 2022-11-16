note
	description: "Java static attribute"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "6"

class
	JAVA_STATIC_ATTRIBUTE [RESULT_TYPE -> JAVA_TYPE create default_create, make_from_java_attribute end]

inherit
	JAVA_ATTRIBUTE [RESULT_TYPE]
		redefine
			valid_target, item, set_field_id
		end

create
	make

feature -- Basic operations

	item (target: JAVA_OBJECT_REFERENCE): RESULT_TYPE
			--
		do
			create Result.make_from_java_attribute (target.jclass, field_id)
		end

feature -- Status Report

	valid_target (target: JAVA_OBJECT_REFERENCE): BOOLEAN
			--
		do
			if attached {JAVA_CLASS_REFERENCE} target.jclass as target_class then
				Result := is_attached (target_class.java_class_id)
			end
		end

feature {NONE} -- Implementation

	set_field_id (target: JAVA_OBJECT_REFERENCE; argument_types: EL_TUPLE_TYPE_ARRAY)
			--
		do
			field_id := target.jclass.field_id (attribute_name, return_type_signature)
		end

end