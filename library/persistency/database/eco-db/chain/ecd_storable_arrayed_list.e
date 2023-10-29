note
	description: "Storable arrayed list of objects conforming to [$source EL_STORABLE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-10-29 17:24:30 GMT (Sunday 29th October 2023)"
	revision: "1"

class
	ECD_STORABLE_ARRAYED_LIST  [G -> EL_STORABLE create make_default end]

inherit
	ECD_CHAIN [G]
		rename
			make_chain_implementation as make
		end

	ECD_ARRAYED_LIST [G]
		redefine
			make
		end

	EL_MODULE_BUILD_INFO

create
	make_from_file, make

feature {NONE} -- Initialization

	make (n: INTEGER)
		do
			if encrypter = Void then
				encrypter := Default_encrypter
			end
			if file_path = Void then
				create file_path
			end
			Precursor (n)
		end

feature -- Access

	software_version: NATURAL
		do
			Result := Build_info.version_number
		end
end