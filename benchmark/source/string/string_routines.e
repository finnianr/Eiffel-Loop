note
	description: "String routines for benchmarking"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-06 18:41:00 GMT (Tuesday 6th August 2024)"
	revision: "2"

deferred class
	STRING_ROUTINES [S -> STRING_GENERAL]

feature -- Concatenation

	append (target, str: S)
		deferred
		end

	append_general (target: S; str: READABLE_STRING_GENERAL)
		deferred
		end

	append_utf_8 (target: S; utf_8: STRING)
		deferred
		end

	prepend (target, str: S)
		deferred
		end

	prepend_general (target: S; str: READABLE_STRING_GENERAL)
		deferred
		end

feature -- Status query

	ends_with (target, str: S): BOOLEAN
		deferred
		end

	ends_with_general (target: S; str: READABLE_STRING_GENERAL): BOOLEAN
		deferred
		end

	starts_with (target, str: S): BOOLEAN
		deferred
		end

	starts_with_general (target: S; str: READABLE_STRING_GENERAL): BOOLEAN
		deferred
		end

feature -- Conversion

	to_latin_1 (string: S): STRING
		deferred
		end

	to_utf_8 (string: S): STRING
		deferred
		end

	xml_escaped (target: S): S
		deferred
		end

feature -- Basic operations

	insert_character (target: S; uc: CHARACTER_32; i: INTEGER)
		deferred
		end

	insert_string (target, insertion: S; index: INTEGER)
		deferred
		end

	prune_all (target: S; uc: CHARACTER_32)
		deferred
		end

	remove_substring (target: S; start_index, end_index: INTEGER)
		deferred
		end

	replace_character (target: S; uc_old, uc_new: CHARACTER_32)
		deferred
		end

	replace_substring (target, insertion: S; start_index, end_index: INTEGER)
		deferred
		end

	replace_substring_all (target, original, new: S)
		deferred
		end

	to_lower (string: S)
		deferred
		end

	to_upper (string: S)
		deferred
		end

	translate (target, old_characters, new_characters: S)
		deferred
		end

	translate_general (str: S; old_characters, new_characters: READABLE_STRING_GENERAL)
		deferred
		end

	wipe_out (str: S)
		deferred
		end

end