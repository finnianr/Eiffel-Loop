note
	description: "Summary description for {EIFFEL_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-21 11:15:30 GMT (Thursday 21st July 2016)"
	revision: "1"

class
	EIFFEL_CONSTANTS

feature {NONE} -- Constants

	Class_declaration_keywords: EL_ZSTRING_LIST
		once
			create Result.make_from_array (<< Keyword_frozen, Keyword_deferred, Keyword_class >>)
		end

	Keyword_class: EL_ZSTRING
		once
			Result := "class"
		end

	Keyword_deferred: EL_ZSTRING
		once
			Result := "deferred"
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

	Indexing_keywords: EL_ZSTRING_LIST
		once
			create Result.make_from_array (<< Keyword_note, Keyword_indexing >>)
		end

end
