note
	description: "${EL_REFLECTED_REFERENCE} for field conforming to ${EL_REFLECTED_REFERENCE}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-25 17:27:29 GMT (Sunday 25th August 2024)"
	revision: "1"

class
	EL_REFLECTED_SUBSTRING

inherit
	EL_REFLECTED_REFERENCE [EL_SUBSTRING [STRING_GENERAL]]
		redefine
			reset, set_from_string, set_from_utf_8
		end

create
	make

feature -- Basic operations

	set_from_string (a_object: EL_REFLECTIVE; string: READABLE_STRING_GENERAL)
		local
			utf_8: EL_UTF_8_CONVERTER
		do
			set_from_utf_8 (a_object, utf_8.utf_32_string_to_string_8 (string))
		end

	set_from_utf_8 (a_object: EL_REFLECTIVE; utf_8: READABLE_STRING_8)
		do
			if attached value (a_object) as substring then
				substring.set_string (Immutable_8.as_shared (utf_8), 1, utf_8.count)
			end
		end

feature -- Basic operations

	reset (a_object: EL_REFLECTIVE)
		do
			if attached value (a_object) as substring then
				substring.wipe_out
			end
		end

end