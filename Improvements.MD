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