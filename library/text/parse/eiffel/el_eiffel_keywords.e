note
	description: "Common Eiffel keywords and keyword lists"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-09-14 11:53:43 GMT (Thursday 14th September 2023)"
	revision: "8"

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
		ensure
			end_ok: Result.end_.same_string_general ("end")
		end

	Keyword_type_table: EL_IMMUTABLE_STRING_8_TABLE
		-- lookup
		once
			create Result.make_by_assignment ("[
				across := kw
				agent := kw
				alias := kw
				all := kw
				and := operator
				as := kw
				assign := kw
				attached := kw
				attribute := kw
				check := kw
				class := kw
				convert := kw
				create := kw
				current := reference
				debug := kw
				deferred := kw
				detachable := kw
				do := kw
				else := kw
				elseif := kw
				end := kw
				ensure := kw
				expanded := kw
				export := kw
				external := kw
				false := constant
				feature := kw
				from := kw
				frozen := kw
				if := kw
				implies := kw
				inherit := kw
				inspect := kw
				invariant := kw
				like := kw
				local := kw
				loop := kw
				not := operator
				note := kw
				obsolete := kw
				old := operator
				once := kw
				only := kw
				or := operator
				precursor := kw
				redefine := kw
				rename := kw
				require := kw
				rescue := kw
				result := reference
				retry := kw
				select := kw
				separate := kw
				then := kw
				true := constant
				undefine := kw
				until := kw
				variant := kw
				void := constant
				when := kw
				xor := operator
			]")
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