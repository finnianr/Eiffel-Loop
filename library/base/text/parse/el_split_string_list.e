note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-20 14:27:26 GMT (Sunday 20th December 2015)"
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

	EL_ZTEXT_PATTERN_FACTORY
		undefine
			is_equal, copy
		end

	LINKED_LIST [ZSTRING]
		rename
			make as make_list
		end

	EL_STRING_CONSTANTS
		undefine
			is_equal, copy
		end

create
	make, make_with_delimiter

feature {NONE} -- Initialization

	make (a_character_set: STRING_32)
			--
		require
			at_least_one_delimiter: a_character_set.count >= 1
		local
			character_set: ZSTRING
		do
			character_set := a_character_set
			make_with_delimiter (create {EL_MATCH_ANY_CHAR_IN_SET_TP}.make (character_set))
		end

	make_with_delimiter (a_pattern: EL_TEXT_PATTERN)

		do
			make_list
			Precursor (a_pattern)
			set_unmatched_action (agent on_unmatched_text)
		end

feature -- Element change

	set_from_string (target: ZSTRING)
			--
		do
			wipe_out
			extend_from_string (target)
		end

	extend_from_string (target: ZSTRING)
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
			delimiting_pattern.set_action (agent on_unmatched_text)
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
