# symfony-job-interview-test

We had a great idea of business: we should do the same thing than bit.ly! And here we are

# Install notes

    composer install
    docker-compose up

# Database structure

    docker-compose exec db  mysql -uroot -pnotsecret symfony-job-interview -e "DROP TABLE IF EXISTS uri; CREATE TABLE uri (id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY, url VARCHAR(1000) NOT NULL, token VARCHAR(255) NOT NULL, times_used INT UNSIGNED NOT NULL);"

# Fixtures

    docker-compose exec db  mysql -uroot -pnotsecret symfony-job-interview -e "INSERT INTO uri VALUES (NULL, 'https://www.youtube.com/watch?v=dQw4w9WgXcQ', 'some_token', 0);"

# How to test

Go to https://127.0.0.1/redirect?token=some_token

#Improvements
- Make the <code>RedirectController</code> extend from <code>Symfony\Bundle\FrameworkBundle\Controller\Controller</code>
- Remove the routes from the config/routes.yaml file
- Add the <code>@routes</code> annotation to the index action in the <code>RedirectController</code>
- Remove the <code>$token = $_GET['token'];</code> and replace it by <code>$token = $request->query->get('token');</code>
  with injection of the <code>Request</code> on index method
- It's not correct to use sql queries on the controller class the bes way is the add a symfony entity
  and symfony repository to the project and inject the repository to the index method.
- It's not correct to use PHP native method like <code>location</code> to make a redirection and exit
  because in the symfony world every controller must return a <code>Response</code> of the <code>HttpFoundation</code> component.

#Bonus
- I added a make file in order to simplify the execution of the symfony commandes inside the docker containers.

