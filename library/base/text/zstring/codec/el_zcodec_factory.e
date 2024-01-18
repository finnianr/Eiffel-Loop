note
	description: "Factory for character codecs conforming to ${EL_ZCODEC}"
	notes: "[
		This class must not have any dependencies on ${ZSTRING} since it is used
		to set the `ZSTRING.codec'. See routine `default_codec'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-25 10:29:39 GMT (Monday 25th December 2023)"
	revision: "21"

frozen class
	EL_ZCODEC_FACTORY

inherit
	ARGUMENTS_32
		export
			{NONE} all
		end

	EL_SHARED_UTF_8_ZCODEC

	EL_MODULE_EIFFEL; EL_MODULE_ENCODING

	EL_ENCODING_TYPE
		rename
			valid_encoding as valid_encoding_constant
		export
			{NONE} all
		end

	EL_STRING_8_CONSTANTS

feature -- Access

	codec (a_encoding: EL_ENCODING_BASE): EL_ZCODEC
		-- cached codec
		require
			has_codec: has_codec (a_encoding)
		do
			Result := codec_by (a_encoding.encoding)
		end

	codec_by (a_encoding: NATURAL): EL_ZCODEC
		require
			valid_encoding: valid_encoding (a_encoding)
		do
			Result := Codec_table.item (a_encoding)
		end

	zstring_codec: EL_ZCODEC
		-- user specified code for use with `ZSTRING' defined by command line option `-zstring_codec' or else
		-- instance of `EL_ISO_8859_15_ZCODEC' by default
		local
			i: INTEGER; codec_name: READABLE_STRING_GENERAL; l_encoding: NATURAL
		do
			codec_name := Empty_string_8
			from i := 1 until codec_name.count > 0 or else i > argument_count loop
				if argument (i).same_string_general (Codec_option_name) and then i < argument_count then
					codec_name := argument (i + 1)
				end
				i := i + 1
			end
			l_encoding := Encoding.name_to_encoding (codec_name)
			inspect l_encoding & Class_mask
				when Latin, Windows then
					Result := codec_by (l_encoding)
			else
				Result := codec_by (Latin | 15)
			end
		end

feature {NONE} -- Factory

	new_codec (a_encoding: NATURAL): EL_ZCODEC
		require
			valid_encoding: valid_encoding (a_encoding)
			valid_windows_index: Codec_type_array [14] ~ {EL_ISO_8859_15_ZCODEC}
			valid_windows_index: Codec_type_array [Windows_1250_index] ~ {EL_WINDOWS_1250_ZCODEC}
		local
			id, index: INTEGER
		do
			if a_encoding = Utf_8 then
				Result := Utf_8_codec

			elseif valid_encoding (a_encoding) then
				id := (a_encoding & Id_mask).to_integer_32
				inspect a_encoding & Class_mask
					when Latin then
						if id > 12 then
							index := id - 1
						else
							index := id
						end
					when Windows then
						index := id - 1250 + Windows_1250_index
				end
				if Codec_type_array.valid_index (index)
					and then attached {EL_ZCODEC} Eiffel.new_object (Codec_type_array [index]) as new
				then
					Result := new; Result.make
				else
					Result := Utf_8_codec
				end
			else
				Result := Utf_8_codec
			end
		end

feature -- Status query

	has_codec (a_encoding: EL_ENCODING_BASE): BOOLEAN
		do
			Result := valid_encoding (a_encoding.encoding)
		end

	valid_encoding (a_encoding: NATURAL): BOOLEAN
		do
			if a_encoding = Utf_8 then
				Result := True
			else
				inspect a_encoding & Class_mask
					when Latin then
						Result := Encoding.valid_latin (a_encoding & Id_mask)
					when Windows then
						Result := Encoding.valid_windows (a_encoding & Id_mask)
				else
				end
			end
		end

feature {NONE} -- Implementation

	new_codec_types: TUPLE [
--		Latin
		EL_ISO_8859_1_ZCODEC,
		EL_ISO_8859_2_ZCODEC,
		EL_ISO_8859_3_ZCODEC,
		EL_ISO_8859_4_ZCODEC,
		EL_ISO_8859_5_ZCODEC,
		EL_ISO_8859_6_ZCODEC,
		EL_ISO_8859_7_ZCODEC,
		EL_ISO_8859_8_ZCODEC,
		EL_ISO_8859_9_ZCODEC,
		EL_ISO_8859_10_ZCODEC,
		EL_ISO_8859_11_ZCODEC,
--		ISO-8859-12 for Celtic languages was abandoned in 1997
		EL_ISO_8859_13_ZCODEC,
		EL_ISO_8859_14_ZCODEC,
		EL_ISO_8859_15_ZCODEC,

--		Windows
		EL_WINDOWS_1250_ZCODEC,
		EL_WINDOWS_1251_ZCODEC,
		EL_WINDOWS_1252_ZCODEC,
		EL_WINDOWS_1253_ZCODEC,
		EL_WINDOWS_1254_ZCODEC,
		EL_WINDOWS_1255_ZCODEC,
		EL_WINDOWS_1256_ZCODEC,
		EL_WINDOWS_1257_ZCODEC,
		EL_WINDOWS_1258_ZCODEC
	]
		do
			create Result
		end

feature {NONE} -- Constants

	Codec_type_array: EL_TUPLE_TYPE_LIST [EL_ZCODEC]
		once
			create Result.make_from_tuple (new_codec_types)
		end

	Codec_option_name: STRING = "-zstring_codec"

	Codec_table: EL_AGENT_CACHE_TABLE [EL_ZCODEC, NATURAL]
		once
			create Result.make_equal (30, agent new_codec)
		end

	Windows_1250_index: INTEGER
		once
			Result := Codec_type_array.index_of ({EL_WINDOWS_1250_ZCODEC}, 1)
		end

end