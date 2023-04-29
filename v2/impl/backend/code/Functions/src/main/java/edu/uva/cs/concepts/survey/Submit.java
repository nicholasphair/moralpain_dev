package edu.uva.cs.concepts.survey;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.APIGatewayV2HTTPEvent;
import com.amazonaws.services.lambda.runtime.events.APIGatewayV2HTTPResponse;
import edu.uva.cs.concepts.survey.utils.S3Helper;
import edu.uva.cs.concepts.survey.utils.SerDerHelper;
import edu.uva.cs.concepts.survey.utils.VariableManager;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.utils.StringInputStream;

import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import static edu.uva.cs.concepts.survey.utils.S3Helper.createS3Client;

public class Submit implements RequestHandler<APIGatewayV2HTTPEvent, APIGatewayV2HTTPResponse> {
    @Override
    public APIGatewayV2HTTPResponse handleRequest(APIGatewayV2HTTPEvent apiGatewayV2HTTPEvent, Context context) {
        APIGatewayV2HTTPResponse response = new APIGatewayV2HTTPResponse();
        if(!isValidEvent(apiGatewayV2HTTPEvent)) {
            context.getLogger().log("invalid event");
            response.setStatusCode(500);
            return response;
        }

        VariableManager variableManager = new VariableManager();
        if(!isValidEnvironment(variableManager)) {
            context.getLogger().log("invalid environment");
            response.setStatusCode(500);
            return response;
        }

        String bucket = variableManager.get("bucket");
        String prefix = variableManager.getOrDefault("prefix", "");
        String key = prefix.isEmpty() ? "submissions.json" : String.format("%s/%s", prefix, "submissions.json");
        S3Client client = createS3Client(variableManager);

        InputStream inputStream = S3Helper.getObject(client, bucket, key);
        if(inputStream == null) {
            context.getLogger().log("Could not load previous submissions.");
            response.setStatusCode(500);
            return response;
        }

        edu.uva.cs.concepts.survey.model.Submissions submissions = SerDerHelper.toSubmissions(inputStream);
        if(submissions == null) {
            context.getLogger().log("Could not deserialize data in S3.");
            response.setStatusCode(500);
            return response;
        }

        String body = apiGatewayV2HTTPEvent.getBody();
        edu.uva.cs.concepts.survey.model.Submission submission = SerDerHelper.toSubmission(new StringInputStream(body));
        if(submission == null) {
            context.getLogger().log(String.format("Submission body is corrupt.\n%s", body));
            response.setStatusCode(500);
            return response;
        }

        if(!submissions.add(submission)) {
            context.getLogger().log("Failed to add submission.");
            response.setStatusCode(500);
            return response;
        }

        String serialized = SerDerHelper.toJson(submissions);
        if(serialized.isEmpty()) {
            context.getLogger().log("Failed to serialize data to add.");
            response.setStatusCode(500);
            return response;
        }

        boolean success = S3Helper.putSerializedObject(client, bucket, key, serialized);
        if(!success) {
            context.getLogger().log("Failed to upload submission.");
            response.setStatusCode(500);
            return response;
        }

        Map<String, String> headers = new HashMap<>();
        headers.put("Content-Type", "application/json");
        headers.put("X-Custom-Header", "application/json");
        // Cors. 
        headers.put("Access-Control-Allow-Headers", "Content-Type,X-Amz-Date,Authorization,X-Api-Key");
        headers.put("Access-Control-Allow-Origin", "*");
        headers.put("Access-Control-Allow-Methods", "*");
        response.setHeaders(headers);
        response.setStatusCode(200);

        return response;
    }

    private boolean isValidEnvironment(VariableManager variableManager) {
        return variableManager.containsKey("bucket") && !variableManager.getOrDefault("bucket", "").isEmpty();
    }

    private boolean isValidEvent(APIGatewayV2HTTPEvent event) {
        return event != null && isValidBody(event.getBody());
    }

    private boolean isValidBody(String body) {
        return body != null && !body.isEmpty();
    }
}
