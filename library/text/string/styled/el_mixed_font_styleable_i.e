note
	description: "Summary description for {EL_MIXED_FONT_STYLEABLE_I}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-03-26 13:52:43 GMT (Wednesday 26th March 2014)"
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
