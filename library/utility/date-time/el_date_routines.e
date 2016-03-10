note
	description: "Summary description for {EL_DATE_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-03-14 16:20:58 GMT (Thursday 14th March 2013)"
	revision: "2"

deferred class
	EL_DATE_ROUTINES

inherit
	EL_MODULE_STRING

	DATE_TIME_TOOLS

feature -- Conversion

	spell_day (date: DATE): EL_ASTRING
		do
			Result := day_full_text (date.day_of_the_week)
		end

	spelling_long (date: DATE; include_day: BOOLEAN): EL_ASTRING
			--
		do
			create Result.make_empty
			if include_day then
				Result.append (spell_day (date))
				Result.append_character (' ')
			end
			Result.append_integer (date.day)
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
			Result.append_character (' ')
			Result.append (month_full_text (date.month))
			Result.append_character (' ')
			Result.append_integer (date.year)
		end

	spelling_dd_mmm_yyyy (date: DATE): EL_ASTRING
			--
		do
			Result := String.joined_words (<< date.day.out, short_month (date.month), date.year.out >>)
		end

feature {NONE} -- Implementation

	Default_ordinal_indicator: EL_ASTRING
			--	
		deferred
		end

	ordinal_indicator (i: INTEGER): EL_ASTRING
			--	
		require
			valid_number: i >=0 and i <= 3
		deferred
		end

	short_month (month: INTEGER): EL_ASTRING
			--	
		deferred
		end

	day_full_text (day_of_week: INTEGER): EL_ASTRING
			--
		deferred
		end

	month_full_text (month: INTEGER): EL_ASTRING
			--
		deferred
		end

end
