note
	description: "Summary description for {EL_STRING_MATCHER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_TEXT_MATCHER

inherit
	EL_PARSER
		export
			{NONE} all
		redefine
			make
		end

	EL_TEXTUAL_PATTERN_FACTORY
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			Precursor
			create {EL_MATCH_BEGINNING_OF_LINE_TP} pattern
		end

feature -- Element change

	set_pattern (a_pattern: like pattern)
		do
			pattern := a_pattern
		end

feature -- Basic operations

	is_match (a_string: EL_ASTRING): BOOLEAN
			--
		do
			set_source_text (a_string)
			match_full
			Result := full_match_succeeded
		end

	contains_match (a_string: EL_ASTRING): BOOLEAN
			--
		do
			Result := occurrences (a_string) > 1
		end

	occurrences (a_string: EL_ASTRING): INTEGER
			--
		do
			set_source_text (a_string)
			find_all
			Result := count_match_successes
		end

	deleted (a_string: EL_ASTRING): EL_ASTRING
			-- a_string with all occurrences of pattern deleted
		do
			create Result.make (a_string.count)
			unmatched_text_action := agent (unmatched_text: EL_STRING_VIEW; a_result: EL_ASTRING)
				local
					s: EL_ASTRING
				do
					s := unmatched_text
					a_result.append_string (s)
				end (?, Result)

			set_source_text (a_string)
			find_all
			consume_events
			unmatched_text_action := Default_match_action
		end

feature {NONE} -- Implementation

	new_pattern: EL_TEXTUAL_PATTERN
			--
		do
			Result := pattern
		end

end
