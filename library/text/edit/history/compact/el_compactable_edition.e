note
	description: "String edition for ${EL_STRING_EDITION_HISTORY} that can be compacted to a ${NATURAL_64} number"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-18 14:53:28 GMT (Thursday 18th July 2024)"
	revision: "1"

deferred class
	EL_COMPACTABLE_EDITION

inherit
	EL_COMPACTABLE_REFLECTIVE
		rename
			compact_natural_64 as compact_edition,
			make_from_natural_64 as make_from_compact_edition
		export
			{NONE} all
			{ANY} compact_edition
		end

feature -- Access

	edition_code: NATURAL_8
		-- edition operation code

end