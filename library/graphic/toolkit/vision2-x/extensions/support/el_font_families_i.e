note
	description: "Compact list of fonts available on system"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-07 8:30:35 GMT (Monday 7th August 2023)"
	revision: "2"

deferred class
	EL_FONT_FAMILIES_I

inherit
	EV_ENVIRONMENT
		export
			{NONE} all
		redefine
			initialize
		end

	EL_LAZY_ATTRIBUTE
		rename
			item as monospace_list,
			new_item as new_monospace_list,
			actual_item as actual_monospace_list
		undefine
			copy, default_create
		end

	EL_MODULE_TEXT

feature {NONE} -- Initialization

	initialize
		local
		do
			Precursor
			create general_list.make (new_font_families)
			general_list.sort (True)
		end

feature -- Access

	general_list: EL_COMPACT_ZSTRING_LIST
		-- alphabetically sorted list of font families

feature {NONE} -- Implementation

	new_monospace_list: like general_list
		do
			create Result.make (general_list.query_if (agent is_monospace))
		end

	is_monospace (family: ZSTRING): BOOLEAN
		do
			Result := Text.is_monospace (family)
		end

	new_font_families: LIST [STRING_32]
		deferred
		ensure
			not_empty: Result.count > 0
		end
end