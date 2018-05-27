note
	description: "Html constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:47 GMT (Saturday 19th May 2018)"
	revision: "4"

class
	EL_HTML_CONSTANTS

feature -- Constants

	Entity_numbers: EL_ZSTRING_HASH_TABLE [NATURAL]
		local
			l_entities: like Entities
			i: INTEGER
		once
			l_entities := Entities
			create Result.make_equal (l_entities.count)
			from i := l_entities.lower until i > l_entities.upper loop
				if l_entities [i] /= Default_entity then
					Result.extend (i.to_natural_32, l_entities [i])
				end
				i := i + 1
			end
			Result.extend (8364, "euro")		-- euro
		end

feature {NONE} -- Constants

	Entities: ARRAY [STRING]
		once
			create Result.make_filled (Default_entity, 34, 376)
			Result [34] := "quot"		-- quotation mark
			Result [39] := "apos"		-- apostrophe
			Result [38] := "amp"			-- ampersand

			Result [60] := "lt"			-- less-than
			Result [62] := "gt"			-- greater-than

			Result [160] := "nbsp"		-- non-breaking space
			Result [161] := "iexcl"		-- inverted exclamation mark
			Result [162] := "cent"		-- cent
			Result [163] := "pound"		-- pound
			Result [164] := "curren"	-- currency
			Result [165] := "yen"		-- yen
			Result [166] := "brvbar"	-- broken vertical bar
			Result [167] := "sect"		-- section
			Result [168] := "uml"		-- spacing diaeresis
			Result [169] := "copy"		-- copyright
			Result [170] := "ordf"		-- feminine ordinal indicator
			Result [171] := "laquo"		-- angle quotation mark (left)
			Result [172] := "not"		-- negation
			Result [173] := "shy"		-- soft hyphen
			Result [174] := "reg"		-- registered trademark
			Result [175] := "macr"		-- spacing macron
			Result [176] := "deg"		-- degree
			Result [177] := "plusmn"	-- plus-or-minus
			Result [178] := "sup2"		-- superscript 2
			Result [179] := "sup3"		-- superscript 3
			Result [180] := "acute"		-- spacing acute
			Result [181] := "micro"		-- micro
			Result [182] := "para"		-- paragraph
			Result [183] := "middot"	-- middle dot
			Result [184] := "cedil"		-- spacing cedilla
			Result [185] := "sup1"		-- superscript 1
			Result [186] := "ordm"		-- masculine ordinal indicator
			Result [187] := "raquo"		-- angle quotation mark (right)
			Result [188] := "frac14"	-- fraction 1/4
			Result [189] := "frac12"	-- fraction 1/2
			Result [190] := "frac34"	-- fraction 3/4
			Result [191] := "iquest"	-- inverted question mark
			Result [192] := "Agrave"	-- capital a, grave accent
			Result [193] := "Aacute"	-- capital a, acute accent
			Result [194] := "Acirc"		-- capital a, circumflex accent
			Result [195] := "Atilde"	-- capital a, tilde
			Result [196] := "Auml"		-- capital a, umlaut mark
			Result [197] := "Aring"		-- capital a, ring
			Result [198] := "AElig"		-- capital ae
			Result [199] := "Ccedil"	-- capital c, cedilla
			Result [200] := "Egrave"	-- capital e, grave accent
			Result [201] := "Eacute"	-- capital e, acute accent
			Result [202] := "Ecirc"		-- capital e, circumflex accent
			Result [203] := "Euml"		-- capital e, umlaut mark
			Result [204] := "Igrave"	-- capital i, grave accent
			Result [205] := "Iacute"	-- capital i, acute accent
			Result [206] := "Icirc"		-- capital i, circumflex accent
			Result [207] := "Iuml"		-- capital i, umlaut mark
			Result [208] := "ETH"		-- capital eth, Icelandic
			Result [209] := "Ntilde"	-- capital n, tilde
			Result [210] := "Ograve"	-- capital o, grave accent
			Result [211] := "Oacute"	-- capital o, acute accent
			Result [212] := "Ocirc"		-- capital o, circumflex accent
			Result [213] := "Otilde"	-- capital o, tilde
			Result [214] := "Ouml"		-- capital o, umlaut mark			
			Result [215] := "times"		-- multiplication
			Result [216] := "Oslash"	-- capital o, slash
			Result [217] := "Ugrave"	-- capital u, grave accent
			Result [218] := "Uacute"	-- capital u, acute accent
			Result [219] := "Ucirc"		-- capital u, circumflex accent
			Result [220] := "Uuml"		-- capital u, umlaut mark
			Result [221] := "Yacute"	-- capital y, acute accent
			Result [222] := "THORN"		-- capital THORN, Icelandic
			Result [223] := "szlig"		-- small sharp s, German
			Result [224] := "agrave"	-- small a, grave accent
			Result [225] := "aacute"	-- small a, acute accent
			Result [226] := "acirc"		-- small a, circumflex accent
			Result [227] := "atilde"	-- small a, tilde
			Result [228] := "auml"		-- small a, umlaut mark
			Result [229] := "aring"		-- small a, ring
			Result [230] := "aelig"		-- small ae
			Result [231] := "ccedil"	-- small c, cedilla
			Result [232] := "egrave"	-- small e, grave accent
			Result [233] := "eacute"	-- small e, acute accent
			Result [234] := "ecirc"		-- small e, circumflex accent
			Result [235] := "euml"		-- small e, umlaut mark
			Result [236] := "igrave"	-- small i, grave accent
			Result [237] := "iacute"	-- small i, acute accent
			Result [238] := "icirc"		-- small i, circumflex accent
			Result [239] := "iuml"		-- small i, umlaut mark
			Result [240] := "eth"		-- small eth, Icelandic
			Result [241] := "ntilde"	-- small n, tilde
			Result [242] := "ograve"	-- small o, grave accent
			Result [243] := "oacute"	-- small o, acute accent
			Result [244] := "ocirc"		-- small o, circumflex accent
			Result [245] := "otilde"	-- small o, tilde
			Result [246] := "ouml"		-- small o, umlaut mark
			Result [247] := "divide"	-- division
			Result [248] := "oslash"	-- small o, slash
			Result [249] := "ugrave"	-- small u, grave accent
			Result [250] := "uacute"	-- small u, acute accent
			Result [251] := "ucirc"		-- small u, circumflex accent
			Result [252] := "uuml"		-- small u, umlaut mark
			Result [253] := "yacute"	-- small y, acute accent
			Result [254] := "thorn"		-- small thorn, Icelandic
			Result [255] := "yuml"		-- small y, umlaut mark

			Result [338] := "OElig"		-- capital ligature OE
			Result [339] := "oelig"		-- small ligature oe
			Result [352] := "Scaron"	-- capital S with caron
			Result [353] := "scaron"	-- small S with caron
			Result [376] := "Yuml"		-- capital Y with diaeres
		end

	Default_entity: STRING = ""

end