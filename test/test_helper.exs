apps_to_start = [:mox]
Enum.each(apps_to_start, &Application.ensure_all_started/1)
ExUnit.start()
Mox.defmock(Metex.Http.ClientMock, for: Metex.Http.Behaviour)
Application.put_env(:metex, :http_client, Metex.Http.ClientMock)
