note
	description: "Format routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-16 12:53:41 GMT (Wednesday 16th February 2022)"
	revision: "3"

class
	EL_FORMAT_ROUTINES

create
	make

feature {NONE} -- Initialization

	make
		do
			create format_table.make_equal (5, agent new_format)
		end

feature -- Access

	integer (n, width: INTEGER): STRING
		do
			Result := internal_integer (n, width, False)
		end

	integer_zero (n, width: INTEGER): STRING
		-- zero padded integer
		do
			Result := internal_integer (n, width, True)
		end

	percentage (proportion: DOUBLE): STRING
		do
			Result := percent ((proportion * 100).rounded)
		end

	percent (n: INTEGER): STRING
		do
			Result := internal_integer (n, 3, False) + Percent_string
		end

feature {NONE} -- Implementation

	internal_integer (n, width: INTEGER; zero_padded: BOOLEAN): STRING
		do
			Result := format_table.item ((width |<< 1) | zero_padded.to_integer).formatted (n)
		end

	new_format (key: INTEGER): FORMAT_INTEGER
		local
			width: INTEGER
		do
			width := key |>> 1
			create Result.make (width)
			if (key & Zero_padded_mask).to_boolean then
				Result.zero_fill
			end
		end

feature {NONE} -- Internal attributes

	format_table: EL_CACHE_TABLE [FORMAT_INTEGER, INTEGER]

feature {NONE} -- Constants

	Zero_padded_mask: INTEGER
		once
			Result := 1
		end

	Percent_string: STRING = "%%"

end