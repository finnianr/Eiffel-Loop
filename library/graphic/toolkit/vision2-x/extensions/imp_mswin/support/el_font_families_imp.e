note
	description: "Windows implementation of [$source EL_FONT_FAMILIES_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-02 5:23:08 GMT (Wednesday 2nd August 2023)"
	revision: "1"

class
	EL_FONT_FAMILIES_IMP

inherit
	EL_FONT_FAMILIES_I
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
		do
			property_table := new_property_table
		end

feature {NONE} -- Implementation

	new_property_table: EL_IMMUTABLE_UTF_8_TABLE
		local
			enumerator: EL_WEL_FONT_ENUMERATOR_IMP
		do
			create enumerator
			Result := enumerator.new_property_table
		end
end
