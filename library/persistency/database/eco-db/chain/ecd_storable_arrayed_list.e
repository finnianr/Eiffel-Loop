note
	description: "Storable arrayed list of objects conforming to ${EL_STORABLE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "3"

class
	ECD_STORABLE_ARRAYED_LIST  [G -> EL_STORABLE create make_default end]

inherit
	ECD_CHAIN [G]

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