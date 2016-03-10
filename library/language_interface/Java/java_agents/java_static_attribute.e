note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-18 10:21:57 GMT (Tuesday 18th December 2012)"
	revision: "1"

class
	JAVA_STATIC_ATTRIBUTE [
		BASE_TYPE -> JAVA_OBJECT_REFERENCE,
		RESULT_TYPE -> JAVA_TYPE create default_create, make_from_java_attribute end
	]

inherit
	JAVA_ATTRIBUTE [BASE_TYPE, RESULT_TYPE]
		redefine
			valid_target, item, set_field_id
		end

create
	make

feature -- Basic operations

	item (target: BASE_TYPE): RESULT_TYPE
			--
		do
			create Result.make_from_java_attribute (target.jclass, field_id)
		end

feature -- Status Report

	valid_target (target: BASE_TYPE): BOOLEAN
			--
		do
			Result := attached {JAVA_CLASS_REFERENCE} target.jclass as target_class and then is_attached (target_class.java_class_id)
		end

feature {NONE} -- Implementation

	set_field_id (attribute_name: STRING; mapped_routine: ROUTINE [BASE_TYPE, TUPLE])
			--
		do
			if attached {BASE_TYPE} mapped_routine.target as target then
				field_id := target.jclass.field_id (attribute_name, return_type_signature)
			end
		end

end -- class JAVA_STATIC_ATTRIBUTE
