note
	description: "[
		Same as [$source SOURCE_LINK_SUBSTITUTION] except the output will appear in a preformated HTML section
		so there is no need for identifier `<a id="source">' in the anchor tag.
		
			<pre>
				The class <a href="http://.." target="_blank">MY_CLASS</a>
			</pre>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-06 14:17:12 GMT (Saturday 6th March 2021)"
	revision: "1"

class
	PREFORMATTED_SOURCE_LINK_SUBSTITUTION

inherit
	SOURCE_LINK_SUBSTITUTION
		redefine
			A_href_template
		end

create
	make

feature {NONE} -- Constants

	A_href_template: ZSTRING
			-- contains to '%S' markers
		once
			Result := "[
				<a href="#" target="_blank">#</a>
			]"
		end

end