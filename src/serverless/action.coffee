export default class Action
	middleware: []

	constructor: (@c, @name, handler) ->
		if typeof handler == 'string'
			name = handler
			@handler = (...args) =>
				actualHandler = await @c.get name

				if 'handle' of actualHandler and typeof actualHandler.handle == 'function'
					actualHandler.handle args...
				else if typeof actualHandler
					actualHandler args...

				throw new Error "handler on #{name}, should be a function or a class with the function handle"
		else
			@handler = handler

	with: (...names) ->
		@middleware.push names...

	get: ->
		[@middleware, @handler]
