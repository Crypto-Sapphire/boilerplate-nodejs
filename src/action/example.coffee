import {Provider} from '@emerald-js/core'

export default class Example

	constructor: (@c) ->
	handle: (ctx, next) ->
		ctx.response.body = "hoi"

		await next()
