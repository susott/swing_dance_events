# About

Rails app to show swing dance events (like lindy hop, balboa or solo jazz festivals) filterable by city and country. Still under construction.

# Development setup

This app is a typical rails app written in ruby 3.3 and rails 7.2. PostgreSQL is used as database. This Rails Guide might be helpful to get a version running locally: [https://guides.rubyonrails.org/development_dependencies_install.html]. The app is not yet configured to work with Dev Containers.

After a successfull setup you can run `rails db:seed` to get a list of example events into your database. Note that only upcoming events will show on the events list, hence it might be necessary to update some dates to actually see events in the browser.

# Test

Tests are written in rspec. Run `rspec` to run the tests.

# Deploy

This app can be deployed with the [kamal](https://kamal-deploy.org/) tool. For this to work, you need to install the kamal gem (locally). The configuration can be found - and adapted - in the config/deploy.yml file. An .env file is needed to store the environment variables. To get started, you can rename .example_env to .env and fill in the respective values.

# TODO / Plans

* Use command pattern in events controller
* Add a simple contact form
* Add option to suggest new events
* Add option to suggest edits of existing events
* Make the page look nice
* Possibly add capybara specs
* Add hotwire / stimulus where it makes sense
* Fetch only new events
