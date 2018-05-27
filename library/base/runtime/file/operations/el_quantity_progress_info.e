note
	description: "Quantity progress info"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:47 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_QUANTITY_PROGRESS_INFO

create
	make

feature {NONE} -- Initialization

	make (a_total: DOUBLE; decimals: INTEGER; a_units: STRING)
		do
			sum_total := a_total
			units := a_units
			create formatter.make (10, decimals)
			create last_string.make_empty
			formatter.no_justify
		end

feature -- Access

	sum_total: DOUBLE

	sum: DOUBLE

	units: STRING

	last_string: ZSTRING

feature -- Status query

	line_advance_enabled: BOOLEAN

feature -- Status setting

	enable_line_advance
		do
			line_advance_enabled := True
		end

	disable_line_advance
		do
			line_advance_enabled := False
		end

feature -- Element change

	increment (v: DOUBLE)
		local
			percentage: INTEGER; template: ZSTRING
		do
			sum := sum + v
			percentage := (sum * 100 / sum_total).rounded
			template := once "%S%% [%S of %S %S]"

			last_string := template #$ [percentage, formatter.formatted (sum), formatter.formatted (sum_total), units]
		end

feature {NONE} -- Implementation

	formatter: FORMAT_DOUBLE

end