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
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:33 GMT (Tuesday 2nd September 2014)"
	revision: "3"

class
	EIFFEL_LOG_FILTER_ARRAY_SOURCE_EDITOR

inherit
	EIFFEL_SOURCE_EDITING_PROCESSOR

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

	search_patterns: ARRAYED_LIST [EL_TEXTUAL_PATTERN]
		do
			create Result.make_from_array (<<
				logging_filter_function,
				unmatched_identifier_plus_white_space -- skips to next identifier
			>>)
		end

	logging_filter_function: EL_MATCH_ALL_IN_LIST_TP
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
						optional (
							all_of (<<
								white_space,
								string_literal ("--")
							>>)
						)
					>>),
					string_literal ("once"),
					string_literal ("Result"),
					string_literal (":="),
					string_literal ("<<")
				>>) |to| agent on_once_result_equals_open_array,

				white_space |to| agent on_unmatched_text,

				filter_tuple (True),
				zero_or_more (
					all_of (<<
						character_literal (','),
						white_space,
						filter_tuple (False)
					>>)
				),

				filter_end
			>>)
		end

	filter_tuple (is_first: BOOLEAN): EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of ( <<
				character_literal ('['),
				quoted_eiffel_string (agent on_class_name),
				one_or_more (feature_specifiers),
				maybe_white_space,
				character_literal (']')
			>> )
			Result.set_action_on_match_end (agent on_filter_end (?, is_first))
		end

	feature_specifiers: EL_MATCH_ALL_IN_LIST_TP
			--
		do
			Result := all_of ( <<
				character_literal (','),
				maybe_white_space,
				quoted_eiffel_string (agent on_feature_specifier)
			>> )
		end

	filter_end: EL_MATCH_ALL_IN_LIST_TP
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

	on_once_result_equals_open_array (text: EL_STRING_VIEW)
			--
		local
			out_text: STRING
		do
			out_text := text
			out_text.replace_substring_all ("once", "do")
			put_string (out_text)
		end

	on_tuple (text: EL_STRING_VIEW)
			--
		do
--			log.enter_with_args ("on_tuple", << text >>)
			put_string ("like Type_logging_filter")
--			log.exit
		end

	on_class_name (text: EL_STRING_VIEW)
			--
		do
			class_name := text
		end

	on_feature_specifier (text: EL_STRING_VIEW)
			--
		do
			feature_names.extend (text)
		end

	on_filter_end (text: EL_STRING_VIEW; is_first: BOOLEAN)
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
