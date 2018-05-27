note
	description: "Mixed font styleable i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:48 GMT (Saturday 19th May 2018)"
	revision: "4"

deferred class
	EL_MIXED_FONT_STYLEABLE_I

feature -- Element change

	set_bold
		deferred
		end

	set_regular
		deferred
		end

	set_monospaced
		deferred
		end

	set_monospaced_bold
		deferred
		end

feature -- Measurement

	bold_width (text: READABLE_STRING_GENERAL): INTEGER
		deferred
		end

	regular_width (text: READABLE_STRING_GENERAL): INTEGER
		deferred
		end

	monospaced_width (text: READABLE_STRING_GENERAL): INTEGER
		deferred
		end

	monospaced_bold_width (text: READABLE_STRING_GENERAL): INTEGER
		deferred
		end

end