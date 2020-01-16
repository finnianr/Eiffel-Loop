note
	description: "Object that encodes text using an encoding specified by `encoding' field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-15 17:55:58 GMT (Wednesday 15th January 2020)"
	revision: "8"

class
	EL_ENCODEABLE_AS_TEXT

inherit
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

	EL_EVENT_BROADCASTER
		rename
			add_listener as add_encoding_change_listener,
			add_agent_listener as add_encoding_change_action
		export
			{NONE} all
		redefine
			make_default
		end

create
	make_default, make_utf_8, make_latin_1

feature {NONE} -- Initialization

	make_default
		do
			Precursor {EL_EVENT_BROADCASTER}
			Precursor {EL_ENCODING_BASE}
		end

feature -- Element change

	frozen set_encoding (type, id: INTEGER)
			--
		local
			changed: BOOLEAN
		do
			changed := encoding_bitmap /= type | id
			encoding_bitmap := type | id
			if changed then
				notify
			end
		end

end
