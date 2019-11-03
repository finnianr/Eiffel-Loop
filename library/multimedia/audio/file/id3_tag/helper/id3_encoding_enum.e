note
	description: "Encoding enumeration based on Underbit C representation"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-10 22:47:15 GMT (Thursday 10th October 2019)"
	revision: "1"

class
	ID3_ENCODING_ENUM

inherit
	EL_ENUMERATION [NATURAL_8]
		rename
			export_name as to_upper_snake_case,
			import_name as from_upper_snake_case
		redefine
			initialize_fields
		end

create
	make

feature {NONE} -- Initialization

	initialize_fields
		do
			Unknown := 0xFF
			ISO_8859_1 :=	{UNDERBIT_ID3_C_API}.Encoding_ISO_8859_1.to_natural_8
			UTF_8 :=			{UNDERBIT_ID3_C_API}.Encoding_UTF_8.to_natural_8
			UTF_16 :=		{UNDERBIT_ID3_C_API}.Encoding_UTF_16.to_natural_8
			UTF_16_BE :=	{UNDERBIT_ID3_C_API}.Encoding_UTF_16_BE.to_natural_8

			create libid3_table.make (<<
				[ISO_8859_1,	{LIBID3_CONSTANTS}.Encoding_ISO8859_1],
				[UTF_16,			{LIBID3_CONSTANTS}.Encoding_UTF16],
				[UTF_16_BE,		{LIBID3_CONSTANTS}.Encoding_UTF16BE],
				[UTF_8,			{LIBID3_CONSTANTS}.Encoding_UTF8],
				[unknown,		{LIBID3_CONSTANTS}.Encoding_NONE]
			>>)
			create underbit_table.make (libid3_table.count)
			across libid3_table as code loop
				underbit_table.extend (code.key, code.item)
			end
		end

feature -- Access

	ISO_8859_1: NATURAL_8

	UTF_16: NATURAL_8

	UTF_16_BE: NATURAL_8

	UTF_8: NATURAL_8

	Unknown: NATURAL_8

feature -- Conversion

	to_libid3 (code: NATURAL_8): INTEGER
		-- Underbit -> libid3
		do
			Result := libid3_table [code]
		end

	from_libid3 (libid3_code: INTEGER): NATURAL_8
		-- libid3 -> Underbit
		do
			Result := underbit_table [libid3_code]
		end

feature {NONE} -- Internal attributes

	libid3_table: EL_HASH_TABLE [INTEGER, NATURAL_8]

	underbit_table: HASH_TABLE [NATURAL_8, INTEGER]
end
