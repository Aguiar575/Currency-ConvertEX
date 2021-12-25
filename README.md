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
