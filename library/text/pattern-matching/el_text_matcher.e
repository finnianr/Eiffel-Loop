note
	description: "Summary description for {EL_STRING_MATCHER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "3"

class
	EL_TEXT_MATCHER

inherit
	EL_PARSER
		export
			{NONE} all
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
			make_default
			create {EL_MATCH_BEGINNING_OF_LINE_TP} pattern
		end

feature -- Element change

	set_pattern (a_pattern: like pattern)
		do
			pattern := a_pattern
		end

feature -- Basic operations

	is_match (a_string: ASTRING): BOOLEAN
			--
		do
			set_source_text (a_string)
			match_full
			Result := full_match_succeeded
		end

	contains_match (a_string: ASTRING): BOOLEAN
			--
		do
			Result := occurrences (a_string) > 1
		end

	occurrences (a_string: ASTRING): INTEGER
			--
		do
			set_source_text (a_string)
			find_all
			Result := count_match_successes
		end

	deleted (a_string: ASTRING): ASTRING
			-- a_string with all occurrences of pattern deleted
		do
			create Result.make (a_string.count)
			unmatched_text_action := agent (unmatched_text: EL_STRING_VIEW; a_result: ASTRING)
				do
					a_result.append (unmatched_text)
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
