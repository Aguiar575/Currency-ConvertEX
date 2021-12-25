# Currency ConvertEX

This project is an API for currency conversion. <br/>
The API consumes the external service from https://exchangeratesapi.io/documentation/. <br/>
<br/>
As this API makes use of the free version, the following conversions are available: <br/>
EUR to: BRL, USD, EUR and JPY <br/>
or <br/>
BRL, USD, EUR and JPY to: EUR <br/>

## Installation and Usage

Steps to run:

    $ mix deps.get

    $ mix ecto.create
    
    $ mix ecto.migrate
    
    $ mix phx.server

Done! the API is ready to use <br/>
To check the integrity, just run the tests with: 
   
    $ mix test

## Documentation
To generate the documentation, just run:
   
    $ mix docs

## Technologies Used

[Phoenix framework](https://phoenixframework.org), was used for being lightweight, brings the essential libraries for building applications. <br/>
The project was planned as a simple development, up to 7 days of construction, the API was built based on the MVC architecture pattern. <br/>
The project layers follows the phoenix directory pattern, to find out more just access the [structure documentation](https://hexdocs.pm/phoenix/directory_structure.html). <br/>
<br/>
The main libraries used in the project are: <br/>
- [logger_file_backend](https://hexdocs.pm/logger_file_backend/readme.html): used to save error logs to a separate file.
- [ex_doc](https://github.com/elixir-lang/ex_doc): used to generate project documentation.
- [httpoison](https://hexdocs.pm/httpoison/HTTPoison.html): used to make requests with the external API.
- [Ecto.Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html): was used to validate the data to be inserted into the database.
- [SQLite3](https://hexdocs.pm/ecto_sqlite3/Ecto.Adapters.SQLite3.html): Embedded database chosen because it is one of the database standards available with phoenix.
