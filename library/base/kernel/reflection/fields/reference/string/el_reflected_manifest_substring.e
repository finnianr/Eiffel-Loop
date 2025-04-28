note
	description: "${EL_REFLECTED_REFERENCE} for field conforming to ${EL_MANIFEST_SUBSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-28 10:21:53 GMT (Monday 28th April 2025)"
	revision: "4"

class
	EL_REFLECTED_MANIFEST_SUBSTRING

inherit
	EL_REFLECTED_REFERENCE [EL_MANIFEST_SUBSTRING [STRING_GENERAL, COMPARABLE]]
		redefine
			reset, set_from_string, set_from_utf_8
		end

create
	make

feature -- Basic operations

	set_from_string (object: ANY; string: READABLE_STRING_GENERAL)
		local
			utf_8: EL_UTF_8_CONVERTER
		do
			set_from_utf_8 (object, utf_8.utf_32_string_to_string_8 (string))
		end

	set_from_utf_8 (object: ANY; utf_8: READABLE_STRING_8)
		do
			if attached value (object) as substring then
				substring.set_string (Immutable_8.as_shared (utf_8), 1, utf_8.count)
			end
		end

feature -- Basic operations

	reset (object: ANY)
		do
			if attached value (object) as substring then
				substring.wipe_out
			end
		end

end