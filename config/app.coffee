import {Web} from '@emerald-js/web'
import Example from '../src/provider/example'
import Serverless from '../src/provider/serverless'

export default {
	env: env 'ENV', 'local'
	name: env 'NAME', 'serverless-service'
	debug: env 'DEBUG', false

	secret: [
		env 'SECRET_1'
		env 'SECRET_2'
		env 'SECRET_3'
	]

	services:
		web: Web,
		example: Example,
		serverless: Serverless
}
