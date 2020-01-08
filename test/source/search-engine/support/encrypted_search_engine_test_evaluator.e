note
	description: "Encrypted search engine test evaluator"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-08 13:39:51 GMT (Wednesday 8th January 2020)"
	revision: "3"

class
	ENCRYPTED_SEARCH_ENGINE_TEST_EVALUATOR

inherit
	SEARCH_ENGINE_TEST_EVALUATOR
		redefine
			item
		end

feature {NONE} -- Internal attributes

	item: ENCRYPTED_SEARCH_ENGINE_TEST_SET

end
