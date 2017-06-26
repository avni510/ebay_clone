EbayClone
---------
This app allows users to post up items for sale and bid on items 

Installation
------------
Clone the git repository
```
https://github.com/avni510/ebay_clone.git
```

`cd` into the directory
```
$ cd ebay_clone
```

Run EbayClone
-------------
 Install dependencies 
```
$ mix deps.get
```

Create and migrate your database 
```
$ mix ecto.create && mix ecto.migrate
```

Install Node.js dependencies 
```
$ npm install
```

Start server 
```
$ mix phoenix.server
```

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

# Run the Tests
Run all the tests
```
$ mix test && npm test
```

Run all elixir tests
```
$ mix test
```

Run all javascript tests
```
$ npm test
```

Auto test runner for elixir tests
```
$ mix test.watch
```




