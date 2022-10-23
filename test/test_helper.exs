ExUnit.start()

Mox.defmock(Metex.Http.ClientMock, for: Metex.Http.Behaviour)
Application.put_env(:metex, :http_client, Metex.Http.ClientMock)
