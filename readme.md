This is a ruby version of [Stellar-Tweetbot](https://github.com/mikeindustries/Stellar-Tweetbot) that can run on [Heroku](http://www.heroku.com/) and based on the [code](https://github.com/mattb/flotsam/tree/master/stellar2twitter) by [@mattb](https://github.com/mattb/). 

### Instructions to run on Heroku

1. Clone this repo.
2. Create a new Twitter Account. 
3. Set up a new Twitter application with your new account. Do not click the blue "Create My Access Token" button yet.
4. Click the "Settings" tab and change your App's access to "Read and Write".
5. Click back to the "Details" tab and click the "Create My Access Token" button.
6. Rename the `config.yml.example` to `config.yml` and edit the variables. 
7. Commit, and create a new [Heroku Ceddar application](https://devcenter.heroku.com/articles/ruby#deploy_to_herokucedar). 
8. Run `bundle install` and Push to Heroku. 
9. Add the Heroku Scheduler Addon by running `heroku addons:add scheduler:standard` or by visiting the [addon page](https://addons.heroku.com/scheduler).
10. Add the job `ruby stellar2twitter.rb` to the [Heroku Scheduler](https://heroku-scheduler.herokuapp.com/dashboard)
11. Done!
