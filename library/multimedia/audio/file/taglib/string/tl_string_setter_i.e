note
	description: "Translate string to `wchar_t *' C array"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-03-17 12:56:12 GMT (Tuesday 17th March 2020)"
	revision: "2"

deferred class
	TL_STRING_SETTER_I [N -> NUMERIC]

inherit
	ARRAYED_LIST [N]
		rename
			make as make_list
		export
			{NONE} all
		end

	EL_MODULE_STRING_32

feature {NONE} -- Initialization

	make
		do
			create utf_16_sequence.make
			make_list (60)
		end

feature -- Basic operations

	set_text (target: TL_STRING; source: READABLE_STRING_GENERAL)
		local
			i, n: INTEGER; l_area: SPECIAL [CHARACTER_32]
			utf_16: like utf_16_sequence
		do
			wipe_out
			utf_16 := utf_16_sequence
			l_area := String_32.from_general (source, False).area; n := source.count
			from until i = n loop
				utf_16.set (l_area [i])
				append_sequence (utf_16)
				i := i + 1
			end
			utf_16.set (Null_character)
			append_sequence (utf_16)
			target.set_from_utf_16 (area)
		end

feature {NONE} -- Implementation

	append_sequence (utf_16: like utf_16_sequence)
		do
			extend_part (utf_16.lead)
			if utf_16.count = 2 then
				extend_part (utf_16.trail)
			end
		end

	extend_part (p: NATURAL)
		deferred
		end

feature {NONE} -- Internal attributes

	utf_16_sequence: EL_UTF_16_SEQUENCE

feature {NONE} -- Constants

	Null_character: CHARACTER_32 = '%/0/'

end
