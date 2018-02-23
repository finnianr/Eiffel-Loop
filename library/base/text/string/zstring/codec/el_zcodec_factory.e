note
	description: "Factory for character codecs"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-09-29 7:33:05 GMT (Thursday 29th September 2016)"
	revision: "2"

class
	EL_ZCODEC_FACTORY

inherit
	EL_FACTORY_CLIENT

feature {NONE} -- Factory

	new_codec (encodeable: EL_ENCODEABLE_AS_TEXT): EL_ZCODEC
		require
			has_codec: has_codec (encodeable)
		do
			if encodeable.is_utf_encoding (8) then
				create {EL_UTF_8_ZCODEC} Result.make
				
			elseif encodeable.is_windows_encoded or encodeable.is_latin_encoded then
				Result := Codec_factory.instance_from_type (Codec_table [encodeable.encoding_id], agent {EL_ZCODEC}.make)
			else
				create {EL_ISO_8859_1_ZCODEC} Result.make
			end
		end

feature {NONE} -- Status query

	has_codec (encodeable: EL_ENCODEABLE_AS_TEXT): BOOLEAN
		do
			if encodeable.is_windows_encoded or encodeable.is_latin_encoded then
				Result := Codec_table.has_key (encodeable.encoding_id)

			elseif encodeable.is_utf_encoded then
				Result := encodeable.encoding_id = 8
			end
		end

feature {NONE} -- Constants

	Codec_table: HASH_TABLE [TYPE [EL_ZCODEC], INTEGER]
		once
			create Result.make (30)
			Result [1] := {EL_ISO_8859_1_ZCODEC}
			Result [2] := {EL_ISO_8859_2_ZCODEC}
			Result [3] := {EL_ISO_8859_3_ZCODEC}
			Result [4] := {EL_ISO_8859_4_ZCODEC}
			Result [5] := {EL_ISO_8859_5_ZCODEC}
			Result [6] := {EL_ISO_8859_6_ZCODEC}
			Result [7] := {EL_ISO_8859_7_ZCODEC}
			Result [8] := {EL_ISO_8859_8_ZCODEC}
			Result [9] := {EL_ISO_8859_9_ZCODEC}
			Result [10] := {EL_ISO_8859_10_ZCODEC}
			Result [11] := {EL_ISO_8859_11_ZCODEC}

-- 		1SO-8859-12 is not available as it was missing from the original C-source code
--			used to generate codecs

			Result [13] := {EL_ISO_8859_13_ZCODEC}
			Result [14] := {EL_ISO_8859_14_ZCODEC}
			Result [15] := {EL_ISO_8859_15_ZCODEC}

			Result [1251] := {EL_WINDOWS_1251_ZCODEC}
			Result [1252] := {EL_WINDOWS_1252_ZCODEC}
			Result [1253] := {EL_WINDOWS_1253_ZCODEC}
			Result [1254] := {EL_WINDOWS_1254_ZCODEC}
			Result [1255] := {EL_WINDOWS_1255_ZCODEC}
			Result [1256] := {EL_WINDOWS_1256_ZCODEC}
			Result [1257] := {EL_WINDOWS_1257_ZCODEC}
			Result [1258] := {EL_WINDOWS_1258_ZCODEC}
		end

	Codec_factory: EL_OBJECT_FACTORY [EL_ZCODEC]
		once
			create Result
		end

end
