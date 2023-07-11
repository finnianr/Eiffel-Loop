note
	description: "Object that encodes text using an encoding specified by `encoding' field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-10 14:28:49 GMT (Monday 10th July 2023)"
	revision: "15"

class
	EL_ENCODEABLE_AS_TEXT

inherit
	ANY

	EL_ENCODING_BASE
		rename
			id as encoding_id,
			name as encoding_name,
			type as encoding_type,
			same_as as same_encoding,

			set_default as set_default_encoding,
			set_from_name as set_encoding_from_name,
			set_from_other as set_encoding_from_other,
			set_latin as set_latin_encoding,
			set_iso_8859 as set_iso_8859_encoding,
			set_utf as set_utf_encoding,
			set_windows as set_windows_encoding
		redefine
			set_encoding, make_default
		end

create
	make, make_default

feature {NONE} -- Initialization

	make_default
		do
			create on_encoding_change.make
			Precursor
		end

feature -- Access

	on_encoding_change: EL_EVENT_BROADCASTER

feature -- Element change

	frozen set_encoding (a_encoding: NATURAL)
			--
		local
			changed: BOOLEAN
		do
			changed := encoding /= a_encoding
			encoding := a_encoding
			if changed then
				on_encoding_change.notify
			end
		end

end