note
	description: "Common Eiffel keywords and keyword lists"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-06 12:57:16 GMT (Sunday 6th October 2024)"
	revision: "12"

deferred class
	EL_EIFFEL_KEYWORDS

inherit
	EL_ANY_SHARED

	EL_MODULE_TUPLE

feature {NONE} -- Keywords

	Keyword: TUPLE [
		class_, deferred_, do_, else_, end_, expanded_, feature_, frozen_,
		if_, invariant_, indexing_, inherit_,
		note_, once_, undefine_, redefine_, rename_: ZSTRING]
		once
			create Result
			Tuple.fill (Result,
				"class, deferred, do, else, end, expanded, feature, frozen,%
				%if, invariant, indexing, inherit,%
				%note, once, undefine, redefine, rename"
			)
		ensure
			last_matches: Result.rename_.same_string_general ("rename")
		end

feature {NONE} -- Keyword lists

	Class_declaration_keywords: EL_ZSTRING_LIST
		once
			Result := << Keyword.expanded_, Keyword.frozen_, Keyword.deferred_, Keyword.class_ >>
		end

	Footer_start_keywords: EL_ZSTRING_LIST
		once
			Result := << Keyword.invariant_, Keyword.end_, Keyword.note_ >>
		end

	Indexing_keywords: EL_ZSTRING_LIST
		once
			Result := << Keyword.note_, Keyword.indexing_ >>
		end

	Routine_start_keywords: EL_ZSTRING_LIST
		once
			Result := << Keyword.do_, Keyword.once_ >>
		end

feature {NONE} -- Constants

	Assign_operator: ZSTRING
		once
			Result := ":="
		end

end