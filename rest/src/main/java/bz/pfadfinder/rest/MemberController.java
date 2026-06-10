package bz.pfadfinder.rest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

public class MemberController {

    @Autowired
    private ScoregService scoregService;

    @GetMapping("/{scoutId}")
    public Member getMember(@PathVariable String scoutId) {
        return scoregService.getMemberByScoutId(scoutId);
    }
}
