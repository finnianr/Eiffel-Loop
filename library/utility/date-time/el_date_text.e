note
	description: "Summary description for {EL_DATE_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-01-05 12:51:17 GMT (Sunday 5th January 2014)"
	revision: "3"

deferred class
	EL_DATE_TEXT

inherit
	EL_MODULE_STRING

	DATE_TIME_TOOLS
		export
			{NONE} all
		end

feature -- Access

	formatted (date: DATE; format: STRING): ASTRING
		require
			valid_format: is_valid_format (format)
		local
			template: like Format_templates.item
		do
			Format_templates.search (format)
			if Format_templates.found then
				template := Format_templates.found_item
			else
				create template.make (format)
				Format_templates [format] := template
			end
			across template.variables as variable loop
				Text_functions.search (variable.item.to_string_8)
				if Text_functions.found then
					template.set_variable (variable.item, Text_functions.found_item.item ([date]))
				end
			end
			Result := template.substituted
		end

	short_year (date: DATE): ASTRING
		do
			Result := (date.year \\ 100).out
		end

	year (date: DATE): ASTRING
		do
			Result := date.year.out
		end

feature -- Day of week

	long_week_day_names_list: EL_ASTRING_LIST
		do
			Result := week_day_names_list (False)
		end

	long_day_name (date: DATE): ASTRING
			-- long day of week name
		do
			Result := week_day_name (date.day_of_the_week, False)
		end

	short_day_name (date: DATE): ASTRING
		do
			Result := week_day_name (date.day_of_the_week, True)
		end

	short_week_day_names_list: EL_ASTRING_LIST
		do
			Result := week_day_names_list (True)
		end

feature -- Day of month

	canonical_numeric_day (date: DATE): ASTRING
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
				Result.append (Default_ordinal_indicator)

			end
		end

	numeric_day (date: DATE): ASTRING
			-- numeric day of month
		do
			Result := date.day.out
		end

feature -- Month of year

	long_month_name (date: DATE): ASTRING
		do
			Result := month_name (date.month, False)
		end

	long_month_names_list: EL_ASTRING_LIST
		do
			Result := month_names_list (False)
		end

	numeric_month (date: DATE): ASTRING
			-- month of year number
		do
			Result := date.month.out
		end

	short_month_name (date: DATE): ASTRING
		do
			Result := month_name (date.month, True)
		end

	short_month_names_list: EL_ASTRING_LIST
		do
			Result := month_names_list (True)
		end

feature {NONE} -- Implementation

	week_day_names_list (short: BOOLEAN): EL_ASTRING_LIST
			-- Day of week names
		do
			create Result.make (7)
			across 1 |..| 7 as day loop
				Result.extend (week_day_name (day.item, short))
			end
		end

	week_day_name (day_of_week: INTEGER; short: BOOLEAN): ASTRING
			--
		deferred
		end

	month_names_list (short: BOOLEAN): EL_ASTRING_LIST
			--
		do
			create Result.make (12)
			across 1 |..| 12 as month_of_year loop
				Result.extend (month_name (month_of_year.item, short))
			end
		end

	month_name (month_of_year: INTEGER; short: BOOLEAN): ASTRING
			--
		deferred
		end

	Default_ordinal_indicator: ASTRING
			--	
		deferred
		end

	ordinal_indicator (i: INTEGER): ASTRING
			--	
		require
			valid_number: i >=0 and i <= 3
		deferred
		end

feature -- Contract Support

	is_valid_format (format: STRING): BOOLEAN
		local
			template: like Format_templates.item
		do
			create template.make (format)
			Result := across template.variables as variable all Text_functions.has (variable.item.to_string_8) end
		end

feature {NONE} -- Constants

	Format_templates: HASH_TABLE [EL_SUBSTITUTION_TEMPLATE [ASTRING], STRING]
		once
			create Result.make (3)
		end

	Text_functions: EL_HASH_TABLE [FUNCTION [EL_DATE_TEXT, TUPLE [DATE], ASTRING], STRING]
		once
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

end
