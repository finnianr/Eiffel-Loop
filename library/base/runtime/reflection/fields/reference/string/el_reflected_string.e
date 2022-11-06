note
	description: "Reflected field that conforms to [$source READABLE_STRING_GENERAL]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-06 17:21:06 GMT (Sunday 6th November 2022)"
	revision: "22"

deferred class
	EL_REFLECTED_STRING [S -> READABLE_STRING_GENERAL create make end]

inherit
	EL_REFLECTED_HASHABLE_REFERENCE [S]
		rename
			set_from_string as set_from_string_general
		undefine
			reset, set_from_readable, set_from_memory, write, write_to_memory
		redefine
			append_to_string, to_string, set_from_string_general
		end

	STRING_HANDLER undefine is_equal end

feature -- Access

	to_string (a_object: EL_REFLECTIVE): S
		do
			Result := value (a_object)
		end

feature -- Basic operations

	append_to_string (a_object: EL_REFLECTIVE; str: ZSTRING)
		do
			if attached value (a_object) as v then
				str.append_string_general (v)
			end
		end

	set_from_node (a_object: EL_REFLECTIVE; node: EL_STRING_NODE)
		deferred
		end

	set_from_string_general (a_object: EL_REFLECTIVE; general: READABLE_STRING_GENERAL)
		local
			new: S
		do
			if attached {S} general as str then
				new := str
			elseif attached value (a_object) as str then
				new := replaced (str, general)
			else
				new := replaced (create {S}.make (general.count), general)
			end
			set (a_object, new)
		ensure then
			same_string: value (a_object).same_string (general)
		end

feature {NONE} -- Implementation

	replaced (str: S; content: READABLE_STRING_GENERAL): S
		deferred
		end

end