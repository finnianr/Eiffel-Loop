note
	description: "Summary description for {EL_SHARED_CODEC_2}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-18 11:24:10 GMT (Monday 18th July 2016)"
	revision: "1"

class
	EL_SHARED_ZCODEC

inherit
	EL_SHARED_CELL [EL_ZCODEC]
		rename
			item as system_codec,
			set_item as set_system_codec,
			cell as Codec_cell
		end

feature {NONE} -- Implementation

	z_code_to_unicode (a_z_code: NATURAL): NATURAL
		require
			not_for_single_byte: a_z_code > 0xFF
		do
			if 0xE000 <= a_z_code and then a_z_code <= 0xF8FF then
				Result := a_z_code - 0xE000
			else
				Result := a_z_code
			end
		end

feature {NONE} -- Constants

	Codec_cell: CELL [EL_ZCODEC]
		once
			create Result.put (Default_codec)
		end

	Default_codec: EL_ZCODEC
		once
			create {EL_ISO_8859_15_ZCODEC} Result.make
		end

	Codec: EL_ZCODEC
			-- Working instance
			-- If it needs changing, set the system codec first before allowing calls here
		once
			Result := system_codec
		end
end