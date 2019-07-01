note
	description: "Defines codec to be used by class [$source EL_ZSTRING] for encoding characters in `area'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:13 GMT (Thursday 20th September 2018)"
	revision: "5"

deferred class
	EL_SHARED_ZCODEC

inherit
	EL_SHARED_CELL [EL_ZCODEC]
		rename
			item as system_codec,
			set_item as set_system_codec,
			cell as Codec_cell
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
