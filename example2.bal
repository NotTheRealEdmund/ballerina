// We will tweet a message from ballerina to our twitter accounts
// First we need to install connectors to use services which other people in the ballerina community have already created
// Think of connectors as packages in python, just install and use them
// To find more connectors you can use, go to: http://central.ballerina.io
// In VS code cmd, type in:
// ballerina search twitter
// ballerina pull wso2/twitter

// Then create a twitter account 
// Then, create a new file "twitter.toml" in the same folder as example2.bal to store confidential data
// Further instructions are in twitter.toml

// To run, in VS code cmd, type in:
// ballerina run example2 --b7a.config.file=twitter.toml
// To tweet a message, in another cmd, type in:
// curl -X POST -d "I am feeling good today!" localhost:9090

import ballerina/http;
import ballerina/config;   // This package helps read config files, which we need since we're reading data from twitter.toml
import wso2/twitter;     // Remember to import any connectors you've pulled

// Twitter package requires these configurations
twitter:Client tw = new ({
    clientId: config:getAsString("clientId"),
    clientSecret: config:getAsString("clientSecret"),
    accessToken: config:getAsString("accessToken"),
    accessTokenSecret: config:getAsString("accessTokenSecret"),
    clientConfig: {}
});

@http:ServiceConfig {
    basePath: "/"
}
service hello on new http:Listener(9090) {
    @http:ResourceConfig {
        path: "/",
        methods: ["POST"]
    }
    resource function hi (http:Caller caller, http:Request request) returns @tainted error? {
        http:Response res = new;
        string payload = check request.getTextPayload();
        // Use the twitter connector to do the tweet
        twitter:Status st = check tw->tweet(payload);
        // Change the response back
        res.setPayload("Tweeted: " + <@untainted>st.text + "\n");
        _ = check caller->respond(res);
        return;
    }
}