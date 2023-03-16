package via.doc1.devopsdemo.controller;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mockito;
import org.skyscreamer.jsonassert.JSONAssert;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.RequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import via.doc1.devopsdemo.model.Task;
import via.doc1.devopsdemo.service.TeamService;

@ExtendWith(SpringExtension.class)
@WebMvcTest(value = TeamController.class)
public class TeamControllerTest {

    @SuppressWarnings("SpringJavaInjectionPointsAutowiringInspection")
    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private TeamService teamService;

    Task mockTask = new Task("Task1", "IoT Pipeline", "Create CD pipeline for IoT component");
    String jsonTask = "{\"name\":\"IoT Pipeline\",\"description\":\"Create CD pipeline for IoT service\"}";

    @Test
    public void getTaskDetailsTest() throws Exception {
        Mockito.when(teamService.getTask(Mockito.anyString(), Mockito.anyString()))
                .thenReturn(mockTask);

        RequestBuilder requestBuilder = MockMvcRequestBuilders.get("/members/Member1/tasks/Task1")
                .accept(MediaType.APPLICATION_JSON);

        MvcResult result = mockMvc.perform(requestBuilder).andReturn();

        System.out.println(result.getResponse());
        String expected = "{\"id\":\"Task1\",\"name\":\"IoT Pipeline\",\"description\":\"Create CD pipeline for IoT component\"}";

        JSONAssert.assertEquals(expected, result.getResponse().getContentAsString(), false);
    }
}
