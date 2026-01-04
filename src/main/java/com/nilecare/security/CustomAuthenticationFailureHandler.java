package com.nilecare.security;

import com.nilecare.exception.AccountDisabledException; // Keep if you have this custom class
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.DisabledException; // Standard Spring Exception
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;
import org.springframework.stereotype.Component;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Component
public class CustomAuthenticationFailureHandler extends SimpleUrlAuthenticationFailureHandler {

    @Override
    public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
                                       AuthenticationException exception) throws IOException, ServletException {
        
        // CASE 1: Account is Deactivated/Disabled
        // We check for both standard Spring DisabledException and your custom one
        if (exception instanceof DisabledException || 
            (exception.getCause() instanceof AccountDisabledException)) {
            
            // Redirect to a specific URL flag so auth.html knows to show the "Banned" banner
            setDefaultFailureUrl("/login?deactivated=true");
        } 
        // CASE 2: Wrong Password / User not found
        else if (exception instanceof BadCredentialsException) {
            setDefaultFailureUrl("/login?error=true");
        } 
        // CASE 3: Other errors
        else {
            setDefaultFailureUrl("/login?error=true");
        }
        
        super.onAuthenticationFailure(request, response, exception);
    }
}