note
	description: "Pattern split string list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-16 17:02:50 GMT (Wednesday 16th November 2022)"
	revision: "11"

class
	EL_PATTERN_SPLIT_STRING_LIST

inherit
	EL_SOURCE_TEXT_PROCESSOR
		rename
			do_all as processor_do_all
		undefine
			is_equal, copy
		redefine
			make_with_delimiter, source_text
		end

	EL_TEXT_PATTERN_FACTORY
		undefine
			is_equal, copy
		end

	LINKED_LIST [ZSTRING]
		rename
			make as make_list
		end

	EL_ZSTRING_CONSTANTS

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
			make_with_delimiter (agent one_character_from (character_set))
		end

	make_with_delimiter (a_new_delimiting_pattern: FUNCTION [EL_TEXT_PATTERN])

		do
			make_list
			Precursor (a_new_delimiting_pattern)
		end

feature -- Element change

	extend_from_string (target: ZSTRING)
			--
		require
			target_not_void: target /= Void
		do
--			log.enter_with_args ("extend_from_string", <<target>>)
			set_source_text (target)
			processor_do_all (agent on_unmatched_text)
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

	set_from_string (target: ZSTRING)
			--
		do
			wipe_out
			extend_from_string (target)
		end

feature {NONE} -- Parsing actions

	on_unmatched_text (start_index, end_index: INTEGER)
			--
		do
--			log.enter_with_args ("on_unmatched_text", <<text>>)
			if end_index >= start_index then
				extend (source_substring (start_index, end_index, True))
			end
--			log.exit
		end

feature {NONE} -- Internal attributes

	source_text: ZSTRING
end