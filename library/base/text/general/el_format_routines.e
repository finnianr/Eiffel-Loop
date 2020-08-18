note
	description: "Format routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-08-16 12:27:59 GMT (Sunday 16th August 2020)"
	revision: "2"

class
	EL_FORMAT_ROUTINES

create
	make

feature {NONE} -- Initialization

	make
		do
			create integer_formats.make (3)
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
		local
			f: FORMAT_INTEGER; key: NATURAL
		do
			key := width.to_natural_32
			if zero_padded then
				key := Zero_padded_bit | key
			end
			if integer_formats.has_key (key) then
				f := integer_formats.found_item
			else
				create f.make (width)
				if zero_padded then
					f.zero_fill
				end
				integer_formats.extend (f, key)
			end
			Result := f.formatted (n)
		end

feature {NONE} -- Internal attributes

	integer_formats: HASH_TABLE [FORMAT_INTEGER, NATURAL]

feature {NONE} -- Constants

	Zero_padded_bit: NATURAL
		once
			Result := Result.one |<< 32
		end

	Percent_string: STRING = "%%"

end
