note
	description: "Date and word search term parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 17:47:23 GMT (Tuesday 15th November 2022)"
	revision: "8"

class
	EL_DATE_AND_WORD_SEARCH_TERM_PARSER  [G -> {EL_DATEABLE, EL_WORD_SEARCHABLE}]

inherit
	EL_SEARCH_TERM_PARSER [G]
		redefine
			custom_patterns, make
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			create last_date.make_now
			create date_from.make_now
			Precursor
		end

feature {NONE} -- Text patterns

	custom_patterns: ARRAY [EL_TEXT_PATTERN]
		do
			Result := << month_interval, day_interval, date, month >>
		end

	date: like date_dd_mm_yyyy
			--
		do
			Result := date_dd_mm_yyyy
			Result.set_action_last (agent on_date)
		end

	month: like date_mm_yyyy
			--
		do
			Result := date_mm_yyyy
			Result.set_action_last (agent on_start_to_end_month)
		end

	month_interval: like all_of
			--
		do
			Result := all_of (<<
				date_mm_yyyy,
				character_literal ('-') |to| agent on_interval,
				date_mm_yyyy
			>>)
			Result.set_action_last (agent on_month_interval)
		end

	day_interval: like all_of
			--
		do
			Result := all_of (<<
				date_dd_mm_yyyy,
				character_literal ('-') |to| agent on_interval,
				date_dd_mm_yyyy
			>>)
			Result.set_action_last (agent on_day_interval)
		end

	date_mm_yyyy: like all_of
			--
		do
			Result := all_of (<<
				digit #occurs (1 |..| 2) |to| agent on_month,
				character_literal ('/'),
				digit #occurs (1 |..| 4) |to| agent on_year
			>>)
		end

	date_dd_mm_yyyy: like all_of
			--
		do
			Result := all_of (<<
				digit #occurs (1 |..| 2) |to| agent on_day,
				character_literal ('/'),
				date_mm_yyyy
			>>)
		end

feature {NONE} -- Match actions

	on_day (start_index, end_index: INTEGER)
		do
			last_date.set_day (source_substring (start_index, end_index, False).to_integer)
		end

	on_month (start_index, end_index: INTEGER)
		do
			last_date.set_month (source_substring (start_index, end_index, False).to_integer)
		end

	on_year (start_index, end_index: INTEGER)
		local
			number: INTEGER
		do
			number := source_substring (start_index, end_index, False).to_integer
			if number < 100 then
				number := number + (last_date.year // 100) * 100
			end
			last_date.set_year (number)
		end

	on_interval (start_index, end_index: INTEGER)
		do
			date_from := last_date.twin
		end

	on_date (start_index, end_index: INTEGER)
		do
			date_from := last_date.twin
			extend_critera
		end

	on_start_to_end_month (start_index, end_index: INTEGER)
		do
			date_from := last_date.twin
			on_month_interval (start_index, end_index)
		end

	on_month_interval (start_index, end_index: INTEGER)
			--
		do
			date_from.set_day (1)
			last_date.set_day (last_date.days_in_month)
			extend_critera
		end

	on_day_interval (start_index, end_index: INTEGER)
			--
		do
			extend_critera
		end

feature {NONE} -- Implementation

	extend_critera
			--
		do
			if last_date.ordered_compact_date_valid (last_date.ordered_compact_date)
				and then date_from.ordered_compact_date_valid (date_from.ordered_compact_date)
			then
				condition_list.extend (create {EL_DATE_INTERVAL_CONDITION [G]}.make (date_from.twin, last_date.twin))
			end
		end

	date_from: DATE

	last_date: DATE

end