note
	description: "Factory for character codecs conforming to [$source EL_ZCODEC]"
	notes: "[
		This class must not have any dependencies on [$source ZSTRING] since it is used
		to set the `ZSTRING.codec'. See routine `default_codec'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-12-31 16:32:31 GMT (Friday 31st December 2021)"
	revision: "15"

frozen class
	EL_ZCODEC_FACTORY

inherit
	ANY

	EL_SHARED_UTF_8_ZCODEC

	EL_MODULE_EIFFEL

	EL_ENCODING_BASE
		export
			{NONE} all
			{ANY} valid_encoding
		end

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
		-- codec defined by command line option `-zstring_codec' or else
		-- instance of `EL_ISO_8859_15_ZCODEC' if command option not present
		local
			args: ARGUMENTS_32; i: INTEGER
			codec_name: STRING
		do
			create args
			create codec_name.make_empty
			from i := 1 until codec_name.count > 0 or else i > args.argument_count loop
				if args.argument (i) ~ Codec_option_name and then i < args.argument_count then
					codec_name := args.argument (i + 1).to_string_8
				end
				i := i + 1
			end
			if valid_name (codec_name) then
				Result := codec_by (name_to_encoding (codec_name))
			else
				Result := codec_by (Latin | 15)
			end
		end

feature {NONE} -- Factory

	new_codec (a_encoding: NATURAL): EL_ZCODEC
		require
			valid_encoding: valid_encoding (a_encoding)
		do
			if Codec_type_table.has_key (a_encoding)
				and then attached {EL_ZCODEC} Eiffel.new_object (Codec_type_table.found_item) as new
			then
				Result := new
				Result.make
			else
				Result := Utf_8_codec
			end
		end

feature -- Status query

	has_codec (a_encoding: EL_ENCODING_BASE): BOOLEAN
		do
			Result := valid_encoding (a_encoding.encoding)
		end

feature {NONE} -- Constants

	Codec_table: EL_CACHE_TABLE [EL_ZCODEC, NATURAL]
		once
			create Result.make_equal (30, agent new_codec)
		end

	Codec_type_table: EL_HASH_TABLE [TYPE [EL_ZCODEC], NATURAL]
		once
			create Result.make (<<
				[Latin | 1, {EL_ISO_8859_1_ZCODEC}],
				[Latin | 2, {EL_ISO_8859_2_ZCODEC}],
				[Latin | 3, {EL_ISO_8859_3_ZCODEC}],
				[Latin | 4, {EL_ISO_8859_4_ZCODEC}],
				[Latin | 5, {EL_ISO_8859_5_ZCODEC}],
				[Latin | 6, {EL_ISO_8859_6_ZCODEC}],
				[Latin | 7, {EL_ISO_8859_7_ZCODEC}],
				[Latin | 8, {EL_ISO_8859_8_ZCODEC}],
				[Latin | 9, {EL_ISO_8859_9_ZCODEC}],
				[Latin | 10, {EL_ISO_8859_10_ZCODEC}],
				[Latin | 11, {EL_ISO_8859_11_ZCODEC}],
--				ISO-8859-12 for Celtic languages was abandoned in 1997
				[Latin | 13, {EL_ISO_8859_13_ZCODEC}],
				[Latin | 14, {EL_ISO_8859_14_ZCODEC}],
				[Latin | 15, {EL_ISO_8859_15_ZCODEC}],

				[Windows | 1250, {EL_WINDOWS_1250_ZCODEC}],
				[Windows | 1251, {EL_WINDOWS_1251_ZCODEC}],
				[Windows | 1252, {EL_WINDOWS_1252_ZCODEC}],
				[Windows | 1253, {EL_WINDOWS_1253_ZCODEC}],
				[Windows | 1254, {EL_WINDOWS_1254_ZCODEC}],
				[Windows | 1255, {EL_WINDOWS_1255_ZCODEC}],
				[Windows | 1256, {EL_WINDOWS_1256_ZCODEC}],
				[Windows | 1257, {EL_WINDOWS_1257_ZCODEC}],
				[Windows | 1258, {EL_WINDOWS_1258_ZCODEC}]
			>>)
		end

	Codec_option_name: IMMUTABLE_STRING_32
		once
			Result := "-zstring_codec"
		end

end