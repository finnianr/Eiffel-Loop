note
	description: "Shared instance of class ${EL_CLASS_TYPE_ID_ENUM}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-11 8:12:55 GMT (Thursday 11th April 2024)"
	revision: "4"

deferred class
	EL_SHARED_CLASS_ID

inherit
	EL_ANY_SHARED

feature -- Contract Support

	valid_string_type_code (code: CHARACTER): BOOLEAN
		do
			Result := Class_id.valid_character_byte_code (code)
		end

feature {NONE} -- Constants

	Class_id: EL_CLASS_TYPE_ID_ENUM
		once
			create Result.make
		end
end