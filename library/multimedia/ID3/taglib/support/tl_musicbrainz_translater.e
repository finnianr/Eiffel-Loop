note
	description: "TagLib musicbrainz translater"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-27 8:30:23 GMT (Monday 27th June 2022)"
	revision: "2"

class
	TL_MUSICBRAINZ_TRANSLATER

inherit
	EL_ENGLISH_NAME_TRANSLATER
		redefine
			exported, imported, Default_case
		end

create
	make

feature -- Conversion

	exported (eiffel_name: STRING): STRING
		-- `eiffel_name' exported to a foreign naming convention
		do
			Result := Musicbrainz + Precursor (eiffel_name)
		end

	imported (foreign_name: STRING): STRING
		-- `foreign_name' translated to Eiffel attribute-naming convention
		do
			Result := Precursor (foreign_name)
			Result.remove_head (Musicbrainz.count)
			Result.trim
		end

feature {NONE} -- Constants

	Default_case: NATURAL
		once
			Result := {EL_CASE}.title
		end

	Musicbrainz: STRING = "MusicBrainz "
		-- identifier with trailing space
end