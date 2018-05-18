note
	description: "Summary description for {EL_DATE_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-10 18:59:38 GMT (Thursday 10th May 2018)"
	revision: "10"

deferred class
	EL_DATE_TEXT

inherit
	DATE_TIME_TOOLS
		export
			{NONE} all
		end

feature {NONE} -- Initialization

	make
		do
			create format_templates.make (3)
			text_functions := new_text_functions
		end

feature -- Access

	formatted (date: DATE; format: STRING): ZSTRING
		require
			valid_format: is_valid_format (format)
		local
			template: like format_templates.item
		do
			if format_templates.has_key (format) then
				template := format_templates.found_item
			else
				create template.make (format)
				format_templates [format] := template
			end
			across template.variables as variable loop
				if text_functions.has_key (variable.item.to_string_8) then
					template.set_variable (variable.item, text_functions.found_item (date))
				end
			end
			Result := template.substituted
		end

	from_ISO_8601_formatted (iso8601_string: STRING): DATE_TIME
		local
			iso_date: like iso_date_time
		do
			iso_date := iso_date_time (iso8601_string.has ('-'))
			iso_date.make (iso8601_string)
			Result := iso_date.to_date_time
		end

	iso_8601_formatted (time: DATE_TIME; canonical: BOOLEAN): STRING
		-- format as "yyyy[0]mm[0]Tdd[0]hh[0]mi[0]ssZ"
		local
			iso_date: like iso_date_time
		do
			iso_date := iso_date_time (canonical)
			iso_date.set_from_other (time)
			Result := iso_date.to_string
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

	iso_date_time (canonical: BOOLEAN): EL_ISO_8601_DATE_TIME
		do
			if canonical then
				Result := Canonical_iso_8601_date_time
			else
				Result := Short_iso_8601_date_time
			end
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

	new_text_functions: EL_HASH_TABLE [FUNCTION [DATE, ZSTRING], STRING]
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

	ordinal_indicator (i: INTEGER): ZSTRING
			--	
		require
			valid_number: i >=0 and i <= 3
		deferred
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
		local
			template: like format_templates.item
		do
			create template.make (format)
			Result := across template.variables as variable all text_functions.has (variable.item.to_string_8) end
		end

feature {NONE} -- Internal attributes

	format_templates: HASH_TABLE [EL_ZSTRING_TEMPLATE, STRING]

	text_functions: like new_text_functions

feature {NONE} -- Constants

	Canonical_iso_8601_date_time: EL_ISO_8601_DATE_TIME
		once
			create Result.make_now
		end

	Short_iso_8601_date_time: EL_SHORT_ISO_8601_DATE_TIME
		once
			create Result.make_now
		end

end
