import {Provider} from '@emerald-js/core'
import {add} from '@emerald-js/container'
import Action from '../serverless/action'

export default class Serverless extends Provider
	actions: {}
	middleware: []

	@register: (c) ->
		c.define 'actions', add()

	boot: ->
		@mountActions()

	mountActions: ->
		actions = await @c.get 'actions'

		console.log actions

		for action in actions
			await action {
				action: (name, handler) =>
					if name of @actions
						throw new Error "Action '#{name}' is already defined"

					return @actions[name] = new Action @c, name, handler

				use: ({name = false, at = []}, handler) =>
					if name != false and @middleware.find (a) => a.name == name
						throw new Error "Middleware '#{name}' is already defined"

					@middleware.push {name, at, handler}
			}

	run: (name, ctx) ->
		if name not of @actions
			return {
				statusCode: 404,
				body: JSON.stringify
					error: "Action '#{name}' not found"

			}

		ctx.response = {
			statusCode: 200,
			headers: {},
			rawBody: false
			body: ""
		}

		[wantedMiddleware, handler] = @actions[name].get()

		middleware = @collectMiddleware name

		for wanted in wantedMiddleware
			if middleware.find (a) => a.name == wanted
				continue

			middleware.push @middleware.find (a) => a.name == wanted

		stack = middleware.map (x) => x.handler

		stack.push handler

		ctx = await @runStack stack, ctx

		if not ctx.response.rawBody
			{
				statusCode: ctx.response.statusCode,
				body: JSON.stringify ctx.response.body
				headers: ctx.response.headers
			}
		else
			delete ctx.response.rawBody

			ctx.response

	runStack: (stack, ctx) ->
		next = () ->
			if stack.length == 0
				return;

			nextItem = stack.pop()
			await nextItem ctx, next

		next()

		ctx


	collectMiddleware: (name) ->
		collected = []

		for middleware in @middleware
			for matcher in middleware.at

				if (matcher instanceof RegExp and matcher.test name) or \
					(typeof matcher == 'string' and (matcher == name or matcher == '*'))
					collected.push middleware
					break

		collected
