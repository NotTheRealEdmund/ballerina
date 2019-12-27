// To run it in cmd: ballerina run hello_world.bal
// To invoke in browser: localhost:9090/hello/hi
// To kill the service in cmd: Ctrl-C
import ballerina/http;

// Services, endpoints, resources are built into the language
// This one is a HTTP service (other options include WebSockets, Protobuf, gRPC, etc) binded to port 9090
service hello on new http:Listener(9090) {

     // The service exposes one resource (hi)
     // It gets the endpoint that called it - so we can pass response back and the request object to extract payload, etc
     resource function hi (http:Caller caller, http:Request request) returns error? {
          // Create the Response object
          http:Response res = new;

          // Set the payload.
          res.setPayload("Hello World!\n");

          // Send the response back. '->' means remote call ('.' means local)
          // _ means ignore the value that the call returns
          _ = check caller->respond(res);
          return;
     }

}