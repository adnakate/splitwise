Topics covered
- sign up
- sign in
- list of users
- create equal expense
- create unequal expense
- create/settle payment
- dashboard (Total balance, message(owe/owed by), list of friends who owe money, list of friends whom you owe money, list of settelled friends)
- friends expenses (list of expenses/list of payments)


This is the api only app in rails. I have covered all the topics. 

You can integrate these apis with both mobile app and web app.


If you want to run it on local follow the steps below
- take clone from github
- Install rails 6
- Install ruby 2.7.2
- Do bundle install inside the folder
- Change database credentials in database.yml accordingly
- Run rake db:create
- Run rake db:migrate

Now you are ready to run the apis!

You can run the test cases with rspec command.

The application is deployed to heroku. You can directly use production api urls.


I am listing out the apis for you here.

1. Sign Up - POST https://splitwise2-0cb1e8dfcde8.herokuapp.com/auth/
Params - email, password, password_confirmation, first_name, last_name

2. Sign in - POST https://splitwise2-0cb1e8dfcde8.herokuapp.com/auth/sign_in
Params - email, password

3. List users - GET https://splitwise2-0cb1e8dfcde8.herokuapp.com/api/v1/users
Params - page

4. Create expense - POST https://splitwise2-0cb1e8dfcde8.herokuapp.com/api/v1/expenses
params - {
  "payer_id": 1,
  "total_amount": 2400,
  "description": "Thanda",
  "expense_type": "expense",
  "contribution_type": "equal",
  "user_ids": "[1,2,3,4]"
}

5.Create payment - POST https://splitwise2-0cb1e8dfcde8.herokuapp.com/api/v1/payments
Params - amount , sender_id, receiver_id

6. Dashboard - GET https://splitwise2-0cb1e8dfcde8.herokuapp.com/api/v1/users/dashboard

7. Friends expenses - GET https://splitwise2-0cb1e8dfcde8.herokuapp.com/api/v1/users/friends_expenses
params - friend_id, page


Technical details covered - 
- Basic rails associations
- All model level validations with custom messages
- Email regex validations with custom messages
- Controller level custom validations
- Serializers
- Pagination
- Added indexes wherever required
- authentication
- Rspec
- Shared examples with rspec
- Efficient APIs
- Heroku

