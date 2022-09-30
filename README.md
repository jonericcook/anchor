# Anchor Take Home Coding Challenge

## Start the app

`docker-compose up`

## Endpoints

`POST` `http://localhost:4000/signup`

request body

`{ "username": "hello", "password": "there" }`

response
```
{
    "user": {
        "id": 1,
        "password": "there",
        "username": "hello"
    }
}
```

`GET` `http://localhost:4000/auth`

For Authorization use Basic Auth header

Set Username to `hello` and Password to `there`

Example in Postman below
[![Postman](postman.png)

response
```
{
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJKb2tlbiIsImV4cCI6MTY2NDUyNjIwOSwiaWF0IjoxNjY0NTE5MDA5LCJpc3MiOiJKb2tlbiIsImp0aSI6IjJzY291ZTI1ZDVyNnFtaHVrazAwMDBkMSIsIm5iZiI6MTY2NDUxOTAwOSwicGFzc3dvcmQiOiJ0aGVyZSIsInVzZXJuYW1lIjoiaGVsbG8ifQ.5jsmFb-KWxJh4nNH9tqInEEB83S_J2f4C7lIBCA0mq4"
}
```

**Note:** The token received from `/auth` must be placed as the Bearer Token for all the endpoints below.


`POST` `http://localhost:4000/transactions`

request body
```
{
    "type": "adjustment", "status": "executed", "quote_currency": "EOS", "quote_currency_amount": "3.0"
}
```

response
```
{
    "data": {
        "id": 1,
        "quote_currency": "EOS",
        "quote_currency_amount": 3.0,
        "status": "executed",
        "type": "adjustment"
    }
}
```

`DELETE` `http://localhost:4000/transactions/1`

`GET` `http://localhost:4000/transactions/ss/quote_currency_amount/entire_dataset`

`GET` `http://localhost:4000/transactions/ss/quote_currency_amount/stock_buy`

`GET` `http://localhost:4000/transactions/ss/quote_currency_amount/each_type`

`GET` `http://localhost:4000/transactions/ss/quote_currency_amount/each_type_quote_currency_combo`