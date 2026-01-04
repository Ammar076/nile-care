package com.nilecare.security;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;

import java.util.Collection;


public class CustomUserDetails extends User {

    private final String fullName;
    private final boolean accountEnabled;
    private final boolean verified;

    public CustomUserDetails(com.nilecare.model.User user, Collection<? extends GrantedAuthority> authorities) {
        super(user.getEmail(), user.getPasswordHash(), user.isEnabled(), true, true, true, authorities);
        this.fullName = user.getFullName();
        this.accountEnabled = user.isEnabled();
        this.verified = user.isVerified();
    }

    /**
     * Get user initials from full name (e.g., "John Doe" -> "JD")
     * @return uppercase initials, or first letter if only one name, or empty string if null
     */
    public String getInitials() {
        if (fullName == null || fullName.trim().isEmpty()) {
            return "";
        }

        String trimmed = fullName.trim();
        String[] parts = trimmed.split("\\s+");

        if (parts.length == 0) {
            return "";
        } else if (parts.length == 1) {
            return parts[0].substring(0, Math.min(1, parts[0].length())).toUpperCase();
        } else {
            String first = parts[0].substring(0, Math.min(1, parts[0].length()));
            String last = parts[parts.length - 1].substring(0, Math.min(1, parts[parts.length - 1].length()));
            return (first + last).toUpperCase();
        }
    }

    public String getFullName() {
        return fullName;
    }

    public boolean isAccountEnabled() {
        return accountEnabled;
    }

    public boolean isVerified() {
        return verified;
    }
}
