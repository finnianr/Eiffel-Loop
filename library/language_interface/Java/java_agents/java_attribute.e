note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2011-07-24 9:48:03 GMT (Sunday 24th July 2011)"
	revision: "1"

class
	JAVA_ATTRIBUTE [
		BASE_TYPE -> JAVA_OBJECT_REFERENCE,
		RESULT_TYPE -> JAVA_TYPE create default_create, make_from_java_attribute end
	]

inherit
	JAVA_ROUTINE [BASE_TYPE]
		rename
			method_id as field_id,
			set_method_id as set_field_id
		redefine
			set_field_id
		end

create
	make

feature -- Access

	item (target: BASE_TYPE): RESULT_TYPE
			--
		do
			create Result.make_from_java_attribute (target, field_id)
		end

feature {NONE} -- Implementation

	set_field_id (attribute_name: STRING; mapped_routine: ROUTINE [BASE_TYPE, TUPLE])
			--
		do
			if attached {BASE_TYPE} mapped_routine.target as target then
				field_id := target.field_id (attribute_name, return_type_signature)
			end
		end

	return_type_signature: STRING
			-- Routines return type void
		local
			sample_attribute: RESULT_TYPE
		do
			create sample_attribute
			Result := sample_attribute.jni_type_signature
		end

end -- class JAVA_ATTRIBUTE
