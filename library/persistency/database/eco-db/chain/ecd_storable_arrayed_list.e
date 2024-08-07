note
	description: "Storable arrayed list of objects conforming to ${EL_STORABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-11 9:19:59 GMT (Thursday 11th July 2024)"
	revision: "4"

class
	ECD_STORABLE_ARRAYED_LIST  [G -> EL_STORABLE create make_default end]

inherit
	ECD_STORABLE_CHAIN [G]

	ECD_ARRAYED_LIST [G]
		rename
			make as make_chain_implementation
		end

	EL_MODULE_BUILD_INFO

create
	make_from_file, make

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			make_default
			create area_v2.make_empty (n)
		end

feature -- Access

	software_version: NATURAL
		do
			Result := Build_info.version_number
		end
end