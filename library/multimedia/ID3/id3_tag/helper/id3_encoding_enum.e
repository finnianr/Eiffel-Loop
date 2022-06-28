note
	description: "Encoding enumeration based on Underbit C representation"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-25 15:07:36 GMT (Saturday 25th June 2022)"
	revision: "4"

class
	ID3_ENCODING_ENUM

inherit
	EL_ENUMERATION [NATURAL_8]
		rename
			foreign_naming as kebab_case_upper
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

feature -- Codes

	ISO_8859_1: NATURAL_8

	UTF_16: NATURAL_8

	UTF_16_BE: NATURAL_8

	UTF_8: NATURAL_8

	Unknown: NATURAL_8

feature -- Status query

	is_utf_16 (code: NATURAL_8): BOOLEAN
		do
			Result := code = UTF_16 or else code = UTF_16_BE
		end

feature -- Conversion

	from_libid3 (libid3_code: INTEGER): NATURAL_8
		-- libid3 -> Underbit
		do
			Result := underbit_table [libid3_code]
		end

	to_libid3 (code: NATURAL_8): INTEGER
		-- Underbit -> libid3
		do
			Result := libid3_table [code]
		end

feature {NONE} -- Internal attributes

	libid3_table: EL_HASH_TABLE [INTEGER, NATURAL_8]

	underbit_table: HASH_TABLE [NATURAL_8, INTEGER]

feature {NONE} -- Implementation

	kebab_case_upper: EL_NAME_TRANSLATER
		do
			Result := kebab_case_translater ({EL_CASE}.Upper)
		end
end