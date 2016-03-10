note
	description: "Summary description for {EL_FILE_PROGRESS_INFO}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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

	last_string: EL_ASTRING

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
			percentage: INTEGER
		do
			sum := sum + v
			percentage := (sum * 100 / sum_total).rounded

			last_string := String.template ("$S%% [$S of $S $S]").substituted (<<
				percentage, formatter.formatted (sum), formatter.formatted (sum_total), units
			>>)
		end

feature {NONE} -- Implementation

	formatter: FORMAT_DOUBLE

end
