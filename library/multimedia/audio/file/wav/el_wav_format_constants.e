note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:36 GMT (Thursday 11th December 2014)"
	revision: "3"

class
	EL_WAV_FORMAT_CONSTANTS

feature -- Constants

	ID_RIFF: STRING = "RIFF"

	ID_WAVE: STRING = "WAVE"

	ID_fmt: STRING = "fmt "

	ID_data: STRING = "data"

	Standard_header_size: INTEGER = 44

	RIFF_chunk_header_size: INTEGER = 8

	Size_of_WAVE_chunk_section: INTEGER = 16
			-- Usually 16 (or 0x10).

			--| The size of the WAVE type format (2 bytes)
			--| 	+ mono/stereo flag (2 bytes) + sample rate (4 bytes)
			--|		+ bytes/sec (4 bytes) + block alignment (2 bytes) + bits/sample (2 bytes).

	Size_of_chunk_id: INTEGER = 4

	Format_types: ARRAY [INTEGER_16]
			--
		once
			Result := <<PCM_format, MuLaw_format, ALaw_format, ADPCM_format>>
		end

	PCM_format: INTEGER_16 = 1

	MuLaw_format: INTEGER_16 = 257

	ALaw_format: INTEGER_16 = 258

	ADPCM_format: INTEGER_16 = 259

end
