note
	description: "TL musicbrainz translater"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-15 16:43:23 GMT (Wednesday 15th June 2022)"
	revision: "1"

class
	TL_MUSICBRAINZ_TRANSLATER

inherit
	EL_ENGLISH_NAME_TRANSLATER
		rename
			make as make_default,
			make_title as make
		redefine
			exported, imported
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

	Musicbrainz: STRING = "MusicBrainz "
		-- identifier with trailing space
end