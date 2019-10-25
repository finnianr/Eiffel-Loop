note
	description: "Object that encodes text using an encoding specified by `encoding' field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-09 10:14:08 GMT (Wednesday   9th   October   2019)"
	revision: "6"

class
	EL_ENCODEABLE_AS_TEXT

inherit
	EL_ENCODING_BASE
		rename
			id as encoding_id,
			name as encoding_name,
			type as encoding_type,
			is_valid as is_valid_encoding,
			is_latin_id as is_latin_encoding,
			is_utf_id as is_utf_encoding,
			is_windows_id as is_windows_encoding,
			is_type_latin as is_latin_encoding_type,
			is_type_utf as is_utf_encoding_type,
			is_type_windows as is_windows_encoding_type,
			same_as as same_encoding,

			set_default as set_default_encoding,
			set_from_name as set_encoding_from_name,
			set_from_other as set_encoding_from_other,
			set_latin as set_latin_encoding,
			set_iso_8859 as set_iso_8859_encoding,
			set_utf as set_utf_encoding,
			set_windows as set_windows_encoding

		redefine
			set_encoding, make_default,  make_latin_1, make_utf_8
		end

create
	make_default, make_utf_8, make_latin_1

feature {NONE} -- Initialization

	make_default
		do
			create encoding_change_actions
			Precursor
		end

	make_latin_1
		do
			create encoding_change_actions
			Precursor
		end

	make_utf_8
		do
			create encoding_change_actions
			Precursor
		end

feature -- Access

	encoding_change_actions: ACTION_SEQUENCE

feature -- Element change

	frozen set_encoding (type, id: INTEGER)
			--
		local
			changed: BOOLEAN
		do
			changed := encoding_bitmap /= type | id
			encoding_bitmap := type | id
			if changed and then not encoding_change_actions.is_empty then
				encoding_change_actions.call ([])
			end
		end

end
