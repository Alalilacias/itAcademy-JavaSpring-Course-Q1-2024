package cat.itacademy.barcelonactiva.Allegue.Andres.s04.t01.n02.S04T01N02AndresAllegue.Controllers;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloWorldController {
    @GetMapping("/HelloWorld")
    public String greet(@RequestParam(value = "nom", defaultValue = "UNKNOWN") String name){
        return "Hello, " + name + ". You are running a Gradle project.";
    }
    @GetMapping(value = {"/HelloWorld2" , "/HelloWorld2/{name}"})
    public String greet2(@PathVariable(required = false) String name){
        if (name == null){
            name = "user";
        }
        return "Hello, " + name + ". You are running a Gradle project.";
    }
}
