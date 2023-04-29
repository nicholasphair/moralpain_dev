package edu.uva.cs.concepts.survey;

import com.amazonaws.util.StringInputStream;
import edu.uva.cs.concepts.survey.utils.SerDerHelper;
import org.junit.jupiter.api.Test;

import java.io.InputStream;
import java.io.UnsupportedEncodingException;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class SerDerTest {

    @Test
    public void test_to_submissions() {
        InputStream data = getClass().getClassLoader().getResourceAsStream("submissions.json");
        edu.uva.cs.concepts.survey.model.Submissions submissions = SerDerHelper.toSubmissions(data);
        assertEquals(submissions.size(), 1);
    }

    @Test
    public void test_empty_submission() throws UnsupportedEncodingException {
        edu.uva.cs.concepts.survey.model.Submission submission = SerDerHelper.toSubmission(new StringInputStream("{}"));
        assertTrue(submission.getSelections() == null);
    }

}