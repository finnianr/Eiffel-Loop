note
	description: "Routines to query compact ${NATURAL_32} version numbers like 01_02_03"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-29 10:39:29 GMT (Wednesday 29th November 2023)"
	revision: "1"

expanded class
	EL_COMPACT_VERSION_ROUTINES

inherit
	EL_EXPANDED_ROUTINES

feature -- Measurement

	major (ver: NATURAL): NATURAL
		do
			Result := ver // 1_00_00
		end

	minor (ver: NATURAL): NATURAL
		do
			Result := (ver \\ 1_00_00) // 1_00
		end

	release (ver: NATURAL): NATURAL
		do
			Result := ver \\ 1_00
		end

end