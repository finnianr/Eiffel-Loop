note
	description: "Date text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-19 7:37:35 GMT (Wednesday 19th May 2021)"
	revision: "19"

deferred class
	EL_DATE_TEXT

inherit
	EL_DATE_TIME_TOOLS
		export
			{NONE} all
		end

feature {NONE} -- Initialization

	make
		do
			create template_table.make_equal (3, agent new_template)
			function_table := new_function_table
		end

feature -- Access

	formatted (date: DATE; format: STRING): ZSTRING
		require
			valid_format: is_valid_format (format)
		do
			Result := template (format).substituted (date)
		end

	from_ISO_8601_formatted (iso8601_string: STRING): EL_DATE_TIME
		do
			if iso8601_string.has ('-') then
				create Result.make_iso_8601_extended (iso8601_string)
			else
				create Result.make_iso_8601 (iso8601_string)
			end
		end

	iso_8601_formatted (dt: DATE_TIME; extended: BOOLEAN): STRING
		-- format as "yyyy[0]mm[0]Tdd[0]hh[0]mi[0]ssZ"
		do
			Once_date_time.make_from_other (dt)
			if extended then
				Result := Once_date_time.formatted_out (ISO_8601.format_extended)
			else
				Result := Once_date_time.formatted_out (ISO_8601.format)
			end
		end

	short_year (date: DATE): ZSTRING
		do
			Result := (date.year \\ 100).out
		end

	year (date: DATE): ZSTRING
		do
			Result := date.year.out
		end

feature -- Day of week

	long_day_name (date: DATE): ZSTRING
			-- long day of week name
		do
			Result := week_day_name (date.day_of_the_week, False)
		end

	long_week_day_names_list: EL_ZSTRING_LIST
		do
			Result := week_day_names_list (False)
		end

	short_day_name (date: DATE): ZSTRING
		do
			Result := week_day_name (date.day_of_the_week, True)
		end

	short_week_day_names_list: EL_ZSTRING_LIST
		do
			Result := week_day_names_list (True)
		end

feature -- Day of month

	canonical_numeric_day (date: DATE): ZSTRING
			-- day of month number with ordinal indicator
		do
			Result := numeric_day (date)
			inspect date.day
				when 1, 21, 31 then
					Result.append (ordinal_indicator (1))

				when 2, 22 then
					Result.append (ordinal_indicator (2))

				when 3, 23 then
					Result.append (ordinal_indicator (3))

			else
				Result.append (default_ordinal_indicator)

			end
		end

	numeric_day (date: DATE): ZSTRING
			-- numeric day of month
		do
			Result := date.day.out
		end

feature -- Month of year

	long_month_name (date: DATE): ZSTRING
		do
			Result := month_name (date.month, False)
		end

	long_month_names_list: EL_ZSTRING_LIST
		do
			Result := month_names_list (False)
		end

	numeric_month (date: DATE): ZSTRING
			-- month of year number
		do
			Result := date.month.out
		end

	short_month_name (date: DATE): ZSTRING
		do
			Result := month_name (date.month, True)
		end

	short_month_names_list: EL_ZSTRING_LIST
		do
			Result := month_names_list (True)
		end

feature {NONE} -- Implementation

	default_ordinal_indicator: ZSTRING
			--	
		deferred
		end

	month_name (month_of_year: INTEGER; short: BOOLEAN): ZSTRING
			--
		deferred
		end

	month_names_list (short: BOOLEAN): EL_ZSTRING_LIST
			--
		do
			create Result.make (12)
			across 1 |..| 12 as month_of_year loop
				Result.extend (month_name (month_of_year.item, short))
			end
		end

	new_function_table: EL_DATE_FUNCTION_TABLE
		do
			create Result.make (<<
				["long_day_name", 				agent long_day_name],
				["numeric_day",					agent numeric_day],
				["short_day_name", 				agent short_day_name],

				["long_month_name", 				agent long_month_name],
				["numeric_month",					agent numeric_month],
				["canonical_numeric_month", 	agent canonical_numeric_day],
				["short_month_name", 			agent short_month_name],

				["year", 							agent year],
				["short_year", 					agent short_year]
			>>)
		end

	new_template (format: STRING): EL_DATE_TEXT_TEMPLATE
		do
			create Result.make (format, function_table)
		end

	ordinal_indicator (i: INTEGER): ZSTRING
			--	
		require
			valid_number: i >= 0 and i <= 3
		deferred
		end

	template (format: STRING): EL_DATE_TEXT_TEMPLATE
		do
			Result := template_table.item (format)
		end

	week_day_name (day_of_week: INTEGER; short: BOOLEAN): ZSTRING
			--
		deferred
		end

	week_day_names_list (short: BOOLEAN): EL_ZSTRING_LIST
			-- Day of week names
		do
			create Result.make (7)
			across 1 |..| 7 as day loop
				Result.extend (week_day_name (day.item, short))
			end
		end

feature -- Contract Support

	is_valid_format (format: STRING): BOOLEAN
		do
			Result := template (format).valid_variables
		end

feature {NONE} -- Internal attributes

	function_table: like new_function_table

	template_table: EL_CACHE_TABLE [like template, STRING]

feature {NONE} -- Constants

	Once_date_time: EL_DATE_TIME
		once
			create Result.make_now
		end

end