package cat.itacademy.barcelonactiva.Allegue.Andres.s05.t01.n01.S05T01N01AllegueAndres.controllers;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("")
public class WebController {
    @GetMapping("/documentation")
    public String documentation(){
        return "public_pages/documentation";
    }
    @GetMapping("/manager")
    public String manager(){
        return "public_pages/manager";
    }
    @GetMapping("/contact")
    public String contact(){
        return "public_pages/contact";
    }
    @GetMapping("/profile")
    public String profile(Model model){
        if (isAuthenticated()){
            return "public_pages/profile";
        }

        model.addAttribute("modal_pressed", true);
        return "/";
    }

    // This method checks if the user is authenticated
    private boolean isAuthenticated() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return authentication != null && authentication.isAuthenticated() && !"anonymousUser".equals(authentication.getPrincipal());
    }
}
