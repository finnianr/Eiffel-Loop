note
	description: "Common Eiffel keywords and keyword lists"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-11 14:39:53 GMT (Wednesday 11th April 2018)"
	revision: "3"

class
	EL_EIFFEL_KEYWORDS

feature {NONE} -- Keywords

	Keyword_class: EL_ZSTRING
		once
			Result := "class"
		end

	Keyword_deferred: EL_ZSTRING
		once
			Result := "deferred"
		end

	Keyword_do: EL_ZSTRING
		once
			Result := "do"
		end

	Keyword_end: ZSTRING
		once
			Result := "end"
		end

	Keyword_expanded: ZSTRING
		once
			Result := "expanded"
		end

	Keyword_feature: ZSTRING
		once
			Result := "feature"
		end

	Keyword_frozen: EL_ZSTRING
		once
			Result := "frozen"
		end

	Keyword_invariant: ZSTRING
		once
			Result := "invariant"
		end

	Keyword_indexing: ZSTRING
		once
			Result := "indexing"
		end

	Keyword_inherit: ZSTRING
		once
			Result := "inherit"
		end

	Keyword_note: ZSTRING
		once
			Result := "note"
		end

	Keyword_once: EL_ZSTRING
		once
			Result := "once"
		end

	Keyword_undefine: EL_ZSTRING
		once
			Result := "undefine"
		end

	Keyword_redefine: EL_ZSTRING
		once
			Result := "redefine"
		end

	Keyword_rename: EL_ZSTRING
		once
			Result := "rename"
		end

feature {NONE} -- Keyword lists

	Footer_start_keywords: EL_ZSTRING_LIST
		once
			Result := << Keyword_invariant, Keyword_end, Keyword_note >>
		end

	Indexing_keywords: EL_ZSTRING_LIST
		once
			Result := << Keyword_note, Keyword_indexing >>
		end

	Class_declaration_keywords: EL_ZSTRING_LIST
		once
			Result := << Keyword_expanded, Keyword_frozen, Keyword_deferred, Keyword_class >>
		end

	Routine_start_keywords: EL_ZSTRING_LIST
		once
			Result := << Keyword_do, Keyword_once >>
		end

end
