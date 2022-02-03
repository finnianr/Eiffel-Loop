note
	description: "Feature constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-03 12:29:11 GMT (Thursday 3rd February 2022)"
	revision: "6"

class
	FEATURE_CONSTANTS

feature {NONE} -- Constants

	Feature_catagories: EL_ZSTRING_HASH_TABLE [ZSTRING]
		once
			create Result.make_equal (20)

--			One word
			Result ["ac"] := "Access"
			Result ["at"] := "Attributes"
			Result ["co"] := "Constants"
			Result ["com"] := "Comparison"
			Result ["con"] := "Conversion"
			Result ["di"] := "Dimensions"
			Result ["dis"] := "Disposal"
			Result ["du"] := "Duplication"
			Result ["fa"] := "Factory"
			Result ["im"] := "Implementation"
			Result ["in"] := "Initialization"
			Result ["ina"] := "Inapplicable"
			Result ["me"] := "Measurement"
			Result ["mi"] := "Miscellaneous"
			Result ["ob"] := "Obsolete"
			Result ["re"] := "Removal"
			Result ["te"] := "Tests"
			Result ["tr"] := "Transformation"
			Result ["un"] := "Unimplemented"

--			Two words
			Result ["aa"] := "Access attributes"
			Result ["bo"] := "Basic operations"
			Result ["cs"] := "Contract Support"
			Result ["cm"] := "Cursor movement"
			Result ["ec"] := "Element change"
			Result ["eh"] := "Event handling"
			Result ["er"] := "Evolicity reflection"
			Result ["ia"] := "Internal attributes"
			Result ["sc"] := "Status change"
			Result ["sq"] := "Status query"
			Result ["td"] := "Type definitions"
		end

end