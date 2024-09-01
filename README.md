# Rainex

Simple monitoring service, inspired by the excellent [Elixir cluster article](https://vladimir-sobolev.medium.com/creating-a-cluster-with-elixir-c6aa83be5eca).

Schedule workers to fetch forecasts from Tokyo and Rome in a 10s spans once every 5s
```bash
curl -X POST http://localhost:4001/monitor -H 'Content-Type: application/json' -d '{"period": 10, "frequency": 5, "locations": ["Tokyo", "Rome"]}'
{"id":"d2cd4bd4-688b-11ef-944b-0242ac130004"}
```
Query the monitoring ID
```bash
curl http://localhost:4001/monitor/31a09314-688c-11ef-b373-0242ac130004 | jq
```

Results

```json
{
  "id": "31a09314-688c-11ef-b373-0242ac130004",
  "state": "ready",
  "forecasts": [
    {
      "time": "2024-09-01T18:01:21.022601Z",
      "location": "Tokyo",
      "country": "JP",
      "weather": {
        "temperature": {
          "temp": 27.1,
          "temp_max": 27.8,
          "temp_min": 25.3,
          "temp_unit": "celsius"
        },
        "sunrise": 1725221648,
        "sunset": 1725268092,
        "wind": {
          "deg": 200,
          "speed": 6.17
        }
      }
    },
    {
      "time": "2024-09-01T18:01:21.072765Z",
      "location": "Rome",
      "country": "US",
      "weather": {
        "temperature": {
          "temp": 30.7,
          "temp_max": 33.0,
          "temp_min": 29.3,
          "temp_unit": "celsius"
        },
        "sunrise": 1725189274,
        "sunset": 1725235612,
        "wind": {
          "deg": 49,
          "gust": 2.24,
          "speed": 1.34
        }
      }
    },
    {
      "time": "2024-09-01T18:01:26.075233Z",
      "location": "Tokyo",
      "country": "JP",
      "weather": {
        "temperature": {
          "temp": 27.1,
          "temp_max": 27.8,
          "temp_min": 25.3,
          "temp_unit": "celsius"
        },
        "sunrise": 1725221648,
        "sunset": 1725268092,
        "wind": {
          "deg": 200,
          "speed": 6.17
        }
      }
    },
    {
      "time": "2024-09-01T18:01:26.098709Z",
      "location": "Rome",
      "country": "US",
      "weather": {
        "temperature": {
          "temp": 30.7,
          "temp_max": 33.0,
          "temp_min": 29.3,
          "temp_unit": "celsius"
        },
        "sunrise": 1725189274,
        "sunset": 1725235612,
        "wind": {
          "deg": 49,
          "gust": 2.24,
          "speed": 1.34
        }
      }
    }
  ]
}
```

### Quick setup

Requires an OpenWeatherMap API key

```bash
mix release.init
docker network create cluster-net
docker-compose up --build
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `rainex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:rainex, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/rainex>.

