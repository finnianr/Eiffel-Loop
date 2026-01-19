note
	description: "Country data table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-18 10:38:34 GMT (Sunday 18th December 2022)"
	revision: "1"

class
	COUNTRY_DATA_TABLE

inherit
	ECD_REFLECTIVE_RECOVERABLE_CHAIN [COUNTRY]
		select
			remove, extend, replace
		end

	ECD_ARRAYED_LIST [COUNTRY]
		rename
			make as make_chain_implementation,
			remove as chain_remove,
			extend as chain_extend,
			replace as chain_replace
		end

create
	make_from_file

feature -- Access

	software_version: NATURAL
		do
			Result := 1_00
		end

end