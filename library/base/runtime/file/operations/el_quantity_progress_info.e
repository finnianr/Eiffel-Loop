note
	description: "Summary description for {EL_FILE_PROGRESS_INFO}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-18 22:48:13 GMT (Friday 18th December 2015)"
	revision: "5"

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