note
	description: "[
		Object that upgrades syntax of log filters 
		FROM

			Log_filter_old: ARRAY [TUPLE]
					--
				once
					Result := <<
						["CREATE_RSA_KEY_PAIR_APP", "*", "run"],
						["EL_RSA_KEY_PAIR", "*"]
					>>
				end
		TO
			Log_filter_new: ARRAY [like Type_logging_filter]
					--
				do
					Result := <<
						[{CREATE_RSA_KEY_PAIR_APP}, "*, run"],
						[{EL_RSA_KEY_PAIR}, "*"]

					>>
				end
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:38:40 GMT (Monday 21st November 2022)"
	revision: "8"

class
	LOG_FILTER_ARRAY_SOURCE_EDITOR

inherit
	EL_PATTERN_SEARCHING_EIFFEL_SOURCE_EDITOR
		rename
			class_name as class_name_pattern
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_default
			create class_name.make_empty
			create feature_names.make (10)
		end

feature {NONE} -- Pattern definitions

	search_patterns: ARRAYED_LIST [TP_PATTERN]
		do
			create Result.make_from_array (<<
				logging_filter_function,
				unmatched_identifier_plus_white_space -- skips to next identifier
			>>)
		end

	logging_filter_function: like all_of
			--
		do
			Result := all_of (<<
				all_of (<<
					string_literal ("Log_filter:"),
					white_space,
					string_literal ("ARRAY"),
					white_space,
					character_literal ('[')
				>>)	|to| agent on_unmatched_text,

				string_literal ("TUPLE") |to| agent on_tuple,
				all_of_separated_by (white_space, <<
					all_of (<<
						character_literal (']'),
						optional (all_of (<< white_space, string_literal ("--") >>))
					>>),
					string_literal ("once"),
					string_literal ("Result"),
					string_literal (":="),
					string_literal ("<<")
				>>) |to| agent on_once_result_equals_open_array,

				white_space |to| agent on_unmatched_text,

				filter_tuple (True),
				zero_or_more (all_of (<< character_literal (','), white_space, filter_tuple (False) >>)),

				filter_end
			>>)
		end

	filter_tuple (is_first: BOOLEAN): like all_of
			--
		do
			Result := all_of ( <<
				character_literal ('['),
				quoted_string (Void) |to| agent on_class_name,
				one_or_more (feature_specifiers),
				optional_white_space,
				character_literal (']')
			>> )
			Result.set_action_last (agent on_filter_end (?, ?, is_first))
		end

	feature_specifiers: like all_of
			--
		do
			Result := all_of ( <<
				character_literal (','),
				optional_white_space,
				quoted_string (Void) |to| agent on_feature_specifier
			>> )
		end

	filter_end: like all_of
			--
		do
			Result := all_of (<<
				white_space,
				string_literal (">>"),
				white_space,
				string_literal ("end")
			>>) |to| agent on_unmatched_text
		end

feature {NONE} -- Parsing actions

	on_once_result_equals_open_array (start_index, end_index: INTEGER)
			--
		local
			out_text: STRING
		do
			out_text := source_substring (start_index, end_index, False)
			out_text.replace_substring_all ("once", "do")
			put_string (out_text)
		end

	on_tuple (start_index, end_index: INTEGER)
			--
		do
--			log.enter_with_args ("on_tuple", << text >>)
			put_string ("like Type_logging_filter")
--			log.exit
		end

	on_class_name (start_index, end_index: INTEGER)
			--
		do
			class_name := source_substring (start_index, end_index, False)
		end

	on_feature_specifier (start_index, end_index: INTEGER)
			--
		do
			feature_names.extend (source_substring (start_index, end_index, False))
		end

	on_filter_end (start_index, end_index: INTEGER; is_first: BOOLEAN)
			--
		do
			if not is_first then
				put_string (",%N%T%T%T%T")
			end
			put_string ("[{")
			put_string (class_name + "}")
			across feature_names as name loop
				if name.cursor_index = 1 then
					put_string (", %"" + name.item)
				else
					put_string (", " + name.item)
				end
			end
			put_string ("%"]")
			feature_names.wipe_out
		end

feature {NONE} -- Implementation

	class_name: STRING

	feature_names: ARRAYED_LIST [STRING]

end