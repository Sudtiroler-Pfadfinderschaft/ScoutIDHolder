package bz.pfadfinder.rest;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class RestApplication {

	public static void main(String[] args) {
		var context = SpringApplication.run(RestApplication.class, args);

		ScoregService scoregService = context.getBean(ScoregService.class);
		Member member = scoregService.getMemberByScoutId("EPP00174");

		if (member != null)
			System.out.println("Name: " + member.getFirstname() + " " + member.getLastname());
	}
}
