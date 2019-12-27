// To run in curl: curl -X POST -d "Edmund" localhost:9090
// It will show: Hello, I think you are Edmund!

import ballerina/http;

// Overwrite base path to "/"
@http:ServiceConfig {
    basePath: "/"
}

service hello on new http:Listener(9090) {
    @http:ResourceConfig {
        // Add a POST method to pass some parameters
        methods: ["POST"],
        // Overwrite base path to "/"
        path: "/"
    }

    resource function sayHello (http:Caller caller, http:Request request) returns @tainted error? {
        // Extract the payload from the request
        var payload = check request.getTextPayload();

        // Create the Response object
        http:Response res = new;

        // Use the payload in the response
        res.setPayload("Hello, I think you are " + <@untainted> payload + "!\n");

        // Send the response back
        _ = check caller->respond(res);
        return;
    }
}