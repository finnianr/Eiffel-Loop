note
	description: "Summary description for {EL_MIXED_FONT_STYLEABLE_I}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
