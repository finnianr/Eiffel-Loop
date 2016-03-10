note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_WAVEFORM_FORMAT_ABS

inherit
	EL_WAV_FORMAT_CONSTANTS

feature -- Access

	format_description: STRING
			--  /* 1=PCM, 257=Mu-Law, 258=A-Law, 259=ADPCM */
		do
			inspect format
				when PCM_format then
					Result := "PCM"

				when MuLaw_format then
					Result := "Mu-Law"

				when ALaw_format then
					Result := "A-Law"

				when ADPCM_format then
					Result := "ADPCM"

				else
					Result := "Unknown"
			end
		end

	format: INTEGER_16
			--
		deferred
		end

feature -- Status query

	is_valid_format (a_format: INTEGER): BOOLEAN
			--
		do
			Result := Format_types.occurrences (a_format.to_integer_16) = 1
		end

end
