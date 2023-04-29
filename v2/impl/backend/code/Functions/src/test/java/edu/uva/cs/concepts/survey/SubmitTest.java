package edu.uva.cs.concepts.survey;

import com.adobe.testing.s3mock.junit5.S3MockExtension;
import com.amazonaws.services.lambda.runtime.events.APIGatewayV2HTTPEvent;
import com.amazonaws.services.lambda.runtime.events.APIGatewayV2HTTPResponse;
import edu.uva.cs.concepts.survey.s3.MockContext;
import edu.uva.cs.concepts.survey.utils.S3Helper;
import edu.uva.cs.concepts.survey.utils.SerDerHelper;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.RegisterExtension;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.*;
import software.amazon.awssdk.utils.builder.SdkBuilder;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.net.URISyntaxException;
import java.util.stream.Collectors;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class SubmitTest {
    @RegisterExtension
    static final S3MockExtension S3_MOCK =
            S3MockExtension.builder().silent().withSecureConnection(false).build();
    private final S3Client s3Client = S3_MOCK.createS3ClientV2();

    private static final String BUCKET_NAME = "test-submissions";

    private static final String PREFIX_NAME = "";

    @BeforeAll
    private static void initializeEnvironment() {
        System.setProperty("overrideEndpoint", S3_MOCK.getServiceEndpoint());
        System.setProperty("accessKeyId", "foo");
        System.setProperty("secretAccessKey", "bar");
        System.setProperty("bucket", BUCKET_NAME);
        System.setProperty("prefix", PREFIX_NAME);
    }

    @BeforeEach
    public void setup() throws URISyntaxException {
        CreateBucketRequest createBucketRequest = CreateBucketRequest.builder()
                .bucket(BUCKET_NAME)
                .build();
        s3Client.createBucket(createBucketRequest);

        edu.uva.cs.concepts.survey.model.Submissions submissions = new edu.uva.cs.concepts.survey.model.Submissions();

        S3Helper.putSerializedObject(s3Client, BUCKET_NAME,  "submissions.json", SerDerHelper.toJson(submissions));

    }

    @AfterEach
    public void teardown() {
        s3Client.listBuckets().buckets().stream().map(Bucket::name).forEach(bucket ->
                s3Client.deleteObjects(d -> d.bucket(bucket)
                        .delete(Delete.builder().objects(s3Client.listObjectsV2(b -> b.bucket(bucket).build())
                                        .contents()
                                        .stream()
                                        .map(S3Object::key)
                                        .map(ObjectIdentifier.builder()::key)
                                        .map(SdkBuilder::build)
                                        .collect(Collectors.toList()))
                                .build())
                        .build()));

        s3Client.listBuckets().buckets().stream()
                .map(Bucket::name)
                .map(DeleteBucketRequest.builder()::bucket)
                .map(SdkBuilder::build)
                .forEach(s3Client::deleteBucket);
    }

    @Test
    public void test_mappings_updated_on_send() throws FileNotFoundException, URISyntaxException {
        Submit submit = new Submit();
        APIGatewayV2HTTPEvent event = new APIGatewayV2HTTPEvent();

        // Load a single dummy submission into a string.
        File data = new File(getClass().getClassLoader().getResource("submissions.json").toURI());
        edu.uva.cs.concepts.survey.model.Submissions submissions = SerDerHelper.toSubmissions(new FileInputStream(data));
        String serialized = SerDerHelper.toJson(submissions.get(0));

        event.setBody(serialized);

        APIGatewayV2HTTPResponse response = submit.handleRequest(event, new MockContext());
        assertEquals(200, response.getStatusCode());

        edu.uva.cs.concepts.survey.model.Submissions result = SerDerHelper.toSubmissions(S3Helper.getObject(s3Client, BUCKET_NAME, "submissions.json"));
        assertEquals(1, result.size());
    }

    @Test
    public void test_empty_payload() throws FileNotFoundException, URISyntaxException {
        Submit submit = new Submit();
        APIGatewayV2HTTPEvent event = new APIGatewayV2HTTPEvent();

        event.setBody("");

        APIGatewayV2HTTPResponse response = submit.handleRequest(event, new MockContext());
        assertEquals(500, response.getStatusCode());
    }

}