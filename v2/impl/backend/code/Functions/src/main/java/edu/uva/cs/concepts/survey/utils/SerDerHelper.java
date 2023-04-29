package edu.uva.cs.concepts.survey.utils;


import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.io.InputStream;

/**
 * Use FQCNs to avoid conflicts with lambda handlers.
 */
public class SerDerHelper {

  public static edu.uva.cs.concepts.survey.model.Submissions toSubmissions(InputStream data) {
    try {
      ObjectMapper objectMapper = new ObjectMapper();
      return objectMapper.readValue(data, edu.uva.cs.concepts.survey.model.Submissions.class);
    } catch (IOException e) {
      e.printStackTrace();
    }
    return null;
  }

  public static edu.uva.cs.concepts.survey.model.Submission toSubmission(InputStream data) {
    try {
      ObjectMapper objectMapper = new ObjectMapper();
      return objectMapper.readValue(data, edu.uva.cs.concepts.survey.model.Submission.class);
    } catch (IOException e) {
      e.printStackTrace();
    }
    return null;
  }

  public static String toJson(Object value) {
    ObjectMapper objectMapper = new ObjectMapper();
    try {
      return objectMapper.writeValueAsString(value);
    } catch (JsonProcessingException e) {
      e.printStackTrace();
    }
    return "";
  }

}
