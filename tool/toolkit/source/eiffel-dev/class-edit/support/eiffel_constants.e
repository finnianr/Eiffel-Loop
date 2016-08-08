note
	description: "Summary description for {EIFFEL_CONSTANTS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-08-07 9:56:35 GMT (Sunday 7th August 2016)"
	revision: "2"

class
	EIFFEL_CONSTANTS

feature {NONE} -- Eiffel note constants


	Date_time_code: DATE_TIME_CODE_STRING
		once
			create Result.make (Date_time_format)
		end

	Date_time_format: STRING = "yyyy-[0]mm-[0]dd hh:[0]mi:[0]ss"

	Field: TUPLE [author, copyright, contact, license, date, revision: STRING]
		-- in the order in which they should appear
		do
			create Result
			Result := ["author", "copyright", "contact", "license", "date", "revision"]
		end

	Field_names: EL_STRING_8_LIST
			--
		once
			create Result.make_from_tuple (Field)
			Result.compare_objects
		end

feature {NONE} -- Keywords

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
