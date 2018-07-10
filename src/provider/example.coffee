import {Provider} from '@emerald-js/core'
import {add} from '@emerald-js/container'
import ExampleAction from '../action/example'

export default class Example
	@register: (c) ->
		c.configure
			'actions': add (r) ->
				r.action 'testHandler', 'action.example'

			'action.example': (c) ->
				new ExampleAction c

			'routes': add (r) ->
				r.get '/', 'action.example'
