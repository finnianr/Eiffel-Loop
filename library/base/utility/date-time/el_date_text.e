note
	description: "Summary description for {EL_DATE_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-08-04 14:03:00 GMT (Friday 4th August 2017)"
	revision: "5"

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
			format_templates.search (format)
			if format_templates.found then
				template := format_templates.found_item
			else
				create template.make (format)
				format_templates [format] := template
			end
			across template.variables as variable loop
				text_functions.search (variable.item.to_string_8)
				if text_functions.found then
					template.set_variable (variable.item, text_functions.found_item (date))
				end
			end
			Result := template.substituted
		end

	from_iso8601_formatted (iso8601_string: STRING): DATE_TIME
		require
			correct_length: iso8601_string.count = Format_iso8601_count
			has_upper_T_delimiter: iso8601_string [9] = 'T'
			ends_with_upper_z: iso8601_string [Format_iso8601_count] = 'Z'
		local
			l_iso8601_string: STRING
		do
			create l_iso8601_string.make (Format_iso8601_count - 2)
			l_iso8601_string.append_substring (iso8601_string, 1, 8)
			l_iso8601_string.append_substring (iso8601_string, 10, Format_iso8601_count - 1)
			create Result.make_from_string (l_iso8601_string, Format_iso8601)
		ensure
			reversible: iso8601_formatted (Result) ~ iso8601_string
		end

	iso8601_formatted (time: DATE_TIME): STRING
		-- format as "yyyy[0]mm[0]Tdd[0]hh[0]mi[0]ssZ"
		do
			create Result.make (Format_iso8601_count)
			Result.append (time.formatted_out (Format_iso8601))
			Result.insert_character ('T', 9)
			Result.append_character ('Z')
		ensure
			-- Ignoring fine seconds
			reversible: from_iso8601_formatted (Result).relative_duration (time).seconds_count = 0
		end

	short_year (date: DATE): ZSTRING
		do
			Result := (date.year \\ 100).out
		end

	year (date: DATE): ZSTRING
		do
			Result := date.year.out
		end

feature -- Constant

	Format_iso8601_count: INTEGER = 16

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

	format_templates: HASH_TABLE [EL_SUBSTITUTION_TEMPLATE [ZSTRING], STRING]

	text_functions: like new_text_functions

feature {NONE} -- Constants

	Format_iso8601: STRING = "yyyy[0]mm[0]dd[0]hh[0]mi[0]ss"

end
