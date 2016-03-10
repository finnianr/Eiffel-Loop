note
	description: "Summary description for {EL_SHARED_ZCODEC_FACTORY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-29 13:20:57 GMT (Friday 29th January 2016)"
	revision: "6"

class
	EL_SHARED_ZCODEC_FACTORY

inherit
	EL_FACTORY_CLIENT

feature {NONE} -- Factory

	new_codec (encodeable: EL_ENCODEABLE_AS_TEXT): EL_ZCODEC
		require
			not_utf_encoded: not encodeable.is_utf_encoded
		do
			if encodeable.is_windows_encoded then
				Result := new_windows_codec (encodeable.encoding)
			elseif encodeable.is_latin_encoded then
				Result := new_iso_8859_codec (encodeable.encoding)
			else
				Result := new_iso_8859_codec (1)
			end
		end

	new_iso_8859_codec (id: INTEGER): EL_ISO_8859_ZCODEC
		require
			not_iso_8859_12: id /= 12
			valid_id: (1 |..| 15).has (id)
		do
			Result := ISO_8859_factory.instance_from_type (ISO_8859_codec [id], agent {EL_ISO_8859_ZCODEC}.make)
		end

	new_windows_codec (id: INTEGER): EL_WINDOWS_ZCODEC
		require
			valid_id: (1250 |..| 1258).has (id)
		do
			Result := Windows_factory.instance_from_type (Windows_codec [id], agent {EL_WINDOWS_ZCODEC}.make)
		end

feature {NONE} -- Constants

	ISO_8859_codec: ARRAY [TYPE [EL_ISO_8859_ZCODEC]]
		once
			create Result.make_filled ({EL_ISO_8859_1_ZCODEC}, 1, 15)
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
-- 		1SO-8859-12 is missing from C-source code
			Result [13] := {EL_ISO_8859_13_ZCODEC}
			Result [14] := {EL_ISO_8859_14_ZCODEC}
			Result [15] := {EL_ISO_8859_15_ZCODEC}
		end

	ISO_8859_factory: EL_OBJECT_FACTORY [EL_ISO_8859_ZCODEC]
		once
			create Result
		end

	Once_extendible_unencoded: EL_EXTENDABLE_UNENCODED_CHARACTERS
		local
			unencoded: EL_UNENCODED_CHARACTERS
		once
			create unencoded.make
			Result := unencoded.Once_extendible_unencoded
		end

	Windows_codec: ARRAY [TYPE [EL_WINDOWS_ZCODEC]]
		once
			create Result.make_filled ({EL_WINDOWS_1250_ZCODEC}, 1250, 1258)
			Result [1251] := {EL_WINDOWS_1251_ZCODEC}
			Result [1252] := {EL_WINDOWS_1252_ZCODEC}
			Result [1253] := {EL_WINDOWS_1253_ZCODEC}
			Result [1254] := {EL_WINDOWS_1254_ZCODEC}
			Result [1255] := {EL_WINDOWS_1255_ZCODEC}
			Result [1256] := {EL_WINDOWS_1256_ZCODEC}
			Result [1257] := {EL_WINDOWS_1257_ZCODEC}
			Result [1258] := {EL_WINDOWS_1258_ZCODEC}
		end

	Windows_factory: EL_OBJECT_FACTORY [EL_WINDOWS_ZCODEC]
		once
			create Result
		end

end
