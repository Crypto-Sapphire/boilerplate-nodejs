import bootstrap from '../src/app'
import actions from '../config/_actions.json'

define = (name) =>
	(req, ...args) =>
		app = await bootstrap()
		serverless = await app.getService 'serverless'

		await serverless.run name, { request: req, req }

handlers = {}

for action in actions
	handlers[action] = define action

export default handlers
