note
	description: "Summary description for {EL_FILE_PROGRESS_INFO}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-10-25 8:07:42 GMT (Friday 25th October 2013)"
	revision: "3"

class
	EL_QUANTITY_PROGRESS_INFO

inherit
	EL_MODULE_STRING

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

	last_string: ASTRING

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
			percentage: INTEGER; template: ASTRING
		do
			sum := sum + v
			percentage := (sum * 100 / sum_total).rounded
			template := once "$S%% [$S of $S $S]"

			last_string := template #$ [percentage, formatter.formatted (sum), formatter.formatted (sum_total), units]
		end

feature {NONE} -- Implementation

	formatter: FORMAT_DOUBLE

end
