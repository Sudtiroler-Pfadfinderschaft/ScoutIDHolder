package bz.pfadfinder.rest;

import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

@Service
public class ScoregService {

    @Value("${scoreg.url}")
    private String url;

    @Value("${scoreg.apiKey}")
    private String apiKey;

    private RestClient restClient;

    @PostConstruct
    public void init() {
        restClient = RestClient.builder()
                .baseUrl(url + "ScoregBackend/")
                .defaultHeader("X-API-KEY", apiKey)
                .build();
    }

    public Member getMemberByScoutId(String scoutId) {
        List<Member> list = restClient.get()
                .uri("/public/members/completeScoutId/" + scoutId)
                .retrieve()
                .body(new ParameterizedTypeReference<>() {});
        return list != null && !list.isEmpty() ? list.getFirst() : null;
    }

    private String encodeValue(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }
}
