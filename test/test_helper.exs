apps_to_start = [:mox]
Enum.each(apps_to_start, &Application.ensure_all_started/1)
ExUnit.start()
Mox.defmock(Rainex.Http.ClientMock, for: Rainex.Http.Behaviour)
Application.put_env(:rainex, :http_client, Rainex.Http.ClientMock)
