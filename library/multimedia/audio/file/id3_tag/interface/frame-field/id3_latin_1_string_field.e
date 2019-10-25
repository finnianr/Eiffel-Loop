note
	description: "Id3 latin 1 string field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-10 9:32:08 GMT (Thursday   10th   October   2019)"
	revision: "1"

deferred class
	ID3_LATIN_1_STRING_FIELD

inherit
	ID3_FRAME_FIELD

feature -- Access

	string: STRING_8
			--
		deferred
		end

	type: NATURAL_8
		do
			Result := Field_type.latin_1_string
		end

feature -- Element change

	set_string (str: like string)
			--
		deferred
		ensure
			is_set: string ~ str
		end
end
