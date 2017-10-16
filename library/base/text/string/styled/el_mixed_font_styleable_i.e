note
	description: "Summary description for {EL_MIXED_FONT_STYLEABLE_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:59 GMT (Thursday 12th October 2017)"
	revision: "2"

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