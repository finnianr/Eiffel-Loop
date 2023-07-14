note
	description: "Feature constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-07-14 17:34:38 GMT (Friday 14th July 2023)"
	revision: "9"

class
	FEATURE_CONSTANTS

feature {NONE} -- Constants

	Feature_expansion_table: EL_IMMUTABLE_STRING_8_TABLE
		once
			create Result.make ("[
				Access, ac,
				Access attributes, aa,
				Attributes, at,
				Basic operations, bo,
				Comparison, com,
				Constants, co,
				Contract Support, cs,
				Conversion, con,
				Cursor movement, cm,
				Deferred, de,
				Dimensions, di,
				Disposal, dis,
				Duplication, du,
				Element change, ec,
				Event handling, eh,
				Evolicity reflection, er,
				Factory, fa,
				Implementation, im,
				Inapplicable, ina,
				Initialization, in,
				Internal attributes, ia,
				Measurement, me,
				Miscellaneous, mi,
				Obsolete, ob,
				Removal, re,
				Status change, sc,
				Status query, sq,
				Tests, te,
				Transformation, tr,
				Type definitions, td,
				Unimplemented, un
			]")
		end

end