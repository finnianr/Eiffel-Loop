note
	description: "Reflected field conforming to temporal object [$source ABSOLUTE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-13 16:57:37 GMT (Tuesday 13th December 2022)"
	revision: "2"

deferred class
	EL_REFLECTED_TEMPORAL [G -> ABSOLUTE]

inherit
	EL_REFLECTED_REFERENCE [G]
		redefine
			append_to_string, group_type, to_string, set_from_readable
		end

feature -- Access

	group_type: TYPE [ANY]
		do
			Result := {ABSOLUTE}
		end

	to_string (a_object: EL_REFLECTIVE): READABLE_STRING_GENERAL
		do
			if attached value (a_object) as date_time then
				Result := date_time.out
			else
				create {STRING_8} Result.make_empty
			end
		end

feature -- Basic operations

	append_to_string (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			if attached value (a_object) as date_time then
				if attached {EL_DATE_TIME_UTILITY} date_time as el_date_time then
					el_date_time.default_append_to (str)
				else
					upgraded (date_time).default_append_to (str)
				end
			end
		end

	set_from_readable (a_object: EL_REFLECTIVE; readable: EL_READABLE)
		do
			set_from_string (a_object, readable.read_string_8)
		end

feature {NONE} -- Implementation

	upgraded (a_value: G): EL_DATE_TIME_UTILITY
		deferred
		end
end