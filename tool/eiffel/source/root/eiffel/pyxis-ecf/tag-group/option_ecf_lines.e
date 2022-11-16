note
	description: "[$source GROUPED_ECF_LINES] for one of **option** tags: **warning** or **debug**"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "3"

deferred class
	OPTION_ECF_LINES

inherit
	GROUPED_ECF_LINES
		redefine
			adjust_value, Template
		end

feature {NONE} -- Implementation

	adjust_value (value: STRING)
		local
			boolean: STRING
		do
			boolean := Boolean_value [value /~ Name.disabled]
			value.share (boolean)
		end

feature {NONE} -- Constants

	Boolean_value: EL_BOOLEAN_INDEXABLE [STRING]
		once
			create Result.make ("false", "true")
		end

	Template: EL_TEMPLATE [STRING]
		once
			Result := "[
				$ELEMENT:
					name = $NAME; enabled = $VALUE
			]"
		end
end