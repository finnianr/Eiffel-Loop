note
	description: "Shared instance of class ${EL_CLASS_TYPE_ID_ENUM}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-15 9:56:41 GMT (Monday 15th April 2024)"
	revision: "5"

deferred class
	EL_SHARED_CLASS_ID

inherit
	EL_ANY_SHARED

feature -- Contract Support

	valid_string_storage_type (storage_type: CHARACTER): BOOLEAN
		do
			Result := Class_id.valid_string_storage_type (storage_type)
		end

feature {NONE} -- Constants

	Class_id: EL_CLASS_TYPE_ID_ENUM
		once
			create Result.make
		end
end