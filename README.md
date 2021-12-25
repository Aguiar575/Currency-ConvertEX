# Currency ConvertEX

This project is an API for currency conversion. <br/>
The API consumes the external service from https://exchangeratesapi.io/documentation/. <br/>
<br/>
As this API makes use of the free version of external service, the following conversions are available: <br/>
EUR to: BRL, USD, EUR and JPY <br/>
or <br/>
BRL, USD, EUR and JPY to: EUR <br/>

## Installation and Usage

Steps to run:

    $ mix deps.get

    $ mix ecto.create
    
    $ mix ecto.migrate

So that the project can consume the external api it is important that the .secret.exs files are configured. <br/>
inside the Config folder there is a file called secret_example.exs, this file must have replicated to: <br/>
dev.secret.exs / test.secret.exs. <br/>
<br/>
![secrets](https://github.com/Aguiar575/Currency-ConvertEX/blob/main/assets/secrets-exs.png)
<br/>
<br/>
inside this file must contain the key of the external api that the project consumes.

``` elixir
import Config

config :currencyconverter, CurrencyconverterWeb.Endpoint,
  api_key: "some_api_key"
```
Done! the API is ready to use, just run: `$ mix phx.server`.
<br/>
<br/>
To check the integrity, just run the tests with: 
   
    $ mix test

![secrets](https://github.com/Aguiar575/Currency-ConvertEX/blob/main/assets/tests.png)
<br/>
<br/>
The API has two endpoints, one responsible for converting currencies and the other responsible for returning the conversions of a given user.

### POST Endpoint: 
This one does the currency conversion, receives four parameters. <br/>
- user_id: Id of the user doing the conversion. 
- from: currency to be converted.
- to: destination currency for conversion. 
- amount: monetary amount to be converted;
``` javascript   
   http://localhost:4000/api/convert
                             ? user_id= some_id 
                             & from= some_origin_currency
                             & to= some_destination_currency
                             & amount= some_amount
```
return of API:
``` json
{
  "conversion_rate": "0.155671",
  "date_time": "2021-12-24T22:06:20",
  "destination_currency": "EUR",
  "destination_currency_value": "0.31",
  "origin_currency": "BRL",
  "origin_currency_value": "2.00",
  "transaction_id": 14,
  "user_id": "1"
}
```
### GET Endpoint:
this route takes the user id as a parameter and returns all conversions related to this user.

``` javascript   
   http://localhost:4000/api/convert/some_user_id
```
return of API:
``` json
{
  "data": [
    {
      "conversion_rate": "0.155388",
      "date": "2021-12-25T02:48:45",
      "destination_currency": "EUR",
      "origin_currency": "BRL",
      "origin_currency_value": "2.00",
      "user_id": "1"
    }
  ]
}
```

## Documentation
To generate the documentation, just run:
   
    $ mix docs

## Technologies Used

[Phoenix framework](https://phoenixframework.org), was used for being lightweight, brings the essential libraries for building applications. <br/>
The project was planned as a simple development, up to 7 days of construction. <br/>
The API was built based on the MVC architecture pattern, and project layers follows the phoenix directory pattern, to find out more just access the [structure documentation](https://hexdocs.pm/phoenix/directory_structure.html). <br/>
<br/>
The main libraries used in the project are: <br/>
- [logger_file_backend](https://hexdocs.pm/logger_file_backend/readme.html): used to save error logs to a separate file.
- [ex_doc](https://github.com/elixir-lang/ex_doc): used to generate project documentation.
- [httpoison](https://hexdocs.pm/httpoison/HTTPoison.html): used to make requests with the external API.
- [Ecto.Changeset](https://hexdocs.pm/ecto/Ecto.Changeset.html): was used to validate the data to be inserted into the database.
- [SQLite3](https://hexdocs.pm/ecto_sqlite3/Ecto.Adapters.SQLite3.html): Embedded database chosen because it is one of the database standards available with phoenix.
