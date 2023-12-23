note
	description: "TagLib musicbrainz translater"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-23 9:24:16 GMT (Saturday 23rd December 2023)"
	revision: "5"

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

	exported (eiffel_name: READABLE_STRING_8): STRING
		-- `eiffel_name' exported to a foreign naming convention
		do
			Result := Musicbrainz + Precursor (eiffel_name)
		end

	imported (foreign_name: READABLE_STRING_8): STRING
		-- `foreign_name' translated to Eiffel attribute-naming convention
		do
			Result := Precursor (foreign_name)
			Result.remove_head (Musicbrainz.count)
			Result.trim
		end

feature {NONE} -- Constants

	Default_case: NATURAL_8
		once
			Result := {EL_CASE}.Proper
		end

	Musicbrainz: STRING = "MusicBrainz "
		-- identifier with trailing space
end