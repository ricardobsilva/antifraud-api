# My Rails Application

## Preparing the Application

To load data from the spreadsheet (which will be used to assist in determining whether to accept or reject a particular transaction), run the following command:

```bash
   rails import_csv:import_data
```

## Running the Application

```bash
bundle install
bundle exec rails db:create db:migrate
bundle exec rails s
```


## Running Tests
```bash
bundle exec rspec spec/
```