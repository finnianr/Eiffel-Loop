note
	description: "Summary description for {EL_EIFFEL_KEYWORDS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-07-31 16:20:56 GMT (Monday 31st July 2017)"
	revision: "1"

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

	Keyword_note: ZSTRING
		once
			Result := "note"
		end

	Keyword_once: EL_ZSTRING
		once
			Result := "once"
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
			Result := << Keyword_frozen, Keyword_deferred, Keyword_class >>
		end

	Routine_start_keywords: EL_ZSTRING_LIST
		once
			Result := << Keyword_do, Keyword_once >>
		end

end
