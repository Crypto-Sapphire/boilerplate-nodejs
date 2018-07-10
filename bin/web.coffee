import bootstrap from '../src/app'

bootstrap().then (app) ->
	service = await app.getService 'web'
	service.listen 8888
