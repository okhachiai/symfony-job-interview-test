#Questions
1. What does this project do ?
2. What important improvements could you propose? Give us 3 improvements.

#Answers
You can find the improved code here ==> https://github.com/okhachiai/symfony-job-interview-test

1. This project is a symfony application that take a token from the URL on the /redirect route
   search by this token on a database, get the url value of the given token,
   increment the times_used value and redirect to the retrieving url.
   In this given data samples is Youtube video (Rick Astley - Never Gonna Give You Up (Official Music Video))

2. For the improvements : 
- Make the <code>RedirectController</code> extend from <code>Symfony\Bundle\FrameworkBundle\Controller\Controller</code>
- Remove the routes from the config/routes.yaml file
- Add the <code>@routes</code> annotation to the index action in the <code>RedirectController</code>
- Remove the <code>$token = $_GET['token'];</code> and replace it by <code>$token = $request->query->get('token');</code>
  with injection of the <code>Request</code> on index method
- It's not correct to use sql queries on the controller class the bes way is the add a symfony entity
  and symfony repository to the project and inject the repository to the index method.
- It's not correct to use PHP native method like <code>location</code> to make a redirection and exit
  because in the symfony world every controller must return a <code>Response</code> of the <code>HttpFoundation</code> component.
- (Bonus) I added a make file in order to simplify the execution of the symfony commandes inside the docker containers.
