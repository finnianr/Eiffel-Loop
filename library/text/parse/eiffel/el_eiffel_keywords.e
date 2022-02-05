note
	description: "Common Eiffel keywords and keyword lists"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-05 9:59:49 GMT (Saturday 5th February 2022)"
	revision: "5"

deferred class
	EL_EIFFEL_KEYWORDS

inherit
	EL_ANY_SHARED

	EL_MODULE_TUPLE

feature {NONE} -- Keywords

	Keyword: TUPLE [
		class_, deferred_, do_, end_, expanded_, feature_, frozen_, invariant_, indexing_,
		inherit_, note_, once_, undefine_, redefine_, rename_: ZSTRING]
		once
			create Result
			Tuple.fill (Result,
				"class, deferred, do, end, expanded, feature, frozen, invariant, indexing,%
				%inherit, note, once, undefine, redefine, rename"
			)
		end

feature {NONE} -- Keyword lists

	Footer_start_keywords: EL_ZSTRING_LIST
		once
			Result := << Keyword.invariant_, Keyword.end_, Keyword.note_ >>
		end

	Indexing_keywords: EL_ZSTRING_LIST
		once
			Result := << Keyword.note_, Keyword.indexing_ >>
		end

	Class_declaration_keywords: EL_ZSTRING_LIST
		once
			Result := << Keyword.expanded_, Keyword.frozen_, Keyword.deferred_, Keyword.class_ >>
		end

	Routine_start_keywords: EL_ZSTRING_LIST
		once
			Result := << Keyword.do_, Keyword.once_ >>
		end

end