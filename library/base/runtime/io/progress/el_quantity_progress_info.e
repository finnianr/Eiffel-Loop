note
	description: "Quantity progress info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-11 17:15:17 GMT (Monday 11th December 2023)"
	revision: "9"

class
	EL_QUANTITY_PROGRESS_INFO

inherit
	ANY; EL_SHARED_FORMAT_FACTORY

create
	make

feature {NONE} -- Initialization

	make (a_total: DOUBLE; decimals: INTEGER; a_units: STRING)
		do
			sum_total := a_total
			units := a_units
			create double.make (10, decimals)
			double.no_justify

			create last_string.make_empty
		end

feature -- Access

	last_string: ZSTRING

	sum: DOUBLE

	sum_total: DOUBLE

	units: STRING

feature -- Status query

	line_advance_enabled: BOOLEAN

feature -- Status setting

	disable_line_advance
		do
			line_advance_enabled := False
		end

	enable_line_advance
		do
			line_advance_enabled := True
		end

feature -- Element change

	increment (v: DOUBLE)
		local
			percentage: STRING
		do
			sum := sum + v
			percentage := Format.double_as_string (sum * 100 / sum_total, once "999.9%%|")
			last_string := Template #$ [percentage, double.formatted (sum), double.formatted (sum_total), units]
		end

feature {NONE} -- Internal attributes

	double: FORMAT_DOUBLE

feature {NONE} -- Constants

	Template: ZSTRING
		once
			Result := "%S [%S of %S %S]"
		end

end