note
	description: "Summary description for {JOB_DURATION_PARSER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:02 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	JOB_DURATION_PARSER

inherit
	EL_FILE_PARSER

	EL_ZTEXT_PATTERN_FACTORY
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_default
			create duration_interval.make (0, 0)
		end

feature -- Access

	duration_interval: INTEGER_INTERVAL
		-- Duration range in days

feature -- Element change

	set_duration_interval (duration_text: STRING)
			--
		do
			set_source_text (duration_text)
			days_per_unit := Default_days_per_unit
			integer_from := 0
			integer_to := 0
			create duration_interval.make (999999, 999999)
			is_extendable_contract := duration_text.has_substring ("exten")

			parse
		end

feature {NONE} -- Patterns

	new_pattern: like all_of
			--
		do
			Result := all_of (<<
				integer |to| agent on_integer_from,
				optional (plus_extension_pattern),
				optional (to_integer_pattern),
				duration_unit,
				optional (plus_extension_pattern),
				remainder_of_line
			>>)
			Result.set_action_last (agent on_duration)
		end

	plus_extension_pattern: like all_of
			--
		do
			Result := all_of (<<
				maybe_non_breaking_white_space,
				one_of (<<
					character_literal ('+') #occurs (1 |..| 3),
					string_literal ("contract +"),
					string_literal ("plus"),
					string_literal ("rolling")
				>>)
			>>)
			Result.set_action_first (agent on_plus_extension)
		end

	to_integer_pattern: like all_of
			--
		do
			Result := all_of (<<
				maybe_non_breaking_white_space,
				one_of (<<
					character_literal ('-'),
					character_literal ('/'),
					string_literal ("to")
				>>),
				maybe_non_breaking_white_space,
				integer								|to| agent on_integer_to
			>>)
		end

	duration_unit: like all_of
			--
		do
			Result := all_of (<<
				maybe_non_breaking_white_space,
				one_of (<<
					year_word						|to| agent on_year_unit,
					month_word						|to| agent on_month_unit,
					week_word						|to| agent on_week_unit,
					day_word							|to| agent on_day_unit
				>>),
				optional (character_literal ('s'))
			>>)
		end

	day_word: like one_of
			--
		do
			Result := one_of (<<
				string_literal ("day"),
				string_literal ("tage"),
				string_literal ("dagen"),
				string_literal ("dag")
			>>)
		end

	week_word: like one_of
			--
		do
			Result := one_of (<<
				string_literal ("week"),
				string_literal ("woche"),
				string_literal ("semaine")
			>>)
		end

	month_word: like one_of
			--
		do
			Result := one_of (<<
				string_literal ("month"),
				string_literal ("monate"),
				string_literal ("maanden"),
				string_literal ("monat"),
				string_literal ("mois"),
				string_literal ("mese"),
				string_literal ("mnth"),
				string_literal ("mth"),
				string_literal ("mt"),
				string_literal ("m")
			>>)
		end

	year_word: like one_of
			--
		do
			Result := one_of (<<
				string_literal ("year"),
				string_literal ("jahr"),
				string_literal ("año"),
				string_literal ("a")
			>>)
		end

feature {NONE} -- Match handlers

	on_year_unit (text: EL_STRING_VIEW)
			--
		do
			days_per_unit := 365
		end

	on_month_unit (text: EL_STRING_VIEW)
			--
		do
			days_per_unit := 30
		end

	on_week_unit (text: EL_STRING_VIEW)
			--
		do
			days_per_unit := 7
		end

	on_day_unit (text: EL_STRING_VIEW)
			--
		do
			days_per_unit := 1
		end

	on_duration (text: EL_STRING_VIEW)
			--
		do
			if integer_to = 0 then
				integer_to := integer_from
			end
			if is_extendable_contract then
				create duration_interval.make (
					integer_from * days_per_unit,
					(integer_to * days_per_unit * Default_extension_multiplier).rounded
				)
			else
				create duration_interval.make (integer_from * days_per_unit, integer_to * days_per_unit)
			end
		end

	on_integer_from (text: EL_STRING_VIEW)
			--
		do
			integer_from := text.to_string_8.to_integer
			integer_to := integer_from
		end

	on_integer_to (text: EL_STRING_VIEW)
			--
		do
			integer_to := text.to_string_8.to_integer
		end

	on_plus_extension (text: EL_STRING_VIEW)
			--
		do
			is_extendable_contract := True
		end

feature {NONE} -- Implementation

	is_extendable_contract: BOOLEAN

	days_per_unit: INTEGER

	integer_from: INTEGER

	integer_to: INTEGER

feature {NONE} -- Constants

	Default_extension_multiplier: REAL = 1.5

	Default_days_per_unit: INTEGER = 30

end