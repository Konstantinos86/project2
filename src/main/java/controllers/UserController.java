package controllers;

import entities.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import services.AccountService;
import services.GenericService;
import services.NotificationService;
import services.UserService;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.util.ArrayList;
import java.util.List;

@SuppressWarnings("SameReturnValue")
@RequestMapping("/users")
@Controller
public class UserController {

    private final GenericService genericService;
    private final UserService userService;
    private final AccountService accountService;
    private final NotificationService notificationService;

    @Autowired
    public UserController(GenericService genericService, UserService userService, AccountService accountService, NotificationService notificationService) {
        this.genericService = genericService;
        this.userService = userService;
        this.accountService = accountService;
        this.notificationService = notificationService;
    }

    @GetMapping("/all")
    public String viewUsers(Model m,
                            HttpSession session) {

        User u = (User) session.getAttribute("user");
        if (u == null || !u.isAdmin()) return "redirect:/users/login";

        m.addAttribute("users", genericService.getAll(User.class, true));
        return "users";
    }

    @GetMapping("/register")
    public String registerChoice() {
        return "register-choice";
    }

    @GetMapping("/register/{type}")
    public String registerForm(@ModelAttribute("user") User user,
                               @PathVariable int type,
                               Model m) {

        m.addAttribute("type", type);
        return "register";
    }

    @PostMapping("/register/{type}")
    public String register(@Valid @ModelAttribute("user") User user,
                           BindingResult result,
                           @PathVariable int type,
                           HttpSession session) {

        switch (type) {
            case 2:
            case 3:
                user.setRole(genericService.getById(Role.class, type));
                break;
            default:
                return "redirect:/users/register";
        }

        if (userService.exists(user) != null)
            result.rejectValue("email", "email.exists", "email already exists!");

        Contact c = null;
        if (type == 2) {
            c = user.getContact();
            if (c.getCity().isEmpty()) result.rejectValue("contact.city", "city.empty", "Must not be empty!");
            if (c.getRegion().isEmpty()) result.rejectValue("contact.region", "region.empty", "Must not be empty!");
            if (c.getAddress().isEmpty()) result.rejectValue("contact.address", "address.empty", "Must not be empty!");
            if (c.getSsn().isEmpty()) result.rejectValue("contact.ssn", "ssn.empty", "Must not be empty!");
        }

        if (result.hasErrors()) return "register";

        user.setContact(null);
        userService.register(user);

        if (type == 2) {
            c.setUserByUserId(user);
            userService.insertContact(c);
        }

        session.setAttribute("user", genericService.getById(User.class, user.getUserId()));

        return "redirect:/";
    }

    @GetMapping("/login")
    public String loginForm(@ModelAttribute("user") User user) {
        return "login";
    }

    @PostMapping("/login")
    public String login(HttpSession session, @ModelAttribute("user") User user, BindingResult result) {

        User u;

        if ((u = userService.login(user)) != null) {
            session.setAttribute("user", u);
            return "redirect:/";
        } else {
            result.rejectValue("email", "login.fail", "Login Failed");
            return "login";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    @PostMapping("/balance")
    public ResponseEntity<Double> getBalance(HttpSession session) {
        User u = (User) session.getAttribute("user");
        if (u == null) return new ResponseEntity<>(HttpStatus.FORBIDDEN);
        else return new ResponseEntity<>(accountService.getBalance(u), HttpStatus.OK);
    }

    @ModelAttribute("all_roles")
    public List<Role> getAllRoles() {
        return genericService.getAll(Role.class, true);
    }

    @ModelAttribute("categories")
    public List<Category> fetchCategories() {
        return genericService.getAll(Category.class, true);
    }

    @ModelAttribute("all_notifications")
    public List<Product> fetchNotifications(HttpSession session) {
        User u = (User) session.getAttribute("user");
        if (u == null) return new ArrayList<>();
        else return notificationService.readNotifications(u);
    }
}
