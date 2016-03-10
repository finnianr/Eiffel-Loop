note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_SPLIT_STRING_LIST

inherit
	EL_SOURCE_TEXT_PROCESSOR
		rename
			do_all as processor_do_all
		undefine
			is_equal, copy
		redefine
			make_with_delimiter
		end

	EL_TEXTUAL_PATTERN_FACTORY
		undefine
			is_equal, copy
		end

	LINKED_LIST [STRING]
		rename
			make as make_list
		end

create
	make, make_with_delimiter

feature {NONE} -- Implementation

	Empty_string: STRING = ""

feature {NONE} -- Initialization

	make (some_delimiters: ARRAY [CHARACTER])
			--
		require
			at_least_one_delimiter: some_delimiters.count >= 1
		local
			character_set: STRING
		do
			create character_set.make_empty
			some_delimiters.do_all (agent character_set.append_character)
			make_with_delimiter (create {EL_MATCH_ANY_CHAR_IN_SET_TP}.make (character_set))
		end

	make_with_delimiter (a_pattern: EL_TEXTUAL_PATTERN)

		do
			make_list
			Precursor (a_pattern)
			set_unmatched_text_action (agent on_unmatched_text)
		end

feature -- Element change

	set_from_string (target: STRING)
			--
		do
			wipe_out
			extend_from_string (target)
		end

	extend_from_string (target: STRING)
			--
		require
			target_not_void: target /= Void
		do
--			log.enter_with_args ("extend_from_string", <<target>>)
			set_source_text (target)
			processor_do_all
			set_source_text (Empty_string)
--			log.exit
		end

	keep_delimiters
			--
		require
			valid_delimiting_pattern: delimiting_pattern /= Void
		do
			delimiting_pattern.set_action_on_match (agent on_unmatched_text)
		end

feature {NONE} -- Parsing actions

	on_unmatched_text (text: EL_STRING_VIEW)
			--
		do
--			log.enter_with_args ("on_unmatched_text", <<text>>)
			if text.count > 0 then
				extend (text)
			end
--			log.exit
		end

end -- class EL_SPLIT_STRING_LIST

