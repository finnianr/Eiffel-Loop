note
	description: "Reflected storable reference type table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-11 18:15:07 GMT (Sunday 11th December 2022)"
	revision: "12"

class
	EL_REFLECTED_STORABLE_REFERENCE_TYPE_TABLE

inherit
	EL_REFLECTED_REFERENCE_TYPE_TABLE [EL_REFLECTED_REFERENCE [ANY]]
		rename
			make as make_table
		end

	EL_REFLECTION_CONSTANTS

	EL_SHARED_CLASS_ID

create
	make

feature {NONE} -- Initialization

	make
		do
 			make_table (<<
				{EL_REFLECTED_STORABLE}, {EL_REFLECTED_BOOLEAN_REF}, {EL_REFLECTED_MANAGED_POINTER},
				{EL_REFLECTED_DATE}, {EL_REFLECTED_DATE_TIME}, {EL_REFLECTED_TIME}
			>>)
		end

end
